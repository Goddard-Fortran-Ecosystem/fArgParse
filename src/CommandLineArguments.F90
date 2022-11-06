module fp_CommandLineArguments
   use gFTL2_StringVector
   implicit none

   private

   public :: get_command_line_arguments
   public :: get_command_line_argument
   
contains

   function get_command_line_argument(i) result(argument)
      character(:), allocatable :: argument
      integer, intent(in) :: i

      integer :: length_of_argument
      call get_command_argument(i, length=length_of_argument)
      allocate(character(length_of_argument) :: argument)
      call get_command_argument(i, value=argument)

   end function get_command_line_argument


   function get_command_line_arguments() result(arguments)
      type (StringVector) :: arguments

      integer :: n_arguments
      integer :: i
      
      n_arguments = command_argument_count()
      do i = 1, n_arguments
         call arguments%push_back(get_command_line_argument(i))
      end do

   end function get_command_line_arguments


end module fp_CommandLineArguments
