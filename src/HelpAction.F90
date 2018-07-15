#include "unused_dummy.fh"
module fp_HelpAction_mod
   use fp_AbstractArgParser_mod
   use fp_BaseAction_mod
   implicit none
   private

   public :: HelpAction

   type, extends(BaseAction) :: HelpAction
   contains
      procedure :: act
   end type HelpAction

contains

   subroutine act(this, namespace, parser, value, option_string)
      use fp_StringUnlimitedMap_mod
      class (HelpAction), intent(inout) :: this
      type (StringUnlimitedMap), intent(inout) :: namespace
      class (AbstractArgParser), intent(inout) :: parser
      class(*), intent(in) :: value
      character(*), optional, intent(in) :: option_string

      _UNUSED_DUMMY(namespace)
      _UNUSED_DUMMY(parser)
      _UNUSED_DUMMY(value)
      _UNUSED_DUMMY(option_string)

      call parser%print_help()
      stop

   end subroutine act

end module fp_HelpAction_mod
