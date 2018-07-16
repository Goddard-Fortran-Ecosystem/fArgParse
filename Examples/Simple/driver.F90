program main
   use fParse
   implicit none
   
   type (ArgParser) :: p
   type (StringUnlimitedMap) :: options

   logical :: debug
   character(:), allocatable :: input_file
   integer :: n

   p = ArgParser()

   ! Option 1: allow for verbose/debug; Note: default is .false.
   call p%add_argument('-d', '--debug', action='store_true',help='make output more verbose')

   ! Option 2: optional argument to specify a file name for input
   call p%add_argument('-i', '--input', type='string', help='name of input file')

   ! Option 3: positional argument - an integer stored as 'n'
   call p%add_argument('n', type='integer', action='store', help='a number')


   ! Process command lines and fill in a dictionary of values:
   options = p%parse_args()

   call cast(options%at('debug'), debug)
   if (debug) then
      print*,'debug: ',debug
   end if

   if (options%count('input')> 0) then
      call cast(options%at('input'), input_file)
      if (debug) then
         print*,'input: ',input_file
      end if
   end if

   if (options%count('n')> 0) then
      call cast(options%at('n'), n)
      if (debug) then
         print*,'n: ',n
      end if
   end if
   
end program main
