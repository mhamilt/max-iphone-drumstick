#include <stdio.h>
#include "MacosBleCentralC.h"

int main(int argc, const char * argv[])
{
    MacosBleCentralC* bleCentral = newMacosBleCentralC();
    MacosBleCentralC_scanFor(bleCentral, "DEVICE_NAME");
    while(1);
    return 0;
}
