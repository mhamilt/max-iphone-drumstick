/*
    C Bridge for CoreBluetooth Central on macOS
*/

#import "MacosBleCentralC.h"

//------------------------------------------------------------------------------
MacosBleCentralC* newMacosBleCentralC(void)
{
    return CFBridgingRetain([MacosBleCentral new]);
}
//------------------------------------------------------------------------------
void MacosBleCentralC_startScan(MacosBleCentralC *t)
{
    [(__bridge MacosBleCentral *)t startScan];
}
//------------------------------------------------------------------------------
void MacosBleCentralC_release(MacosBleCentralC *t)
{
    CFRelease(t);
}
//------------------------------------------------------------------------------
MacosBleCentralRef MacosBleCentralRefCreate(void)
{
     return CFBridgingRetain([MacosBleCentral new]);
}
void MacosBleCentralRefStartScan(MacosBleCentralRef t)
{
    [(__bridge MacosBleCentral *)t startScan];
}
