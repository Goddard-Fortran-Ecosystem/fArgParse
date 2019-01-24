module fp_StoreAction
   use fp_AbstractArgParser
   use fp_BaseAction
   implicit none
   private

   public :: StoreAction

   type, extends(BaseAction) :: StoreAction
   contains
      procedure :: act
   end type StoreAction

contains

   subroutine act(this, namespace, parser, value, option_string)
      use gFTL_StringUnlimitedMap
      class (StoreAction), intent(inout) :: this
      type (StringUnlimitedMap), intent(inout) :: namespace
      class (AbstractArgParser), intent(in) :: parser
      class(*), intent(in) :: value
      character(*), optional, intent(in) :: option_string

      call namespace%insert(this%get_destination(), value)

   end subroutine act

end module fp_StoreAction
