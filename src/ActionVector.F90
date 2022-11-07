module fp_ActionVector
   use fp_BaseAction
#define T BaseAction
#define T_polymorphic
#define Vector ActionVector
#define VectorIterator ActionVectorIterator
#include "vector/template.inc"

#undef VectorIterator
#undef Vector
#undef T_polpmorphic
#undef T
end module fp_ActionVector
