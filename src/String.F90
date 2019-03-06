! Needed as workaround for gfortran deferred length string bug

module fp_String
  implicit none
  private

  public :: String
  type :: String
     character(:), allocatable :: string
  end type String

  ! ifort-18 fails some use cases unless we provide an explicit copy
  ! constructor.  (Which in turn appears to drive the need for a
  ! workaround for the workaround for gfortran 8.2)
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


