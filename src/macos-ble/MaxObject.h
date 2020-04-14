#pragma once
#include "ext.h"
#include "ext_obex.h"
#include "z_dsp.h"
#include "buffer.h"
//------------------------------------------------------------------------------
typedef CFTypeRef MacosBleCentralRef;
typedef struct _MaxExternalObject
{
    t_pxobject x_obj;
    t_symbol* x_arrayname;
    MacosBleCentralRef bleCentral;
    void* float_out;
} MaxExternalObject;

void onBleNotify(MaxExternalObject* maxObjectPtr, float output);
