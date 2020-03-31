#pragma once
#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#include <stdio.h>
#include <objc/runtime.h>
#ifdef MAXMSP
#include "ext.h"
#else
#define post printf
#endif

@interface MacosBleCentral: NSObject
<CBCentralManagerDelegate, CBPeripheralDelegate>
{
    CBUUID *serviceUuid;
    CBUUID *characteristicUuid;
}
//------------------------------------------------------------------------------
@property (retain) NSMutableArray *discoveredPeripherals;
@property (strong, nonatomic) NSString *deviceName;
@property (strong, nonatomic) CBCentralManager * manager;
@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, atomic) CBService *currentService;
@property (strong, nonatomic) dispatch_queue_t bleQueue;
@property (copy) NSString *manufacturer;
//------------------------------------------------------------------------------
- (instancetype)init;
- (instancetype)initWithQueue: (dispatch_queue_t) centralDelegateQueue;
- (instancetype)initWithQueue: (dispatch_queue_t) centralDelegateQueue
                serviceToScan: (CBUUID *) scanServiceId
         characteristicToRead: (CBUUID *) characteristicId;
- (void)scanForDeviceWithName: (NSString *) name;
//------------------------------------------------------------------------------
@end
