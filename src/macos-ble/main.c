/*
    Integrate Objective C Corebluetooth class
 */

#define MAMSP
#include "ext.h"
#include "ext_obex.h"
#include "z_dsp.h"
#include "buffer.h"
#include "MacosBleCentralC.h"
//------------------------------------------------------------------------------
void* myExternClass;
//------------------------------------------------------------------------------
typedef struct _MaxExternalObject
{
    t_pxobject x_obj;
    t_symbol* x_arrayname;
    MacosBleCentralRef bleCentral;
} MaxExternalObject;
//------------------------------------------------------------------------------
void* myExternalConstructor()
{
    MaxExternalObject* maxObjectPtr = (MaxExternalObject*)object_alloc(myExternClass);
    maxObjectPtr->bleCentral = MacosBleCentralRefCreate();
    MacosBleCentralRefScanFor(maxObjectPtr->bleCentral, "DEVICE_NAME");
    return maxObjectPtr;
}
//------------------------------------------------------------------------------
void myExternDestructor(MaxExternalObject* maxObjectPtr)
{
    post("END");
}

//------------------------------------------------------------------------------
int C74_EXPORT main(void)
{
    post("hello");
    t_class* c = class_new("macos-ble",
                           (method)myExternalConstructor,
                           (method)myExternDestructor,
                           (short)sizeof(MaxExternalObject),
                           0L,
                           0);

    class_register(CLASS_BOX, c);
    myExternClass = c;
    
    return 0;
}
