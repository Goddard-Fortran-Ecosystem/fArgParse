!----------------------------------------------------------------------------
! Currently this implementation is closer to the python's (obsolete)
! OptParse package.   Names have been changed in the hopes of heading
! towards something that works like the newere ArgParse package.
!
! Some of the functionality is overkill for pFUnit, but adding features
! could make this a nice separate package for use in othe Fortran projects.
!----------------------------------------------------------------------------

#include "unused_dummy.fh"
module fp_ArgParser
   use fp_BaseAction
   use fp_ActionVector
   use fp_AbstractArgParser
   use fp_BaseAction
   use fp_StoreAction
   use fp_ActionVector
   use fp_StringActionMap
   use fp_KeywordEnforcer
   use fp_None
   use fp_String
   use gFTL2_IntegerVector
   use gFTL2_RealVector
   use gFTL2_StringVector
   use gFTL2_StringUnlimitedMap
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
      procedure :: initialize
      generic :: add_argument => add_argument_as_action
      generic :: add_argument => add_argument_as_attributes

      generic :: parse_args => parse_args_command_line, parse_args_args
      procedure :: parse_args_command_line
      procedure :: parse_args_args

      generic :: parse_args_kludge => parse_args_kludge_command_line, parse_args_kludge_args
      procedure :: parse_args_kludge_command_line
      procedure :: parse_args_kludge_args
      

      procedure :: add_argument_as_action
      procedure :: add_argument_as_attributes
      procedure :: get_defaults
      procedure :: get_option_matching
      procedure :: print_help
      procedure :: print_help_header
      procedure :: print_help_tail

      procedure :: add_action
      procedure :: initialize_registry

      procedure :: handle_option
   end type ArgParser

   interface ArgParser
      module procedure new_ArgParser_empty
   end interface ArgParser


contains


   function new_argParser_empty(program_name) result(parser)
      type (ArgParser) :: parser
      character(*), optional, intent(in) :: program_name

      call parser%initialize(program_name)

   end function new_argParser_empty

   ! This procedure is a kludge for ifort 18.0.x.  The compiler does
   ! not correctly return a Parser object using the type constructor
   ! above, so we use a subroutine argument here to side-step the issue.
   ! Annoying.   It is apparently fixed in 19.0.1 and 19.0.2, so no need 
   ! to submit a reproducer to Intel.  Delete someday?
   subroutine initialize(this, program_name)
      use fp_CommandLineArguments
      class (ArgParser), intent(out) :: this
      character(*), optional, intent(in) :: program_name

      call this%initialize_registry()

      if (present(program_name)) then
         this%program_name = program_name
      else
         this%program_name = get_command_line_argument(0)
      end if

      ! Help is added by default.
      call this%add_argument('-h', '--help', action='help', help='This message.')

   end subroutine initialize

   subroutine initialize_registry(this)
      use fp_HelpAction
      use fp_StoreAction
      use fp_StoreConstAction
      use fp_StoreTrueAction
      use fp_StoreFalseAction
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
        & action, type, n_arguments, dest, default, const, choices, help) ! Keyword arguments

      class (ArgParser), target, intent(inout) :: this
      character(*), intent(in) :: opt_string_1
      character(*), optional, intent(in) :: opt_string_2
      character(*), optional, intent(in) :: opt_string_3
      character(*), optional, intent(in) :: opt_string_4
      class (KeywordEnforcer), optional, intent(in) :: unused

      character(*), optional, intent(in) :: action
      character(*), optional, intent(in) :: type
      class(*), optional, intent(in) :: n_arguments
      character(*), optional, intent(in) :: dest
      class(*), optional, intent(in) :: const
      character(*), optional, intent(in) :: choices(:)
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
           & type=type, n_arguments=n_arguments, dest=dest, default=default, const=const, choices=choices, help=help)
      call this%add_argument(arg)

   end subroutine add_argument_as_attributes


   function parse_args_command_line(this, unused, unprocessed) result(option_values)
     use fp_CommandLineArguments
      type (StringUnlimitedMap) :: option_values
      class (ArgParser), intent(in) :: this
      class (KeywordEnforcer), optional, intent(in) :: unused
      type (StringVector), optional, intent(out) :: unprocessed
      type (StringVector), target :: arguments
      
      _UNUSED_DUMMY(unused)

      arguments = get_command_line_arguments()
      option_values = this%parse_args(arguments, unprocessed=unprocessed)

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
      class(*), allocatable :: args

      integer :: ith

      _UNUSED_DUMMY(unused)
      
      call this%get_defaults(option_values)
      ith = 0

      iter = arguments%begin()
      do while (iter /= arguments%end())
         argument => iter%of()
         opt => this%get_option_matching(argument, embedded_value)
         if (associated(opt)) then ! argument corresponds to an optional argument

            call this%handle_option(opt, argument, iter, arguments%end(), embedded_value, args)

            select type (args)
            type is (String)
               call opt%act(option_values, this, args%string)
            class default
               call opt%act(option_values, this, args)
            end select
            deallocate(args)

            deallocate(embedded_value)
            if (iter == arguments%end()) exit

         else ! is positional
            ith = ith + 1
            if (ith <= this%positionals%size()) then
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
            else
               if (present(unprocessed)) call unprocessed%push_back(argument)
            end if
         end if
         

         call iter%next()
      end do

   end function parse_args_args

   subroutine parse_args_kludge_command_line(this, option_values, unused, unprocessed)
     use fp_CommandLineArguments
      class (ArgParser), intent(in) :: this
      type (StringUnlimitedMap), intent(out) :: option_values
      class (KeywordEnforcer), optional, intent(in) :: unused
      type (StringVector), optional, intent(out) :: unprocessed
      type (StringVector), target :: arguments
      
      _UNUSED_DUMMY(unused)

      arguments = get_command_line_arguments()
      ! Workaround for gfortran-8.2  - default assignment for complex maps is broken?
      call this%parse_args_kludge(option_values, arguments, unprocessed=unprocessed)
!!$      call option_values%deepCopy(this%parse_args(arguments, unprocessed=unprocessed))
      
   end subroutine parse_args_kludge_command_line


   subroutine parse_args_kludge_args(this, option_values, arguments, unused, unprocessed)
      class (ArgParser), intent(in) :: this
      type (StringUnlimitedMap), intent(out) :: option_values
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
      class(*), allocatable :: args

      integer :: ith

      _UNUSED_DUMMY(unused)
      
      call this%get_defaults(option_values)
      ith = 0

      iter = arguments%begin()
      do while (iter /= arguments%end())
         argument => iter%of()
         opt => this%get_option_matching(argument, embedded_value)
         if (associated(opt)) then ! argument corresponds to an optional argument

            call this%handle_option(opt, argument, iter, arguments%end(), embedded_value, args)

            select type (args)
            type is (String)
               call opt%act(option_values, this, args%string)
            class default
               call opt%act(option_values, this, args)
            end select
            deallocate(args)

            deallocate(embedded_value)
            if (iter == arguments%end()) exit

         else ! is positional
            ith = ith + 1
            if (ith <= this%positionals%size()) then
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
            else
               if (present(unprocessed)) call unprocessed%push_back(argument)
            end if
         end if
         

         call iter%next()
      end do

   end subroutine parse_args_kludge_args

   subroutine handle_option(this, action, argument, iter, end, embedded_value, args)
     class(ArgParser), intent(in) :: this
     class(BaseAction), target, intent(inout) :: action
     character(:), pointer :: argument
     type(StringVectorIterator), intent(inout) :: iter
     type(StringVectorIterator), intent(in) :: end
     character(*), target, intent(in) :: embedded_value
     class(*), allocatable, intent(inout) :: args 

     type(IntegerVector) :: integer_list
     type(RealVector) :: real_list
     type(StringVector) :: string_list
     integer :: i
     type(StringVector), pointer :: choices

     integer :: arg_value_int
     real :: arg_value_real

#ifdef __INTEL_COMPILER
     class(*), allocatable :: n_arguments
     n_arguments = action%get_n_arguments()
     select type (n_arguments)
#else
     select type (n_arguments => action%get_n_arguments())
#endif
     type is (t_None) ! Single value collected 
        if (embedded_value /= '') then
           argument => embedded_value
        else
           call iter%next()
           ! TODO: should raise exception if there are not more arguments.
           argument => iter%of()
        end if
        select case (action%get_type())
        case ('string')
           args = String(argument)
        case ('integer')
           read(argument,*) arg_value_int
           args = arg_value_int
        case ('real')
           read(argument,*) arg_value_real
           args = arg_value_real
        end select
     type is (integer)
        select case(n_arguments)
        case (0) ! Value(s) is determined by action
           args = None
        case (1:) ! Fixed number of values collected into vector
           select case (action%get_type())
           case ('string')
              do i = 1, n_arguments
                 call iter%next()
                 argument => iter%of()
                 call string_list%push_back(argument)
              end do
              args = string_list
           case ('integer')
              do i = 1, n_arguments
                 call iter%next()
                 argument => iter%of()
                 read(argument,*) arg_value_int
                 call integer_list%push_back(arg_value_int)
              end do
              args = integer_list
           case ('real')
              do i = 1, n_arguments
                 call iter%next()
                 argument => iter%of()
                 read(argument,*) arg_value_real
                 call real_list%push_back(arg_value_real)
              end do
              args = real_list
           end select
        end select
     type is (character(*)) ! Variable number of values
        ! Cases: '?','*', and '+'
        ! TODO: aggregation should terminate when a new optional
        ! arguemnt is encountered
        select case (n_arguments)
        case ('?')
           if (embedded_value /= '') then ! value is embedded in token
              argument => embedded_value
              select case (action%get_type())
              case ('string')
                 args = argument
              case ('integer')
                 read(argument,*) arg_value_int
                 args = arg_value_int
              case ('real')
                 read(argument,*) arg_value_real
                 args = arg_value_real
              end select
           else ! value (if any) is in next token
              call iter%next()
              if (iter /= end) then
                 argument => iter%of()
              else ! no more tokens - allowed for nargs=='?'
                 call iter%prev()
                 argument => null()
              end if
              if (.not. associated(argument)) then
                 args = action%get_const()
              elseif (argument(1:1) == '-') then
                 ! Next token is another optional arg.
                 ! Use const value.
                 args = action%get_const()
              else ! next token is a value
                 select case (action%get_type())
                 case ('string')
                    args = argument
                 case ('integer')
                    read(argument,*) arg_value_int
                    args = arg_value_int
                 case ('real')
                    read(argument,*) arg_value_real
                    args = arg_value_real
                 end select
              end if
           end if
        case ('*', '+')
           call iter%next()
           if (n_arguments == '+' .and. iter == end) then
              ! TODO: throw exception.  '+' requires at least one value
           end if
           
           do while (iter /= end)

              argument => iter%of()
              if (argument(1:1) == '-') then
                 call iter%prev()
                 exit
              end if
              
              select case (action%get_type())
              case ('string')
                 call string_list%push_back(argument)
              case ('integer')
                 read(argument,*) arg_value_int
                 call integer_list%push_back(arg_value_int)
              case ('real')
                 read(argument,*) arg_value_real
                 call real_list%push_back(arg_value_real)
              end select
              call iter%next()
           end do
           select case (action%get_type())
           case ('string')
              args = string_list
           case ('integer')
              args = integer_list
           case ('real')
              args = real_list
           end select

           return

        case default
           print*,'unimplemented'
        end select
     end select

     choices => action%get_choices()

     if (choices%size() > 0) then
        if (find(choices%begin(),choices%end(), argument) == choices%end()) then ! not found
           error stop 'invalid choice for argument'
        end if
     end if
   end subroutine handle_option

   subroutine get_defaults(this, option_values)
      type (StringUnlimitedMap), intent(out) :: option_values
      class (ArgParser), target, intent(in) :: this

      class (BaseAction), pointer :: opt
      type (ActionVectorIterator) :: option_iter
      class(*), pointer :: q
      
      option_iter = this%optionals%begin()
      do while (option_iter /= this%optionals%end())
         opt => option_iter%of()
         if (opt%has_default()) then
            q => opt%get_default()
            ! workaround for gfortran
            select type (q)
            type is (String)
               call option_values%insert(opt%get_destination(), q)
            class default
               call option_values%insert(opt%get_destination(), q)
            end select
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
         opt => iter_opt%of()
         opt_strings => opt%get_option_strings()
         iter_opt_string = opt_strings%begin()
         do while (iter_opt_string /= opt_strings%end())
            opt_string => iter_opt_string%of()

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
         act_iter = this%positionals%begin()
         do while (act_iter /= this%positionals%end())
            act => act_iter%of()
            call act%print_help()
            call act_iter%next()
         end do
      end if

      if (this%optionals%size() > 0) then
         print*,' '
         print*,'optional arguments:'
         
         act_iter = this%optionals%begin()
         do while (act_iter /= this%optionals%end())
            act => act_iter%of()
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
         act => act_iter%of()

         opt_strings => act%get_option_strings()
         opt_string => opt_strings%front()
         header = header // '[' // opt_string

         select type (n_arguments => act%get_n_arguments())
         type is (t_None)
            header = header // ' ' // upper_case(act%get_destination())
         type is (integer)
            header = header // repeat(' ' // upper_case(act%get_destination()), n_arguments)
         type is (character(*))
         end select
         header = header // ']'
         call act_iter%next()
      end do

      if (this%positionals%size() > 0) then
         act_iter = this%positionals%begin()
         do while (act_iter /= this%positionals%end())
            act => act_iter%of()
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

end module fp_ArgParser
