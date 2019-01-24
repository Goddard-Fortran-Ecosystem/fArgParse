module fp_None
   implicit none
   private

   public :: none
   public :: t_None

   type :: t_None ! private type
    contains
      procedure :: equal_equal
      generic :: operator(==) => equal_equal
   end type t_None

   type (t_None), parameter :: NONE = t_NONE()

 contains

   logical function equal_equal(this, other)
     class (t_None), intent(in) :: this
     class (*), intent(in) :: other

     select type (other)
     type is (t_None)
        equal_equal = .true.
     class default
        equal_equal = .false.
     end select
        
   end function equal_equal
   
end module fp_None
