#include <stdio.h>
#include "MacosBleCentralC.h"

int main(int argc, const char * argv[])
{
    MacosBleCentralC* bleCentral = newMacosBleCentralC();
    MacosBleCentralC_scanFor(bleCentral, "BaronVonTigglestest");
    while(1);
    return 0;
}
