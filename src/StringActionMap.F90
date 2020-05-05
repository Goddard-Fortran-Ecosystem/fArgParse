module fp_StringActionMap
   use fp_BaseAction
#define _map StringActionMap
#define _iterator StringActionMapIterator
#define _pair StringActionPair
#include "types/key_deferredLengthString.inc"
#define _value class(BaseAction)
#define _value_allocatable
#define _alt
#include "templates/map.inc"
end module fp_StringActionMap
