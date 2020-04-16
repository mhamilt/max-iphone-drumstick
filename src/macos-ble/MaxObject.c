#include "MaxObject.h"
//------------------------------------------------------------------------------
void onBleNotify(MaxExternalObject* maxObjectPtr, int output)
{
    outlet_float(maxObjectPtr->int_out, output);
}
//------------------------------------------------------------------------------
