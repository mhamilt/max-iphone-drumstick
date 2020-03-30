/*
  C Bridge for CoreBluetooth Central on macOS
 
 Bridging techinque by Rob Napier. https://github.com/rnapier
 */
#pragma once
#import <CoreFoundation/CoreFoundation.h>
#ifdef __OBJC__
#import "MacosBleCentral.h"
#endif

typedef CFTypeRef MacosBleCentralRef;
MacosBleCentralRef MacosBleCentralRefCreate(void);
void MacosBleCentralRefStartScan(MacosBleCentralRef t);
void MacosBleCentralRefStopScan(MacosBleCentralRef t);

typedef const void MacosBleCentralC; // 'const void *' is more CF-like, but either is fine
MacosBleCentralC* newMacosBleCentralC(void);
void MacosBleCentralC_startScan(MacosBleCentralC *t);
void MacosBleCentralC_stopScan(MacosBleCentralC *t);
void MacosBleCentralC_release(MacosBleCentralC *t);
