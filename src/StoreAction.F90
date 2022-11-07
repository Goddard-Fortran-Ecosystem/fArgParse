module fp_StoreAction
   use fp_AbstractArgParser
   use fp_BaseAction
   use fp_String
   implicit none
   private

   public :: StoreAction

   type, extends(BaseAction) :: StoreAction
   contains
      procedure :: act
   end type StoreAction

contains

   subroutine act(this, namespace, parser, value, option_string)
      use gFTL2_StringUnlimitedMap
      class (StoreAction), intent(inout) :: this
      type (StringUnlimitedMap), intent(inout) :: namespace
      class (AbstractArgParser), intent(in) :: parser
      class(*), intent(in) :: value
      character(*), optional, intent(in) :: option_string

      ! gfortran workaround
      select type (value)
      type is (String)
         call namespace%insert(this%get_destination(), value)
      class default
         call namespace%insert(this%get_destination(), value)
      end select

   end subroutine act

end module fp_StoreAction
