module fp_Cast
  use fp_ErrorCodes
  use fp_String
   implicit none
   private

   public :: cast

   interface cast
      module procedure cast_to_logical
      module procedure cast_to_integer
      module procedure cast_to_string
      module procedure cast_to_real
      module procedure cast_to_integer_vector
      module procedure cast_to_real_vector
      module procedure cast_to_string_vector
   end interface cast


contains


   subroutine cast_to_logical(unlimited, flag, rc)
      class(*), intent(in) :: unlimited
      logical, intent(out) :: flag
      integer, optional, intent(out) :: rc

      select type (q => unlimited)
      type is (logical)
         flag = q
         if (present(rc)) then
            rc = SUCCESS
         end if
      class default
         flag = .true.
         if (present(rc)) then
            rc = INCOMPATIBLE_DYNAMIC_TYPE
         end if
      end select
   end subroutine cast_to_logical


   subroutine cast_to_integer(unlimited, i, rc)
      class(*), intent(in) :: unlimited
      integer, intent(out) :: i
      integer, optional, intent(out) :: rc


      select type (q => unlimited)
      type is (integer)
         i = q
         if (present(rc)) then
            rc = SUCCESS
         end if
      class default
         i = 0
         if (present(rc)) then
            rc = INCOMPATIBLE_DYNAMIC_TYPE
         end if
      end select

   end subroutine cast_to_integer


   subroutine cast_to_string(unlimited, s, rc)
      class(*), intent(in) :: unlimited
      character(:), allocatable, intent(out) :: s
      integer, optional, intent(out) :: rc

      select type (q => unlimited)
      type is (String)
         s = q%string
         if (present(rc)) then
            rc = SUCCESS
         end if
      type is (character(*))
         s = q
         if (present(rc)) then
            rc = SUCCESS
         end if
      class default
         s = ''
         if (present(rc)) then
            rc = INCOMPATIBLE_DYNAMIC_TYPE
         end if
      end select

   end subroutine cast_to_string


   subroutine cast_to_real(unlimited, x, rc)
      class(*), intent(in) :: unlimited
      real, intent(out) :: x
      integer, optional, intent(out) :: rc

      select type (q => unlimited)
      type is (real)
         x = q
         if (present(rc)) then
            rc = SUCCESS
         end if
      class default
         if (present(rc)) then
            rc = INCOMPATIBLE_DYNAMIC_TYPE
         end if
      end select

   end subroutine cast_to_real

   subroutine cast_to_integer_vector(unlimited, v, rc)
     use gFTL2_IntegerVector
      class(*), intent(in) :: unlimited
      type(IntegerVector), intent(out) :: v
      integer, optional, intent(out) :: rc

      select type (q => unlimited)
      type is (IntegerVector)
         v = q
         if (present(rc)) then
            rc = SUCCESS
         end if
      class default
         if (present(rc)) then
            rc = INCOMPATIBLE_DYNAMIC_TYPE
         end if
      end select

    end subroutine cast_to_integer_vector

   
   subroutine cast_to_real_vector(unlimited, v, rc)
     use gFTL2_RealVector
      class(*), intent(in) :: unlimited
      type(RealVector), intent(out) :: v
      integer, optional, intent(out) :: rc

      select type (q => unlimited)
      type is (RealVector)
         v = q
         if (present(rc)) then
            rc = SUCCESS
         end if
      class default
         if (present(rc)) then
            rc = INCOMPATIBLE_DYNAMIC_TYPE
         end if
      end select

    end subroutine cast_to_real_vector

   
   subroutine cast_to_string_vector(unlimited, v, rc)
     use gFTL2_StringVector
      class(*), intent(in) :: unlimited
      type(StringVector), intent(out) :: v
      integer, optional, intent(out) :: rc

      select type (q => unlimited)
      type is (StringVector)
         v = q
         if (present(rc)) then
            rc = SUCCESS
         end if
      class default
         if (present(rc)) then
            rc = INCOMPATIBLE_DYNAMIC_TYPE
         end if
      end select

    end subroutine cast_to_string_vector

   
end module fp_Cast
