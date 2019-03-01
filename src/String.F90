! Needed as workaround for gfortran deferred length string bug

module fp_String
  implicit none
  private

  public :: String
  type :: String
     character(:), allocatable :: string
  end type String

  interface String
     module procedure new_string
  end interface String

contains

   function new_string(s)
      type (String) :: new_string
      character(*), intent(in) :: s
      new_string%string = s
   end function new_string

end module fp_String


