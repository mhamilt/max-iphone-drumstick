//------------------------------------------------------------------------------
#import "MacosBleCentral.h"
//------------------------------------------------------------------------------
@implementation MacosBleCentral
//------------------------------------------------------------------------------
@synthesize discoveredPeripherals;
//------------------------------------------------------------------------------
- (instancetype)init
{
    dispatch_queue_t newQueue = dispatch_queue_create("max_masp_ble",  DISPATCH_QUEUE_SERIAL);
    return [self initWithQueue:newQueue];
}
//------------------------------------------------------------------------------
- (instancetype)initWithQueue: (dispatch_queue_t) centralDelegateQueue
{
    return [self initWithQueue: centralDelegateQueue
                 serviceToScan: nil
          characteristicToRead: nil];
}
//------------------------------------------------------------------------------
- (instancetype)initWithQueue: (dispatch_queue_t) centralDelegateQueue
                serviceToScan: (CBUUID *) scanServiceId
         characteristicToRead: (CBUUID *) characteristicId
{
    self = [super init];
    if (self)
    {
        post("Start BLE\n");
        self.discoveredPeripherals = [NSMutableArray array];        
        _bleQueue = centralDelegateQueue;
        serviceUuid = scanServiceId;
        characteristicUuid = characteristicId;
        _manager = [[CBCentralManager alloc] initWithDelegate: self
                                                        queue: _bleQueue];
    }
    return self;
}

//------------------------------------------------------------------------------
#pragma mark Manager Methods

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)aPeripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    const char* deviceName = [[aPeripheral name] cStringUsingEncoding:NSASCIIStringEncoding];
    post("Found: %s\n", deviceName);
    
    if ([[aPeripheral name] isEqualToString: @"BaronVonTigglestest"])
    {
        post("Connecting\n");
        _peripheral = aPeripheral;
        [_manager connectPeripheral:_peripheral options:nil];
        [_manager stopScan];
    }
}

//------------------------------------------------------------------------------
- (void) centralManager: (CBCentralManager *)central
   didConnectPeripheral: (CBPeripheral *)aPeripheral
{
    post("Connected\n");
    [aPeripheral setDelegate:self];
    [aPeripheral discoverServices:nil];
}
//------------------------------------------------------------------------------
- (void)centralManagerDidUpdateState:(CBCentralManager *)manager
{
    post("State Update");
    if ([manager state] == CBCentralManagerStatePoweredOn)
    {
        [self startScan];
    }
}
//------------------------------------------------------------------------------
// Invoked whenever an existing connection with the peripheral is torn down.
- (void) centralManager: (CBCentralManager *)central
didDisconnectPeripheral: (CBPeripheral *)aPeripheral
                  error: (NSError *)error
{
    post("didDisconnectPeripheral\n");
    [self startScan];
}
//------------------------------------------------------------------------------
// Invoked whenever the central manager fails to create a connection with the peripheral.
- (void) centralManager: (CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)aPeripheral
                  error:(NSError *)error
{
    post("didFailToConnectPeripheral\n");
    NSLog(@"Fail to connect to peripheral: %@ with error = %@", aPeripheral, [error localizedDescription]);
}


//------------------------------------------------------------------------------
- (void) startScan
{
    post("Start scanning\n");
        [_manager scanForPeripheralsWithServices: nil
                                         options: nil];
}
//------------------------------------------------------------------------------
#pragma mark Peripheral Methods

- (void) peripheral: (CBPeripheral *)peripheral
didDiscoverIncludedServicesForService:(CBService *)service
              error:(NSError *)error
{
    post("didDiscoverIncludedServicesForService");
}
//------------------------------------------------------------------------------
// Invoked upon completion of a -[discoverServices:] request.
// Discover available characteristics on interested services
- (void) peripheral: (CBPeripheral *)aPeripheral
didDiscoverServices: (NSError *)error
{
    post("didDiscoverServices\n");
    for (CBService *aService in aPeripheral.services)
    {
        post("Service %s\n", [[[aService UUID] UUIDString] cStringUsingEncoding:NSASCIIStringEncoding]);
        [aPeripheral discoverCharacteristics: nil
                                  forService: aService];
    }
}
//------------------------------------------------------------------------------
// Invoked upon completion of a -[discoverCharacteristics:forService:] request.
// Perform appropriate operations on interested characteristics
- (void) peripheral: (CBPeripheral *)aPeripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    post("didDiscoverCharacteristicsForService\n");
    for (CBCharacteristic *aChar in service.characteristics)
    {
        if (aChar.properties & CBCharacteristicPropertyRead)
        {
            [aPeripheral readValueForCharacteristic:aChar];
        }
    }
}
//------------------------------------------------------------------------------
- (void) peripheral:(CBPeripheral *)peripheral
didUpdateValueForDescriptor:(CBDescriptor *)descriptor
              error:(NSError *)error
{
    post("didUpdateValueForDescriptor\n");
}
//------------------------------------------------------------------------------
// Invoked upon completion of a -[readValueForCharacteristic:] request or on the reception of a notification/indication.
- (void) peripheral: (CBPeripheral *)aPeripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    post("didUpdateValueForCharacteristic\n");
}
//------------------------------------------------------------------------------
- (void) peripheral: (CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBDescriptor *)descriptor error:(NSError *)error
{
    post("didDiscoverDescriptorsForCharacteristic");
}
//------------------------------------------------------------------------------
- (void)peripheral: (CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    post("didUpdateNotificationStateForCharacteristic");
}
//------------------------------------------------------------------------------
- (void)peripheral: (CBPeripheral *)peripheral didModifyServices:(NSArray<CBService *> *)invalidatedServices
{
    post("Service Modified\n");
    [_manager cancelPeripheralConnection:peripheral];
    [self startScan];
}
//------------------------------------------------------------------------------
@end
