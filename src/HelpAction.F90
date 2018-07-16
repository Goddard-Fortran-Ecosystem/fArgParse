#include "unused_dummy.fh"
module fp_HelpAction_mod
   use fp_AbstractArgParser_mod
   use fp_BaseAction_mod
   use fp_KeywordEnforcer_mod
   use fp_None_mod
   implicit none
   private

   public :: HelpAction

   type, extends(BaseAction) :: HelpAction
   contains
      procedure :: initialize
      procedure :: act
   end type HelpAction

contains


   subroutine initialize(this, &
        ! Positional arguments
        & opt_string_1, opt_string_2, opt_string_3, opt_string_4, & ! enough is enough
        ! Keyword enforcer
        & unused, &
        ! Keyword arguments
        & type, n_arguments, dest, default, const, help)
      class (HelpAction), intent(out) :: this

      character(len=*), intent(in) :: opt_string_1
      character(len=*), optional, intent(in) :: opt_string_2
      character(len=*), optional, intent(in) :: opt_string_3
      character(len=*), optional, intent(in) :: opt_string_4
      class (KeywordEnforcer), optional, intent(in) :: unused

      character(len=*), optional, intent(in) :: type
      integer, optional, intent(in) :: n_arguments
      character(len=*), optional, intent(in) :: dest
      class(*), optional, intent(in) :: const
      class(*), optional, intent(in) :: default
      character(len=*), optional, intent(in) :: help

      class(*), allocatable :: default_

      _UNUSED_DUMMY(unused)
      _UNUSED_DUMMY(const)

      call this%BaseAction%initialize(opt_string_1, opt_string_2, opt_string_3, opt_string_4, &
           & n_arguments=0, dest=dest, default=default, const=const, help=help)
   end subroutine initialize


   subroutine act(this, namespace, parser, value, option_string)
      use fp_StringUnlimitedMap_mod
      class (HelpAction), intent(inout) :: this
      type (StringUnlimitedMap), intent(inout) :: namespace
      class (AbstractArgParser), intent(in) :: parser
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
