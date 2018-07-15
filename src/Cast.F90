module fp_Cast_mod
   use fp_ErrorCodes_mod
   implicit none
   private

   public :: cast

   interface cast
      module procedure cast_to_logical
      module procedure cast_to_integer
      module procedure cast_to_string
      module procedure cast_to_real
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


   subroutine cast_to_string(unlimited, string, rc)
      class(*), intent(in) :: unlimited
      character(:), allocatable, intent(out) :: string
      integer, optional, intent(out) :: rc

      select type (q => unlimited)
      type is (character(*))
         string = q
         if (present(rc)) then
            rc = SUCCESS
         end if
      class default
         string = ''
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

end module fp_Cast_mod
