#include "unused_dummy.fh"

module fp_StoreTrueAction
   use fp_AbstractArgParser
   use fp_BaseAction
   use fp_StoreConstAction
   use fp_KeywordEnforcer
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
        & type, n_arguments, dest, default, const, choices, help)
      class (StoreTrueAction), intent(out) :: this

      character(len=*), intent(in) :: opt_string_1
      character(len=*), optional, intent(in) :: opt_string_2
      character(len=*), optional, intent(in) :: opt_string_3
      character(len=*), optional, intent(in) :: opt_string_4
      class (KeywordEnforcer), optional, intent(in) :: unused

      character(len=*), optional, intent(in) :: type
      class(*), optional, intent(in) :: n_arguments
      character(len=*), optional, intent(in) :: dest
      class(*), optional, intent(in) :: const
      class(*), optional, intent(in) :: default
      character(len=*), optional, intent(in) :: choices(:)
      character(len=*), optional, intent(in) :: help

      class(*), allocatable :: default_

      _UNUSED_DUMMY(unused)
      _UNUSED_DUMMY(const)

      if (present(default)) then
         default_ = default
      else
         allocate(default_, source=.false.)
      end if

      call this%StoreConstAction%initialize(opt_string_1, opt_string_2, opt_string_3, opt_string_4, &
           & type=type, dest=dest, default=default_, const=.true., choices=choices, help=help)
   end subroutine initialize

end module fp_StoreTrueAction
