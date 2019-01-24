! Due to lack of forward declarations in Fortran, we need to define
! two interacting classes in the same module.  Alternatives such as
! the Surrogate design pattern (D. Rouson) are unattractive here both
! because the user may define extensions and Surrogate adds
! complexity, and because we need to define an FTL container of
! Actions in a separate module to be used within the ArgParser class.

! AbstractAction should not need to be modified.   But AbstractArgParser
! will need to be modified each time a new class method needs to be accessed by
! Action subclasses.



module fp_AbstractArgParser
   implicit none
   private
   
   public :: AbstractArgParser
   public :: AbstractAction

   

   type, abstract :: AbstractArgParser
   contains
      procedure(print_help), deferred :: print_help
   end type AbstractArgParser

   type, abstract :: AbstractAction
      private
   contains
      procedure(act), deferred :: act
   end type AbstractAction


   abstract interface

      subroutine print_help(this)
         import AbstractArgParser
         class (AbstractArgParser), target, intent(in) :: this
      end subroutine print_help

      subroutine act(this, namespace, parser, value, option_string)
         use gFTL_StringUnlimitedMap
         import AbstractAction
         import AbstractArgParser
         class (AbstractAction), intent(inout) :: this
         type (StringUnlimitedMap), intent(inout) :: namespace
         class (AbstractArgParser), intent(in) :: parser
         class(*), intent(in) :: value
         character(*), optional, intent(in) :: option_string
      end subroutine act
      
   end interface

end module fp_AbstractArgParser
