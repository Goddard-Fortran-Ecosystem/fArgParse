!----------------------------------------------------------------------------
! Currently this implementation is closer to the python's (obsolete)
! OptParse package.   Names have been changed in the hopes of heading
! towards something that works like the newere ArgParse package.
!
! Some of the functionality is overkill for pFUnit, but adding features
! could make this a nice separate package for use in othe Fortran projects.
!----------------------------------------------------------------------------

#include "unused_dummy.fh"
module fp_ArgParser_mod
   use fp_BaseAction_mod
   use fp_ActionVector_mod
   use fp_AbstractArgParser_mod
   use fp_StringVector_mod
   use fp_BaseAction_mod
   use fp_StoreAction_mod
   use fp_ActionVector_mod
   use fp_StringActionMap_mod
   use fp_StringUnlimitedMap_mod
   use fp_KeywordEnforcer_mod
   use fp_None_mod
   implicit none
   private

   public :: ArgParser
   type, extends(AbstractArgParser) :: ArgParser
      private
      type (ActionVector) :: optionals
      type (ActionVector) :: positionals
      type (StringActionMap) :: registry
      logical :: is_initialized = .false.
      character(:), allocatable :: program_name
   contains
      generic :: add_argument => add_argument_as_action
      generic :: add_argument => add_argument_as_attributes
      generic :: parse_args => parse_args_command_line, parse_args_args

      procedure :: parse_args_command_line
      procedure :: parse_args_args

      procedure :: add_argument_as_action
      procedure :: add_argument_as_attributes
      procedure :: get_defaults
      procedure :: get_option_matching
      procedure :: print_help
      procedure :: print_help_header
      procedure :: print_help_tail

      procedure :: add_action
      procedure :: initialize_registry
   end type ArgParser

   interface ArgParser
      module procedure new_ArgParser_empty
   end interface ArgParser


contains


   function new_argParser_empty(program_name) result(parser)
      use fp_CommandLineArguments_mod
      type (ArgParser) :: parser
      character(*), optional, intent(in) :: program_name

      call parser%initialize_registry()

      if (present(program_name)) then
         parser%program_name = program_name
      else
         parser%program_name = get_command_line_argument(0)
      end if

      ! Help is added by default.
      call parser%add_argument('-h', '--help', action='help', help='This message.')

   end function new_argParser_empty

   subroutine initialize_registry(this)
      use fp_HelpAction_mod
      use fp_StoreAction_mod
      use fp_StoreConstAction_mod
      use fp_StoreTrueAction_mod
      use fp_StoreFalseAction_mod
      class (ArgParser), intent(inout) :: this

      type (HelpAction) :: help_action
      type (StoreAction) :: store_action
      type (StoreConstAction) :: store_const_action
      type (StoreTrueAction) :: store_true_action
      type (StoreFalseAction) :: store_false_action

      if (this%is_initialized) return
      
      call this%registry%insert('none', store_action)
      call this%registry%insert('help', help_action)
      call this%registry%insert('store', store_action)
      call this%registry%insert('store_const', store_const_action)
      call this%registry%insert('store_true', store_true_action)
      call this%registry%insert('store_false', store_false_action)

      this%is_initialized = .true.

   end subroutine initialize_registry



   subroutine add_argument_as_action(this, action)
      class (ArgParser), intent(inout) :: this
      class (BaseAction), intent(in) :: action

      if (action%is_positional()) then
         call this%positionals%push_back(action)
      else
         call this%optionals%push_back(action)
      end if

   end subroutine add_argument_as_action


   ! Allow up to 3 variants of option string.  Can extend if more are needed
   subroutine add_argument_as_attributes(this, &
        & opt_string_1, opt_string_2, opt_string_3, opt_string_4, &  ! Positional arguments
        & unused, &                                    ! Keyword enforcer
        & action, type, n_arguments, dest, default, const, help) ! Keyword arguments

      class (ArgParser), intent(inout) :: this
      character(*), intent(in) :: opt_string_1
      character(*), optional, intent(in) :: opt_string_2
      character(*), optional, intent(in) :: opt_string_3
      character(*), optional, intent(in) :: opt_string_4
      class (KeywordEnforcer), optional, intent(in) :: unused

      character(*), optional, intent(in) :: action
      character(*), optional, intent(in) :: type
      integer, optional, intent(in) :: n_arguments
      character(*), optional, intent(in) :: dest
      character(*), optional, intent(in) :: const
      character(*), optional, intent(in) :: help
      class(*), optional, intent(in) :: default

      class (BaseAction), allocatable :: arg
      character(:), allocatable :: action_
      
      _UNUSED_DUMMY(unused)

      if (present(action)) then
         action_ = action
      else
         action_ = 'store'
      end if

      arg = this%registry%at(action_)
      call arg%initialize(opt_string_1, opt_string_2, opt_string_3, opt_string_4, &
           & type=type, n_arguments=n_arguments, dest=dest, default=default, const=const, help=help)
      call this%add_argument(arg)
      
   end subroutine add_argument_as_attributes


   function parse_args_command_line(this, unused, unprocessed) result(option_values)
      use fp_CommandLineArguments_mod
      type (StringUnlimitedMap) :: option_values
      class (ArgParser), intent(in) :: this
      class (KeywordEnforcer), optional, intent(in) :: unused
      type (StringVector), optional, intent(out) :: unprocessed

      _UNUSED_DUMMY(unused)
      option_values = this%parse_args(get_command_line_arguments(), unprocessed=unprocessed)
      
   end function parse_args_command_line


   function parse_args_args(this, arguments, unused, unprocessed) result(option_values)
      type (StringUnlimitedMap) :: option_values
      class (ArgParser), intent(in) :: this
      type (StringVector), target, intent(in) :: arguments
      class (KeywordEnforcer), optional, intent(in) :: unused
      type (StringVector), optional, intent(out) :: unprocessed

      type (StringVectorIterator) :: iter
      character(:), pointer :: argument

      class(BaseAction), pointer :: opt
      class (BaseAction), pointer :: act
      integer :: arg_value_int
      real :: arg_value_real
      character(:), target, allocatable :: embedded_value
      class(*), allocatable :: args  ! scalar for now, but should be a list

      integer :: ith
      integer :: n_arguments

      _UNUSED_DUMMY(unused)
      
      ! TODO:  Hopefully this is a temporary workaround for ifort 19 beta
      call this%get_defaults(option_values)

      ith = 0
      
      iter = arguments%begin()
      do while (iter /= arguments%end())
         argument => iter%get()
         opt => this%get_option_matching(argument, embedded_value)
         if (associated(opt)) then ! argument corresponds to an optional argument

            n_arguments = opt%get_n_arguments()
            ! Must be 1 or zero for now
            select case(n_arguments)
            case (0)
               call opt%act(option_values, this, value=argument)
            case (1)
               if (embedded_value /= '') then
                  argument => embedded_value
               else
                  call iter%next()
                  argument => iter%get()
               end if
               select case (opt%get_type())
               case ('string')
                  args = argument
               case ('integer')
                  read(argument,*) arg_value_int
                  args = arg_value_int
               case ('real')
                  read(argument,*) arg_value_real
                  args = arg_value_real
               end select
               deallocate(embedded_value)
               call opt%act(option_values, this, value=args)
               deallocate(args)
            end select
         else ! is positional
            ith = ith + 1
            act => this%positionals%at(ith)
            select case (act%get_type())
            case ('string')
               call option_values%insert(act%get_destination(), argument)
            case ('integer')
               read(argument,*) arg_value_int
               call option_values%insert(act%get_destination(), arg_value_int)
            case ('real')
               read(argument,*) arg_value_real
               call option_values%insert(act%get_destination(), arg_value_real)
            end select
            if (present(unprocessed)) call unprocessed%push_back(argument)
         end if
         

         call iter%next()
      end do

   end function parse_args_args

   subroutine get_defaults(this, option_values)
      type (StringUnlimitedMap) :: option_values
      class (ArgParser), intent(in) :: this

      class (BaseAction), pointer :: opt
      type (ActionVectorIterator) :: option_iter

      option_iter = this%optionals%begin()
      do while (option_iter /= this%optionals%end())
         opt => option_iter%get()
         if (opt%has_default()) then
            call option_values%insert(opt%get_destination(), opt%get_default())
         end if
         call option_iter%next()
      end do
      
   end subroutine get_defaults

   function get_option_matching(this, argument, embedded_value) result(opt)
      class (BaseAction), pointer :: opt
      class (ArgParser), target, intent(in) :: this
      character(*), intent(in) :: argument
      character(:), allocatable, intent(out) :: embedded_value

      type (StringVectorIterator) :: iter_opt_string

      type (ActionVectorIterator) :: iter_opt

      character(:), pointer :: opt_string
      type (StringVector), pointer :: opt_strings

      integer :: n

      iter_opt = this%optionals%begin()
      do while (iter_opt /= this%optionals%end())
         opt => iter_opt%get()
         opt_strings => opt%get_option_strings()
         iter_opt_string = opt_strings%begin()
         do while (iter_opt_string /= opt_strings%end())
            opt_string => iter_opt_string%get()

            n = len(opt_string)
            if (len(argument) >= n) then ! cannot rely on short-circuit
               if (opt_string == argument(1:n)) then ! matches

                  if (opt%is_short_option_string(opt_string)) then
                     embedded_value = argument(n+1:)
                  else
                     if (len(argument) >= n+1) then
                        if (argument(n+1:n+1) == '=') then
                           embedded_value = argument(n+2:)
                        end if
                     else
                        embedded_value = ''
                     end if
                  end if

                  return
                     
               end if
            end if

            call iter_opt_string%next()
         end do

         call iter_opt%next()
      end do

      ! not found
      opt => null()

   end function get_option_matching


   subroutine print_help(this)
      class (ArgParser), target, intent(in) :: this

      type (ActionVectorIterator) :: act_iter
      type (BaseAction), pointer :: act

      call this%print_help_header()

      if (this%positionals%size() > 0) then
         print*,' '
         print*,'positional arguments:'
         act_iter = this%positionals%begin()
         do while (act_iter /= this%positionals%end())
            act => act_iter%get()
            call act%print_help()
            call act_iter%next()
         end do
      end if

      if (this%optionals%size() > 0) then
         print*,' '
         print*,'optional arguments:'
         
         act_iter = this%optionals%begin()
         do while (act_iter /= this%optionals%end())
            act => act_iter%get()
            call act%print_help()
            call act_iter%next()
         end do
      end if

      call this%print_help_tail()
      
   end subroutine print_help

   subroutine print_help_header(this)
      class (ArgParser), target, intent(in) :: this

      character(:), allocatable :: header
      character(:), pointer :: opt_string

      type (StringVector), pointer :: opt_strings
      type (ActionVectorIterator) :: act_iter
      class (BaseAction), pointer :: act

      header = 'usage: ' // this%program_name // ' '

      act_iter = this%optionals%begin()
      do while (act_iter /= this%optionals%end())
         act => act_iter%get()

         opt_strings => act%get_option_strings()
         opt_string => opt_strings%front()
         header = header // '[' // opt_string

         if (act%get_n_arguments() > 0) then
            header = header // ' ' // upper_case(act%get_destination())
         end if
         header = header // ']'
         call act_iter%next()
      end do

      if (this%positionals%size() > 0) then
         act_iter = this%positionals%begin()
         do while (act_iter /= this%positionals%end())
            act => act_iter%get()
            opt_strings => act%get_option_strings()
            opt_string => opt_strings%front()
            header = header // ' ' // opt_string
            call act_iter%next()
         end do
      end if

      print*,header

   contains

      function upper_case(str)
         character(:), allocatable :: upper_case
         character(*), intent(in) :: str

         integer :: delta
         integer :: i
         integer :: ia

         delta = iachar('A') - iachar('a')
         
         upper_case = str
         do i = 1, len(upper_case)
            ia = iachar(upper_case(i:i))
            if (iachar('a') <= ia .and. ia <= iachar('z')) then
               ia = ia + delta
               upper_case(i:i) = achar(ia)
            end if
         end do
      end function upper_case
         
   end subroutine print_help_header

   subroutine print_help_tail(this)
      class (ArgParser), target, intent(in) :: this
      _UNUSED_DUMMY(this) ! for now
   end subroutine print_help_tail


   subroutine add_action(this, name, action)
      class (ArgParser), intent(inout) :: this
      character(*), intent(in) :: name
      class (BaseAction), intent(in) :: action

      call this%registry%insert(name, action)

   end subroutine add_action

end module fp_ArgParser_mod
