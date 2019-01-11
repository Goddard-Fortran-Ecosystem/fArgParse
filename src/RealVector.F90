module fp_RealVectorMod
#  define _type type(real)
#  define _vector RealVector
#  define _vectoriterator RealVectorIterator
#  include "templates/vector.inc"
#  undef _vectoriterator
#  undef _vector
#  undef _type
end module fp_RealVectorMod
