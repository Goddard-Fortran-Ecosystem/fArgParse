module fp_ArgVector_mod
   use fp_Arg_mod
#define _vector ArgVector
#define _iterator ArgVectorIterator
#define _type type (Arg)
#include "templates/vector.inc"
end module fp_ArgVector_mod
