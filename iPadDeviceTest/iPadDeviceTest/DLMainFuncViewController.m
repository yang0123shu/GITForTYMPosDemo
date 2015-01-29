//
//  DLMainFuncViewController.m
//  iPadDeviceTest
//
//  Created by bankscene_yang on 15/1/26.
//  Copyright (c) 2015年 YNRCC. All rights reserved.
//

#import "DLMainFuncViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "YinJingService.h"

@interface DLMainFuncViewController ()<CBCentralManagerDelegate,UITableViewDataSource,UITableViewDelegate,CBPeripheralDelegate>
{
    CBCentralManager * _manager;
    NSMutableArray * _peripherals;
    CBPeripheral * _selectedPeripheral;
    NSString * _selectedPeripheralName;
    NSMutableArray * _peripheralsDevices;
    YinJingService * _service;

}
@property (nonatomic) UITableView *peripheralTableView;
@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;

@end

@implementation DLMainFuncViewController
- (IBAction)toGetTYDeviceID:(id)sender {
    NSString * deviceID = [_service getDeviceId];
    NSLog(@"TYDeviceID = %@",deviceID);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _service = [YinJingService shareInstance];
    _manager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    _peripherals = [NSMutableArray array];
    _peripheralsDevices = [NSMutableArray array];
    self.peripheralTableView = [[UITableView alloc]initWithFrame:CGRectMake(240, 100, 300, 400) style:UITableViewStylePlain];
    self.peripheralTableView.dataSource = self;
    self.peripheralTableView.delegate = self;
    [self.view addSubview:self.peripheralTableView];
    // Do any additional setup after loading the view from its nib.
}
int timeLast = 1;
- (IBAction)toDiscoverPeripheral:(id)sender {
    if (_peripherals.count != 0&& _peripheralsDevices.count != 0) {
        [_peripherals removeAllObjects];
        [_peripheralsDevices removeAllObjects];
    }
    
    [_manager scanForPeripheralsWithServices:nil options:nil];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(addTimeLast) userInfo:nil repeats:YES];
}
-(void)addTimeLast
{
    timeLast ++;
    if (timeLast == 60) {
        [_manager stopScan];
    }
}
- (IBAction)toConnectPeripheral:(id)sender {
    if ([_selectedPeripheralName hasPrefix:@"TY"]) {
//        if ([_service connectDevice:_selectedPeripheral]) {
//            NSLog(@"Connect TYDevice successful");
//        }
         dispatch_async(dispatch_get_global_queue(0, 0), ^(void){ if([_service connectDevice:_selectedPeripheral])
         {
             NSLog(@"Connect TYDevice successful");
         };});
    }
//    [_manager connectPeripheral:_selectedPeripheral options:nil];
}
- (IBAction)toCheckConnectionStatus:(id)sender {
    dispatch_async(dispatch_get_global_queue(0, 0), ^(void){ if([_service isDeviceConnected])
    {
        NSLog(@"Connected");
    }
    else{
        NSLog(@"Disconnected");
    }
        ;});
}
- (IBAction)toDisconnectTYDevice:(id)sender {
    dispatch_async(dispatch_get_global_queue(0, 0), ^(void){ if([_service disconnectDevice])
    {
        NSLog(@"Disconnect successful");
    }
    else{
        NSLog(@"Disconnect failed");
    }
        ;});
}
- (IBAction)toGetTYDeviceParams:(id)sender {
    NSThread * thread = [[NSThread alloc]initWithTarget:self selector:@selector(toGetDevice) object:nil];
    [thread setName:@"deviceParams"];
    [thread start];
    
}
-(void)toGetDevice
{
    NSDictionary * TYParams = [_service getDeviceParams];
    NSLog(@"TYParams = %@",TYParams);
}
- (IBAction)toGetCardNum:(id)sender {
    NSThread * thread = [[NSThread alloc]initWithTarget:self selector:@selector(toGetCard) object:nil];
    [thread setName:@"deviceParams"];
    [thread start];
   
}
-(void)toGetCard
{
    self.cardNumLabel.text = [_service getCardNumber:nil Tip:nil];
}
- (IBAction)toCancelCurrentCommand:(id)sender {
    dispatch_async(dispatch_get_global_queue(0, 0), ^(void){ [_service CMD_EmvStop:true RespondTime:3 ResCode:nil];});
    
}


#pragma mark - ====ConnectLBEDevice====
//- (void)connetBLEDevice {
//    
//    if (scanAlert) {
//        scanAlert = nil;
//    }
//    scanAlert = [[MLTableAlert alloc] initWithTitle:@"请选择蓝牙设备" cancelButtonTitle:@"取消" numberOfRows:^NSInteger(NSInteger section) {
//        return _peripheralsDevices.count];
//    } andCells:^UITableViewCell *(MLTableAlert *alert, NSIndexPath *indexPath) {
//        NSString *cellIndentifier = [NSString stringWithFormat:@"cell_%d", (int)indexPath.row];
//        
//        UITableViewCell *cell = [alert.table dequeueReusableCellWithIdentifier:@"BLE"];
//        if(cell == nil) {
//            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIndentifier] autorelease];
//        }
//        
//        @try {
//            CBPeripheral *device = [[[YinJingService shareInstance] scanDevice] objectAtIndex:indexPath.row];
//            
//            cell.textLabel.text = device.name;
//        } @catch (NSException *exception) {
//            return cell;
//        }
//        
//        return cell;
//    }];
//    
//    [scanAlert show];
//    
//    [scanAlert configureSelectionBlock:^(NSIndexPath *selectedIndex) {
//        
//        //        [[bleSDK shareBLEsdkInstance] stopBLEPeripheralScan];
//        
//        @try {
//            CBPeripheral *device = [[[YinJingService shareInstance] scanDevice] objectAtIndex:selectedIndex.row];
//            BOOL bRet = [yinjingService connectDevice:device];
//            if (bRet) {
//                [self.view makeToast:[NSString stringWithFormat:@"已连接%@", device.name] duration:1.0 position:@"top"];
//            } else {
//                [self.view makeToast:[NSString stringWithFormat:@"连接%@失败", device.name] duration:1.0 position:@"top"];
//            }
//        } @catch (NSException *exception) {
//            NSLog(@"%@", exception);
//        } @finally {
//            [scanAlert.table deselectRowAtIndexPath:selectedIndex animated:YES];
//        }
//        
//    } andCompletionBlock:^{
//        
//    }];
//}
#pragma mark - ==== CBCentralManagerDelegate ====
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"centralManagerDidUpdateState");
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"peripheral.name = %@",peripheral.name);
        [_peripherals addObject:peripheral.name];
        [_peripheralsDevices addObject:peripheral];
        [self.peripheralTableView reloadData];
}
- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    
    NSLog(@"peripherals = %@",peripherals);
}
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    peripheral.delegate = self;
    NSLog(@"didDisconnectPeripheral");
}

#pragma mark - ==== UITableViewDataSource ====

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_peripherals.count == 0) {
        [self.peripheralTableView removeFromSuperview];
        return 0;
    }
    else {
        [self.view addSubview:_peripheralTableView];
        return [_peripherals count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:@"peripheralCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"peripheralCell"];
    }
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.textLabel.text = _peripherals[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedPeripheral = _peripheralsDevices[indexPath.row];
    _selectedPeripheralName = _peripherals[indexPath.row];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
