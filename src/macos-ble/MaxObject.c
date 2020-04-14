#include "MaxObject.h"
void onBleNotify(MaxExternalObject* maxObjectPtr, float output)
{
    outlet_float(maxObjectPtr->float_out, output);
}
