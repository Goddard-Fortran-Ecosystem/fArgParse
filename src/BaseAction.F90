#include "unused_dummy.fh"
module fp_BaseAction
   use fp_AbstractArgParser, only: AbstractAction
   use fp_KeywordEnforcer
   use gFTL_StringVector
   use fp_None
   implicit none
   private

   public :: BaseAction

   type, extends(AbstractAction) :: BaseAction
      private
      character(:), allocatable :: destination
      type (StringVector) :: option_strings
      character(:), allocatable :: type
      class(*), allocatable :: const
      class(*), allocatable :: default
      character(:), allocatable :: help
      class(*), allocatable :: n_arguments ! string or integer
      logical :: positional = .false.
   contains
      procedure :: initialize
      procedure :: get_destination
      procedure :: get_type
      procedure :: get_option_strings
      procedure :: get_const
      procedure :: get_n_arguments
      procedure :: get_default
      procedure :: get_help
      procedure :: has_default
      procedure :: is_positional
      procedure :: print_help

      procedure :: matches
      procedure, nopass :: is_legal_option_string
      procedure, nopass :: is_short_option_string
      procedure, nopass :: is_long_option_string

      procedure :: act
   end type BaseAction

contains

   subroutine initialize(this, &
        ! Positional arguments
        & opt_string_1, opt_string_2, opt_string_3, opt_string_4, & ! enough is enough
        ! Keyword enforcer
        & unused, &
        ! Keyword arguments
        & type, n_arguments, dest, default, const, help)
      class (BaseAction), intent(out) :: this

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
      character(len=*), optional, intent(in) :: help

      type (StringVectorIterator) :: iter
      character(:), pointer :: opt_string

      _UNUSED_DUMMY(unused)
      
      call this%option_strings%push_back(opt_string_1)
      if (present(opt_string_2)) call this%option_strings%push_back(opt_string_2)
      if (present(opt_string_3)) call this%option_strings%push_back(opt_string_3)
      if (present(opt_string_4)) call this%option_strings%push_back(opt_string_4)

      if (present(dest)) then
         this%destination = dest
      else
         iter = this%option_strings%begin()
         do while (iter /= this%option_strings%end())
            
            opt_string => iter%get()
            if (is_long_option_string(opt_string)) then
               this%destination =  opt_string(3:)
               exit
            else if (is_short_option_string(opt_string)) then
               ! Is a short opt string - possibly default unless earlier short was found
               if (.not. allocated(this%destination)) then
                  this%destination = opt_string(2:2)
               end if
            else ! is positinal argument
               this%destination = opt_string(:)
               this%positional = .true.
   !!$               if (present(dest)) then error
               exit
            end if
            call iter%next()
         end do
      end if

      if (present(type)) then
         this%type = type
      else
         this%type = 'string' ! default
      end if

      if (present(n_arguments)) then
         this%n_arguments = n_arguments
      else
         this%n_arguments = None
      end if

      if (present(help)) then
         this%help = help
      end if

      if (present(default)) then
         this%default = default
      else
         this%default = NONE
      end if

      if (present(const)) then
         this%const = const
      else
         this%const = NONE
      end if
   end subroutine initialize


   function get_destination(this) result(destination)
      character(:), allocatable :: destination
      class (BaseAction), intent(in) :: this

      destination = this%destination
   end function get_destination


   function get_help(this) result(help)
      character(:), allocatable :: help
      class (BaseAction), intent(in) :: this

      help = this%help
   end function get_help


   function get_type(this) result(type)
      character(:), allocatable :: type
      class (BaseAction), intent(in) :: this

      type = this%type
   end function get_type



   function get_option_strings(this) result(option_strings)
      type (StringVector), pointer :: option_strings
      class (BaseAction), target, intent(in) :: this

      option_strings => this%option_strings

   end function get_option_strings

   function get_default(this) result(default)
      class(*), pointer :: default
      class(BaseAction), target, intent(in) :: this

      default => this%default

   end function get_default


   function get_const(this) result(const)
      class(*), pointer :: const
      class(BaseAction), target, intent(in) :: this

      const => this%const

   end function get_const



   logical function matches(this, argument)
      class (BaseAction), intent(in) :: this
      character(len=*), intent(in) :: argument
      ! TODO: unimplemented
   end function matches



   ! Arg strings must either start with '-' or '--' and
   ! have at least one more word character
   logical function is_legal_option_string(string)
      character(len=*), intent(in) :: string

      character(*), parameter :: LETTERS = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
      character(*), parameter :: ALLOWED_CHARACTERS = LETTERS // '0123456789_-'

      select case (len(string))
      case (0,1)
         is_legal_option_string = .false.
      case (2)
         is_legal_option_string = (string(1:1) == '-' .and. verify(string(2:2), LETTERS) == 0)
      case (3:)
         is_legal_option_string = (string(1:2) == '--' .and. verify(string(3:), ALLOWED_CHARACTERS) == 0)
      end select

   end function is_legal_option_string

   logical function is_short_option_string(string)
      character(len=*), intent(in) :: string

      is_short_option_string = .false. ! unless
      if (is_legal_option_string(string)) then
         is_short_option_string = (len(string) == 2)
      end if

   end function is_short_option_string

   logical function is_long_option_string(string)
      character(len=*), intent(in) :: string

      is_long_option_string = .false. ! unless
      if (is_legal_option_string(string)) then
         is_long_option_string = (len(string) > 2)
      end if

   end function is_long_option_string


   subroutine print_help(this)
      class (BaseAction), target, intent(in) :: this

      character(:), allocatable :: line
      type (StringVectorIterator) :: iter

      line = '  '
      
      iter = this%option_strings%begin()
      line = line // iter%get()
      call iter%next()
      do while (iter /= this%option_strings%end())
         line = line // ', ' //iter%get()
         call iter%next()
      end do

      if (allocated(this%help)) then
         write(*,'(a,T30,a)') line, this%help
      else
         print*, line
      end if

   end subroutine print_help


   subroutine act(this, namespace, parser, value, option_string)
      use fp_AbstractArgParser, only: AbstractArgParser
      use gFTL_stringUnlimitedMap
      class (BaseAction), intent(inout) :: this
      type (StringUnlimitedMap), intent(inout) :: namespace
      class (AbstractArgParser), intent(in) :: parser
      class(*), intent(in) :: value
      character(*), optional, intent(in) :: option_string

      ERROR stop 'Not Implemented Error - BaseAction::act()'

   end subroutine act


   logical function has_default(this)
      class (BaseAction), intent(in) :: this

      select type (q => this%default)
      type is (t_None)
         has_default = .false.
      class default
         has_default = .true.
      end select

   end function has_default

   logical function is_positional(this)
      class (BaseAction), intent(in) :: this

      is_positional = this%positional

   end function is_positional

   function get_n_arguments(this) result(n_arguments)
      class(*), allocatable :: n_arguments
      class(BaseAction), intent(in) :: this

      n_arguments = this%n_arguments

   end function get_n_arguments



end module fp_BaseAction
