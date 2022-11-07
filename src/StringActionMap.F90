module fp_StringActionMap
   use fp_BaseAction

#define Key __CHARACTER_DEFERRED
#define T BaseAction
#define T_polymorphic
#define Map StringActionMap
#define MapIterator StringActionMapIterator
#define Pair StringActionPair

#include "map/template.inc"

#undef Pair
#undef MapIterator
#undef Map
#undef T_polpmorphic
#undef T
#undef Key
end module fp_StringActionMap
