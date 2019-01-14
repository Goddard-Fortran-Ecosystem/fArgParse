module fp_StoreAction_mod
   use fp_AbstractArgParser_mod
   use fp_BaseAction_mod
   implicit none
   private

   public :: StoreAction

   type, extends(BaseAction) :: StoreAction
   contains
      procedure :: act
   end type StoreAction

contains

   subroutine act(this, namespace, parser, value, option_string)
     use fp_StringUnlimitedMap_mod
      class (StoreAction), intent(inout) :: this
      type (StringUnlimitedMap), intent(inout) :: namespace
      class (AbstractArgParser), intent(in) :: parser
      class(*), intent(in) :: value
      character(*), optional, intent(in) :: option_string

      call namespace%insert(this%get_destination(), value)

   end subroutine act

end module fp_StoreAction_mod
