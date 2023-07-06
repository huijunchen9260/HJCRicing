program main
    use, intrinsic :: iso_fortran_env, only : stdin=>input_unit, &
                                            stdout=>output_unit, &
                                            stderr=>error_unit
    use, intrinsic :: iso_c_binding, only: c_int
    implicit none
    character(len=*), parameter :: esc_c = achar(27)
    integer :: ch
    integer :: LINES, COLS
    integer :: iunit = 50

    interface
        ! int getchar(void)
        function c_getchar() bind(c, name='getchar')
            import :: c_int
            implicit none
            integer(kind=c_int) :: c_getchar
        end function c_getchar
    end interface

    call term_resize(LINES, COLS)

    call term_setup()

    call esc('CUP', '1', '1')
    ch = c_getchar()
    print *, achar(ch)

    call term_reset()

contains

    subroutine term_resize(LINES, COLS)
        ! character(len=*), parameter   :: PARENT = '/tmp/'
        character(len=*), parameter                :: tmp_file = '/tmp/size.tmp'
        character(len=:), allocatable              :: cmd
        integer                                    :: iunit, rc, l, c
        integer, intent(out)                       :: LINES, COLS
        ! character(len=30) :: LINES, COLS call random_file(file_path=tmp_file, parent=PARENT, n=12, ext='.tmp')
        cmd = 'stty size > ' // tmp_file
        call execute_command_line(cmd, exitstat=rc)
        open (unit=iunit, file=tmp_file, status='old', action='read', iostat=rc)
        read (iunit, *) LINES, COLS
        close(iunit, status='delete')

    end subroutine term_resize


    subroutine term_setup()
        call execute_command_line('stty -isig -icanon -echo')
        call esc('screen_alt', 'h')
        call esc('DECAWM', 'l')
        call esc('DECTCEM', 'l')
        call esc('ED', '2')
        call esc('DECRC')
        call esc('blink_bar')
    end subroutine term_setup

    subroutine term_reset()
        call execute_command_line('stty isig icanon echo')
        call esc('DECSC')
        call esc('ED', '2')
        call esc('DECAWM', 'h')
        call esc('DECTCEM', 'h')
        call esc('screen_alt', 'l')

    end subroutine term_reset


    subroutine esc(vt, char1, char2)
        character(len=*), intent(in) :: vt
        character(len=*), optional :: char1, char2
        character(len=9) :: ch1, ch2


        ch1 = '1'; if (present(char1)) ch1 = char1
        ch2 = '1'; if (present(char1)) ch2 = char2

        select case (vt)
            case ('CUU') ! cursor up
                ! ch1: numbers of cursor up
                write (*, '(a)', advance='no') esc_c // '[' // trim(ch1) // 'A'
            case ('CUD') ! cursor down
                ! ch1: numbers of cursor down
                write (*, '(a)', advance='no') esc_c // '[' // trim(ch1) // 'B'
            case ('CUP') ! cursor position
                ! ch1: row of the cursor position
                ! ch2: column of the cursor position
                write (*, '(a)', advance='no') esc_c // '[' // trim(ch1) // ';' // trim(ch2) // 'H'
            case ('DECAWM') ! line wrap
                ! ch1 -> l: line wrap off; h: line wrap on
                write (*, '(a)', advance='no') esc_c // '[?7' // trim(ch1)
            case ('DECRC') ! cursor restore
                write (*, '(a)', advance='no') esc_c // '8'
            case ('DECSC') ! cursor save
                write (*, '(a)', advance='no') esc_c // '7'
            case ('DECSTBM') ! scroll region
                ! ch1: top row of the scroll region
                ! ch2: bottom row of the scroll region
                write (*, '(a)', advance='no') esc_c // '[' // trim(ch1) // ';' // trim(ch2) // 'r'
            case ('DECTCEM') ! cursor visible
                ! ch1 -> l: cursor visible off; h: cursor visible on
                write (*, '(a)', advance='no') esc_c // '[?25' // trim(ch1)
            case ('ED') ! clear screen
                write (*, '(a)', advance='no') esc_c // '[' // trim(ch1) // 'J'
            case ('EL') ! clear line
                write (*, '(a)', advance='no') esc_c // '[' // trim(ch1) // 'K'
            case ('IL') ! insert line
                write (*, '(a)', advance='no') esc_c // '[' // trim(ch1) // 'L'
            case ('SGR') ! colors
                write (*, '(a)', advance='no') esc_c // '[' // trim(ch1) // ';' // trim(ch2) // 'm'
            case ('screen_alt') ! alternate buffer
                ! ch1 -> l: leave alternate buffer; h: enter alternate buffer
                write (*, '(a)', advance='no') esc_c // '[?1049' // trim(ch1)
            case ('blink_bar')
                write (*, '(a)') esc_c // '[5 q'
            case ('DSR')
                write (*, '(a)') esc_c // '[6n'
        end select

    end subroutine esc

    subroutine random_file(file_path, parent, n, ext)
        !! Returns a random file path in string `file_path`, with parent
        !! directory 'parent`, for instance: `/tmp/aUqCmPev.tmp`.
        !!
        !! The returned file name contains `n` random characters in range
        !! [A-Za-z], plus the given extension.
        character(len=:), allocatable, intent(inout) :: file_path
        character(len=*),              intent(in)    :: parent
        integer,                       intent(in)    :: n
        character(len=*),              intent(in)    :: ext
        character(len=n)                             :: tmp
        integer                                      :: i, l
        real                                         :: r(n)

        file_path = parent
        l = len(parent)
        if (parent(l:l) /= '/') file_path = file_path // '/'

        call random_number(r)

        do i = 1, n
            if (r(i) < 0.5) then
                tmp(i:i) = achar(65 + int(25 * r(i)))
            else
                tmp(i:i) = achar(97 + int(25 * r(i)))
            end if
        end do

        file_path = file_path // tmp // ext
    end subroutine random_file


end program main
