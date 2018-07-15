module fp_ActionVector_mod
   use fp_BaseAction_mod
#define _vector ActionVector
#define _iterator ActionVectorIterator
#define _type class(BaseAction)
#define _allocatable
#include "templates/vector.inc"
end module fp_ActionVector_mod
