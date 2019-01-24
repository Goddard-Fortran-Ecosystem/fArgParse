module fp_ErrorCodes
   implicit none
   public

   enum, bind(C)
      enumerator :: SUCCESS = 0
      enumerator :: INCOMPATIBLE_DYNAMIC_TYPE
      enumerator :: UNKNOWN_ACTION
   end enum

end module fp_ErrorCodes
