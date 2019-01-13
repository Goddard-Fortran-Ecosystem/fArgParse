module fp_IntegerVectorMod

#  define _type type(integer) 
#  define _vector IntegerVector
#  define _vectoriterator IntegerVectorIterator
#  include "templates/vector.inc"
#  undef _vectoriterator
#  undef _vector
#  undef _type

end module fp_IntegerVectorMod
