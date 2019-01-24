module fp_ActionVector
   use fp_BaseAction
#define _vector ActionVector
#define _iterator ActionVectorIterator
#define _type class(BaseAction)
#define _allocatable
#include "templates/vector.inc"
end module fp_ActionVector
