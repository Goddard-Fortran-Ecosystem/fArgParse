module fp_StoreConstAction_mod
   use fp_AbstractArgParser_mod
   use fp_BaseAction_mod
   implicit none
   private

   public :: StoreConstAction

   type, extends(BaseAction) :: StoreConstAction
   contains
      procedure :: act
   end type StoreConstAction

contains

   subroutine act(this, namespace, parser, value, option_string)
      use fp_StringUnlimitedMap_mod
      class (StoreConstAction), intent(inout) :: this
      type (StringUnlimitedMap), intent(inout) :: namespace
      class (AbstractArgParser), intent(inout) :: parser
      class(*), intent(in) :: value
      character(*), optional, intent(in) :: option_string

      call namespace%insert(this%get_destination(), this%get_const())

   end subroutine act

end module fp_StoreConstAction_mod
