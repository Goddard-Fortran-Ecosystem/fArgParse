#include "unused_dummy.fh"

module fp_StoreFalseAction_mod
   use fp_AbstractArgParser_mod
   use fp_BaseAction_mod
   use fp_StoreConstAction_mod
   use fp_KeywordEnforcer_mod
   implicit none
   private

   public :: StoreFalseAction

   type, extends(StoreConstAction) :: StoreFalseAction
   contains
      procedure :: initialize
   end type StoreFalseAction

contains

   subroutine initialize(this, &
        ! Positional arguments
        & opt_string_1, opt_string_2, opt_string_3, opt_string_4, & ! enough is enough
        ! Keyword enforcer
        & unused, &
        ! Keyword arguments
        & type, dest, default, const, help)
      class (StoreFalseAction), intent(out) :: this

      character(len=*), intent(in) :: opt_string_1
      character(len=*), optional, intent(in) :: opt_string_2
      character(len=*), optional, intent(in) :: opt_string_3
      character(len=*), optional, intent(in) :: opt_string_4
      class (KeywordEnforcer), optional, intent(in) :: unused

      character(len=*), optional, intent(in) :: type
      character(len=*), optional, intent(in) :: dest
      class(*), optional, intent(in) :: default
      class(*), optional, intent(in) :: const
      character(len=*), optional, intent(in) :: help

      class(*), allocatable :: default_

      _UNUSED_DUMMY(unused)
      _UNUSED_DUMMY(const)
      
      if (present(default)) then
         default_ = default
      else
         default_ = .true.
      end if
         
      call this%StoreConstAction%initialize(opt_string_1, opt_string_2, opt_string_3, opt_string_4, &
           & type=type, dest=dest, default=default_, const=.false., help=help)

   end subroutine initialize

end module fp_StoreFalseAction_mod
