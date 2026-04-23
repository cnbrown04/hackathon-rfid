#ifndef RFIDAPI_COMPAT_H
#define RFIDAPI_COMPAT_H

#include "rfidapiTypes.h"

#ifdef WINAPI
#undef WINAPI
#endif
#define WINAPI

#include "rfidapi.h"

#endif
