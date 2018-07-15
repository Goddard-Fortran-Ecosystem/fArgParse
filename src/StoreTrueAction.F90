#include "unused_dummy.fh"

module fp_StoreTrueAction_mod
   use fp_AbstractArgParser_mod
   use fp_BaseAction_mod
   use fp_StoreConstAction_mod
   use fp_KeywordEnforcer_mod
   implicit none
   private

   public :: StoreTrueAction

   type, extends(StoreConstAction) :: StoreTrueAction
   contains
      procedure :: initialize
   end type StoreTrueAction

contains

   subroutine initialize(this, &
        ! Positional arguments
        & opt_string_1, opt_string_2, opt_string_3, opt_string_4, & ! enough is enough
        ! Keyword enforcer
        & unused, &
        ! Keyword arguments
        & type, dest, default, const, help)
      class (StoreTrueAction), intent(out) :: this

      character(len=*), intent(in) :: opt_string_1
      character(len=*), optional, intent(in) :: opt_string_2
      character(len=*), optional, intent(in) :: opt_string_3
      character(len=*), optional, intent(in) :: opt_string_4
      class (KeywordEnforcer), optional, intent(in) :: unused

      character(len=*), optional, intent(in) :: type
      character(len=*), optional, intent(in) :: dest
      class(*), optional, intent(in) :: const
      class(*), optional, intent(in) :: default
      character(len=*), optional, intent(in) :: help

      class(*), allocatable :: default_

      _UNUSED_DUMMY(unused)
      _UNUSED_DUMMY(const)

      if (present(default)) then
         default_ = default
      else
         default_ = .false.
      end if

      call this%StoreConstAction%initialize(opt_string_1, opt_string_2, opt_string_3, opt_string_4, &
           & type=type, dest=dest, default=default_, const=.true., help=help)
   end subroutine initialize

end module fp_StoreTrueAction_mod
