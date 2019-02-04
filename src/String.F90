! Needed as workaround for gfortran deferred length string bug

module fp_String
  implicit none
  private

  public :: String
  type :: String
     character(:), allocatable :: string
  end type String

end module fp_String
