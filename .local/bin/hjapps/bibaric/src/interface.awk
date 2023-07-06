#!/usr/bin/awk -f

BEGIN{

    #########################
    # Parameters Definition #
    #########################

    RS = "\a"
    colors()
    cursor = 1; curpage = 1;

    ###############################
    # Read Command Line Arguments #
    ###############################

    while (ARGV[++pos]) {
        if (ARGV[pos] == "--Delim") delim = ARGV[++pos]
        if (ARGV[pos] == "--Num") num = ARGV[++pos]
        if (ARGV[pos] == "--Tmsg") tmsg = ARGV[++pos]
        if (ARGV[pos] == "--Bmsg") bmsg = ARGV[++pos]
        if (ARGV[pos] == "--Help") { showhelp(); exit }
    }

    getline content < "/dev/stdin"
    close("/dev/stdin")

    # init()

    main(content, delim, num)

    # print list
    # print i

    # while (1) {
    #     printf ""
    # }


    # Explicitly exit to enter END
    exit
}

# END{
#     finale()
# }

function main(content, delim, num,    i) {
    list = ( sind == 1 ? slist : content )
    menu_TUI_page(list, delim)
    for (page = 1;  page in pagearr; page++) {
        print pagearr[page]
    }
    # do {
    #     list = ( sind == 1 ? slist : content )

    # } while (1)
}

function colors() {
    # define [a]ttributes, [b]ackground and [f]oreground
    a_bold = "\033\1331m"
    a_reverse = "\033\1337m"
    a_clean = "\033\1332K"
    a_reset = "\033\133m"
    b_red = "\033\13341m"
    f_red = "\033\13331m"
    f_green = "\033\13332m"
    f_yellow = "\033\13333m"
    f_blue = "\033\13334m"
    f_magenta = "\033\13335m"
    f_cyan = "\033\13336m"
    f_white = "\033\13337m"
}


function showhelp() {
    print "help"
}


function init() {
    system("stty -isig -icanon -echo")
    printf "\033\1332J\033\133H" >> "/dev/stderr" # clear screen
    printf "\033\133?1049h" >> "/dev/stderr" # alternate buffer
    printf "\033\1337" >> "/dev/stderr" # save cursor
    printf "\033\133?25l" >> "/dev/stderr" # hide cursor
    printf "\033\1335 q" >> "/dev/stderr" # blinking bar
    printf "\033\133?7l" >> "/dev/stderr" # line unwrap
    LANG = ENVIRON["LANG"]; # save LANG
    ENVIRON["LANG"] = C; # simplest locale setting
}

function finale() {
    printf "\033\1332J\033\133H" >> "/dev/stderr" # clear screen
    printf "\033\133?7h" >> "/dev/stderr" # line wrap
    printf "\033\1338" >> "/dev/stderr" # restore cursor
    printf "\033\133?25h" >> "/dev/stderr" # show cursor
    printf "\033\133?1049l" >> "/dev/stderr" # back from alternate buffer
    system("stty isig icanon echo")
    ENVIRON["LANG"] = LANG; # restore LANG
}

function key_collect(list, pagerind) {
    key = ""; rep = 0
    do {

        cmd = "trap 'printf WINCH' WINCH; dd ibs=1 count=1 2>/dev/null"
        cmd | getline ans;
        close(cmd)

        gsub(/[\\^\[\]]/, "\\\\&", ans) # escape special char
        if (ans ~ /.*WINCH/ && pagerind == 0) { # trap SIGWINCH
            cursor = 1; curpage = 1;
            menu_TUI_page(list, delim)
            redraw(tmsg, bmsg)
            gsub(/WINCH/, "", ans);
        }
        if (ans ~ /\033/ && rep == 1) { ans = ""; continue; } # first char of escape seq
        else { key = key ans; }
        if (key ~ /[^\x00-\x7f]/) { break } # print non-ascii char
        if (key ~ /^\\\[5$|^\\\[6$$/) { ans = ""; continue; } # PageUp / PageDown
    } while (ans !~ /[\x00-\x5a]|[\x5f-\x7f]/)
    # } while (ans !~ /[\006\025\033\003\177[:space:][:alnum:]><\}\{.~\/:!?*+-]|"|[|_$()]/)
    return key
}

function CUP(lines, cols) {
    printf("\033\133%s;%sH", lines, cols) >> "/dev/stderr"
}

function dim_setup() {
    cmd = "stty -F /dev/tty size"
    cmd | getline d
    close(cmd)
    split(d, dim, " ")
    top = 3; bottom = dim[1] - 4;
    fin = bottom - ( bottom - (top - 1) ) % num; end = fin + 1;
    dispnum = (end - top) / num
}


function menu_TUI_page(list, delim,    answer, page) {
    split("", pagearr, ":") # delete saved array
    dim_setup()
    Narr = split(list, disp, delim)
    dispnum = (dispnum <= Narr ? dispnum : Narr)
    move = int( ( dispnum <= Narr ? dispnum * 0.5 : Narr * 0.5 ) )

    # generate display content for each page (pagearr)
    for (entry = 1; entry in disp; entry++) {
        if ((+entry) % (+dispnum) == 1 || Narr == 1) { # if first item in each page
            pagearr[++page] = entry ". " disp[entry]
        }
        else {
            pagearr[page] = pagearr[page] "\n" entry ". " disp[entry]
        }
        # loc = disp[entry]
        # gsub(/\033\[[0-9][0-9]m|\033\[[0-9]m|\033\[m/, "", loc)
        # if (parent != "" && loc == parent) {
        #     cursor = entry - dispnum*(page - 1); curpage = page
        # }
    }

}
