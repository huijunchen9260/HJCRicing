#!/usr/bin/awk -f

BEGIN {

    ###################
    #  Configuration  #
    ###################

    ## Configuration explanation:
    ##   - If you want to use environment variable VAR: ENVIRON["VAR"]
    ##   - BIBFILE defines the location of your .bib file
    ##   - BIBUKEY defines the university url for journal authentication
    ##   - PDFPATH defines the location of all your research papers
    ##     - needs to have slash at the BEGINNING and the END of the string
    ##   - OPENER defines the system default file opener
    ##   - READER defines the pdf file opener
    ##   - EDITOR defines the text file opener
    ##   - BROWSER defines the browser to open url
    ##   - TEXTEMP defines the location for tex template for Notes
    ##     - needs to have slash at the BEGINNING of the string
    ##   - CLIPINW defines the command to copy into clipboard
    ##   - CLIPOUT defines the command to copy out from clipboard

    BIBFILE = ENVIRON["BIB"]
    BIBUKEY = ENVIRON["BIB_UNI_KEY"]
    PDFPATH = ENVIRON["BIB_PDF_PATH"]
    OPENER = ( ENVIRON["OSTYPE"] ~ /darwin.*/ ? "open" : "xdg-open" )
    READER = ( ENVIRON["READER"] == "" ? OPENER : ENVIRON["READER"] )
    EDITOR = ( ENVIRON["EDITOR"] == "" ? OPENER : ENVIRON["EDITOR"] )
    BROWSER = ( ENVIRON["BROWSER"] == "" ? OPENER : ENVIRON["BROWSER"] )
    TEXTEMP = ENVIRON["HOME"] "/.local/bin/hjapps/bib.awk/template.tex"
    CLIPINW = ( ENVIRON["OSTYPE"] ~ /darwin.*/ ? \
		"pbcopy" : \
		"xclip -selection clipboard" )
    CLIPOUT = ( ENVIRON["OSTYPE"] ~ /darwin.*/ ? \
		"pbpaste" : \
		"xclip -o -selection clipboard" )


    ################
    #  Parameters  #
    ################

    NTEPATH = PDFPATH "Notes/"		# Notes path
    LIBPATH = PDFPATH "Libs/"		# Libraries path
    APXPATH = PDFPATH "Appendices/"	# Appendices path
    movement = "default";		# movement cannot be empty

    ########################################################
    #  Define [a]ttributes, [b]ackground and [f]oreground  #
    ########################################################

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

    #####################
    #  Start of script  #
    #####################

    init()

    RS = "\f"
    menu[1] = "search on crossref by text" RS \
	      "search on crossref by metadata" RS \
	      "search on google scholar" RS \
	      "open research paper" RS \
	      "open research paper website" RS \
	      "copy BibTeX label" RS \
	      "write note" RS \
	      "open research appendices" RS \
	      "edit existing BibTeX entry" RS \
	      "manually create file hierarchy" RS \
	      "automatically create file hierarchy" RS \
	      "manually build database" RS \
	      "automatically update database" RS \
	      "open sublibraries" RS \
	      "create sublibraries" RS \
	      "edit sublibraries"
    menu[2] = RS
    menu[3] = 1
    menu[4] = "Choose action:"
    menu[5] = "Main menu"

    split(menu[1], choice, RS)

    list = menu[1]; delim = menu[2]; num = menu[3]; tmsg = menu[4]; bmsg = menu[5];


}


# Credit: https://stackoverflow.com/a/20078022
function isEmpty(arr) { for (idx in arr) return 0; return 1 }

function len(arr,   i) { for (idx in arr) { ++i }; return i }

function maxidx(arr,    idx) { for (idx in selorder) { pidx = (pidx <= idx ? idx : pidx ) }; return pidx }

##################
#  Start of TUI  #
##################

function finale() {
    clean_preview()
    printf "\033\1332J\033\133H" >> "/dev/stderr" # clear screen
    printf "\033\133?7h" >> "/dev/stderr" # line wrap
    printf "\033\1338" >> "/dev/stderr" # restore cursor
    printf "\033\133?25h" >> "/dev/stderr" # show cursor
    printf "\033\133?1049l" >> "/dev/stderr" # back from alternate buffer
    system("stty isig icanon echo")
    ENVIRON["LANG"] = LANG; # restore LANG
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

function CUP(lines, cols) {
    printf("\033\133%s;%sH", lines, cols) >> "/dev/stderr"
}

function dim_setup() {
    cmd = "stty size"
    cmd | getline d
    close(cmd)
    split(d, dim, " ")
    top = 3; bottom = dim[1] - 4;
    fin = bottom - ( bottom - (top - 1) ) % num; end = fin + 1;
    dispnum = (end - top) / num
}

function menu_TUI_page(list, delim) {
    answer = ""; page = 0; split("", pagearr, ":") # delete saved array
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
        loc = disp[entry]
        gsub(/\033\[[0-9][0-9]m|\033\[[0-9]m|\033\[m/, "", loc)
        if (parent != "" && loc == parent) {
            cursor = entry - dispnum*(page - 1); curpage = page
        }
    }

}

function search(list, delim, str, mode) {
    find = ""; str = tolower(str);
    if (mode == "dir") { regex = "^" str ".*/" }
    else if (mode == "begin") {regex = "^" str ".*"}
    else { regex = ".*" str ".*" }
    gsub(/[(){}\[\]]/, "\\\\&", regex) # escape special char

    # get rid of coloring to avoid find irrelevant item
    tmplist = list
    gsub(/\033\[[0-9][0-9]m|\033\[[0-9]m|\033\[m/, "", tmplist)
    split(list, sdisp, delim); split(tmplist, tmpsdisp, delim)

    for (entry = 1; entry in tmpsdisp; entry++) {
        match(tolower(tmpsdisp[entry]), regex)
        if (RSTART) { find = find delim sdisp[entry]; }
    }

    slist = substr(find, 2)
    return slist
}

function key_collect(list, pagerind) {
    key = ""; rep = 0
    do {

        cmd = "trap 'printf WINCH' WINCH; dd ibs=1 count=1 2>/dev/null"
        cmd | getline ans;
        close(cmd)

        if (++rep == 1) {
            srand(); time = srand()
            if (time - old_time == 0) { sec++ }
            else { sec = 0 }
            old_time = time
        }

        gsub(/[\\^\[\]]/, "\\\\&", ans) # escape special char
        # if (ans ~ /.*WINCH/ && pagerind == 0) { # trap SIGWINCH
        if (ans ~ /.*WINCH/) { # trap SIGWINCH
            cursor = 1; curpage = 1;
            if (pagerind == 0) {
                menu_TUI_page(list, delim)
                redraw(tmsg, bmsg)
            }
            else if (pagerind == 1) {
                printf "\033\1332J\033\133H" >> "/dev/stderr"
                dim_setup()
                Npager = (Nmsgarr >= dim[1] ? dim[1] : Nmsgarr)
                for (i = 1; i <= Npager; i++) {
                    CUP(i, 1)
                    printf "%s", msgarr[i] >> "/dev/stderr"
                }
            }
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

function yesno(command) {
    CUP(dim[1], 1)
    printf("%s%s %s? (y/n) ", a_clean, "Really execute command", command) >> "/dev/stderr"
    printf "\033\133?25h" >> "/dev/stderr" # show cursor
    key = key_collect(list, pagerind)
    printf "\033\133?25l" >> "/dev/stderr" # hide cursor
    if (key ~ /[Yy]/) return 1
}

function redraw(tmsg, bmsg) {
    printf "\033\1332J\033\133H" >> "/dev/stderr" # clear screen and move cursor to 0, 0
    CUP(top, 1); print pagearr[curpage] >> "/dev/stderr"
    CUP(top + cursor*num - num, 1); printf "%s%s%s%s", Ncursor ". ", a_reverse, disp[Ncursor], a_reset >> "/dev/stderr"
    CUP(top - 2, 1); print tmsg >> "/dev/stderr"
    CUP(dim[1] - 2, 1); print bmsg >> "/dev/stderr"
    CUP(dim[1], 1)
    # printf "Choose [\033\1331m1-%d\033\133m], current page num is \033\133;1m%d\033\133m, total page num is \033\133;1m%d\033\133m: ", Narr, curpage, page >> "/dev/stderr"
    printf "%sChoose [%s1-%d%s], current page num is %s%d%s, total page num is %s%d%s: ", a_clean, a_bold, Narr, a_reset, a_bold, curpage, a_reset, a_bold, page, a_reset >> "/dev/stderr"
    if (bmsg !~ /Action.*|Selecting\.\.\./ && ! isEmpty(selected)) draw_selected()
    if (bmsg !~ /Action.*|Selecting\.\.\./ && PREVIEW == 1) draw_preview(disp[Ncursor])
}

function menu_TUI(list, delim, num, tmsg, bmsg) {

    menu_TUI_page(list, delim)
    while (answer !~ /^[[:digit:]]+$|\.\.\//) {

        oldCursor = 1;

        ## calculate cursor and Ncursor
        cursor = ( cursor+dispnum*(curpage-1) > Narr ? Narr - dispnum*(curpage-1) : cursor )
        Ncursor = cursor+dispnum*(curpage-1)

        clean_preview()
        redraw(tmsg, bmsg)

        while (1) {

            answer = key_collect(list, pagerind)

            #######################################
            #  Key: entry choosing and searching  #
            #######################################

            if ( answer ~ /^[[:digit:]]$/ || answer == "/" || answer == ":" ) {
                CUP(dim[1], 1)
                if (answer ~ /^[[:digit:]]$/) {
                    printf "%sChoose [%s1-%d%s], current page num is %s%d%s, total page num is %s%d%s: %s", a_clean, a_bold, Narr, a_reset, a_bold, curpage, a_reset, a_bold, page, a_reset, answer >> "/dev/stderr"
                }
                else {
                    printf "%s%s", a_clean, answer >> "/dev/stderr" # clear line
                }
                printf "\033\133?25h" >> "/dev/stderr" # show cursor

                cmd_mode(list, answer)

                printf "\033\133?25l" >> "/dev/stderr" # hide cursor
                if (reply == "\003") { answer = ""; key = ""; reply = ""; break; }
                answer = cmd_trigger reply; reply = ""; split("", comparr, ":"); cc = 0; dd = 0;


                ## cd
                if (answer ~ /:cd .*/) {
                    old_dir = dir
                    gsub(/:cd /, "", answer)
                    if (answer ~ /^\/.*/) { # full path
                        dir = ( answer ~ /.*\/$/ ? answer : answer "/" )
                    }
                    else {
                        while (answer ~ /^\.\.\/.*/) { # relative path
                            gsub(/[^\/]*\/?$/, "", dir)
                            gsub(/^\.\.\//, "", answer)
                            dir = ( dir == "" ? "/" : dir )
                        }
                        dir = ( answer ~ /.*\/$/ || answer == "" ? dir answer : dir answer "/" )
                    }
                    # empty_selected()
                    tmplist = gen_content(dir, HIDDEN)
                    if (tmplist == "empty") {
                        dir = old_dir
                        # bmsg = sprintf("\033\13338;5;15m\033\13348;5;9m%s\033\133m", "Error: Path Not Exist")
                        bmsg = sprintf("%s%s%s%s", b_red, f_white, "Error: Path Not Exist", a_reset)
                    }
                    else {
                        list = tmplist
                    }
                    menu_TUI_page(list, delim)
                    tmsg = dir;
                    cursor = 1; curpage = (+curpage > +page ? page : curpage);
                    break
                }

                ## cmd mode
                if (answer ~ /:[^[:cntrl:]*]/) {
                    command = substr(answer, 2)
                    savecmd = command; post = ""
                    match(command, /\{\}/)
                    if (RSTART) {
                        post = substr(command, RSTART+RLENGTH+1);
                        command = substr(command, 1, RSTART-2)
                    }
                    if (command ~ /.*\$@.*/) {
                        idx = maxidx(selorder)
                        for (j = 1; j <= idx; j++) {
                            if (selorder[j] == "") continue
                            sellist = sellist " \"" selected[selorder[j]] "\" "
                        }
                        gsub(/\$@/, sellist, command)
                        empty_selected()
                    }
                    if (command in cmdalias) { command = cmdalias[command] }

                    if (command ~ /^rm$|rm .*/) { suc = yesno(command); if (suc == 0) break }

                    gsub(/["]/, "\\\\&", command) # escape special char
                    finale()
                    if (isEmpty(selected)) {
                        code = system("cd \"" dir "\" && eval \"" command "\" 2>/dev/null")
                    }
                    else {
                        idx = maxidx(selorder)
                        for (j = 1; j <= idx; j++) {
                            if (selorder[j] == "") continue
                            sel = selorder[j]
                            match(post, /\{\}/)
                            if (RSTART) {
                                post = substr(post, 1, RSTART-1) selected[sel] substr(post, RSTART+RLENGTH)
                            }
                            if (post) {
                                code = system("cd \"" dir "\" && eval \"" command " \\\"" selected[sel] "\\\" \\\"" post "\\\"\" 2>/dev/null")
                            }
                            else {
                                code = system("cd \"" dir "\" && eval \"" command " \\\"" selected[sel] "\\\"\" 2>/dev/null")
                            }
                        }
                        empty_selected()
                    }
                    init()

                    list = gen_content(dir, HIDDEN); tmsg = dir;
                    menu_TUI_page(list, delim)
                    if (code > 0) { printf("\n%s", savecmd) >> CMDHIST; close(CMDHIST) }
                    break
                }

                ## search
                if (answer ~ /\/[^[:cntrl:]*]/) {
                    slist = search(list, delim, substr(answer, 2), "")
                    if (slist != "") {
                        menu_TUI_page(slist, delim)
                        cursor = 1; curpage = 1; sind = 1
                    }
                    break
                }

                ## go to page
                if (answer ~ /[[:digit:]]+G$/) {
                    ans = answer; gsub(/G/, "", ans);
                    curpage = (+ans <= +page ? ans : page)
                    break
                }


                if (answer ~ /[[:digit:]]+$/) {
                    if (+answer > +Narr) answer = Narr
                    if (+answer < 1) answer = 1
                    curpage = answer / dispnum
                    curpage = sprintf("%.0f", (curpage == int(curpage)) ? curpage : int(curpage)+1)
                    cursor = answer - dispnum*(curpage-1); answer = ""
                    break
                }
            }

            if (answer ~ /[?]/) { pager(help); break; }

            if (answer == "!") {
                finale()
                system("cd \"" dir "\" && ${SHELL:=/bin/sh}")
                init()
                list = gen_content(dir, HIDDEN)
                menu_TUI_page(list, delim)
                break
            }

            if (answer == "-") {
                if (old_dir == "") break
                TMP = dir; dir = old_dir; old_dir = TMP;
                list = gen_content(dir, HIDDEN)
                menu_TUI_page(list, delim)
                tmsg = dir; bmsg = "Browsing"
                cursor = 1; curpage = (+curpage > +page ? page : curpage);
                break
            }


            ########################
            #  Key: Total Redraw   #
            ########################

            if ( answer == "v" ) { PREVIEW = (PREVIEW == 1 ? 0 : 1); break }
            if ( answer == ">" ) { RATIO = (RATIO > 0.8 ? RATIO : RATIO + 0.05); break }
            if ( answer == "<" ) { RATIO = (RATIO < 0.2 ? RATIO : RATIO - 0.05); break }
            if ( answer == "r" || answer == "." ||
               ( answer == "h" && ( bmsg == "Actions" || sind == 1 ) ) ||
               ( answer ~ /^[[:digit:]]$/ && (+answer > +Narr || +answer < 1 ) ) ) {
               if (answer == ".") { HIDDEN = (HIDDEN == 1 ? 0 : 1); }
               list = gen_content(dir, HIDDEN)
               delim = "\f"; num = 1; tmsg = dir; bmsg = "Browsing"; sind = 0; openind = 0;
               menu_TUI_page(list, delim)
               empty_selected()
               cursor = 1; curpage = (+curpage > +page ? page : curpage);
               break
           }
           if ( answer == "\n" || answer == "l" || answer ~ /\[C/ ) { answer = Ncursor; break }
           if ( answer == "a" ) {
               menu_TUI_page(action, RS)
               tmsg = "Choose an action"; bmsg = "Actions"
               cursor = 1; curpage = 1;
               break
           }
           if ( answer ~ /q|\003/ ) exit
           if ( (answer == "h" || answer ~ /\[D/) && dir != "/" ) { answer = "../"; disp[answer] = "../"; bmsg = ""; break }
           if ( (answer == "h" || answer ~ /\[D/) && dir = "/" ) continue
           if ( (answer == "n" || answer ~ /\[6~/) && +curpage < +page ) { curpage++; break }
           if ( (answer == "n" || answer ~ /\[6~/) && +curpage == +page && cursor != Narr - dispnum*(curpage-1) ) { cursor = ( +curpage == +page ? Narr - dispnum*(curpage-1) : dispnum ); break }
           if ( (answer == "n" || answer ~ /\[6~/) && +curpage == +page && cursor == Narr - dispnum*(curpage-1) ) continue
           if ( (answer == "p" || answer ~ /\[5~/) && +curpage > 1) { curpage--; break }
           if ( (answer == "p" || answer ~ /\[5~/) && +curpage == 1 && cursor != 1 ) { cursor = 1; break }
           if ( (answer == "p" || answer ~ /\[5~/) && +curpage == 1 && cursor == 1) continue
           if ( (answer == "g" || answer ~ /\[H/) && ( curpage != 1 || cursor != 1 ) ) { curpage = 1; cursor = 1; break }
           if ( (answer == "g" || answer ~ /\[H/) && curpage = 1 && cursor == 1 ) continue
           if ( (answer == "G" || answer ~ /\[F/) && ( curpage != page || cursor != Narr - dispnum*(curpage-1) ) ) { curpage = page; cursor = Narr - dispnum*(curpage-1); break }
           if ( (answer == "G" || answer ~ /\[F/) && curpage == page && cursor = Narr - dispnum*(curpage-1) ) continue

            #########################
            #  Key: Partial Redraw  #
            #########################

           if ( (answer == "j" || answer ~ /\[B/) && +cursor <= +dispnum ) { oldCursor = cursor; cursor++; }
           if ( (answer == "j" || answer ~ /\[B/) && +cursor > +dispnum && +curpage < +page && +page > 1 ) { cursor = 1; curpage++; break }
           if ( (answer == "k" || answer ~ /\[A/) && +cursor == 1 && +curpage > 1 && +page > 1 ) { cursor = dispnum; curpage--; break }
           if ( (answer == "k" || answer ~ /\[A/) && +cursor > 1 ) { oldCursor = cursor; cursor--; }

           if ( (answer == "\006") && cursor <= +dispnum ) { oldCursor = cursor; cursor = cursor + move }
           if ( (answer == "\006") && +cursor > +dispnum && +curpage < +page && +page > 1 ) { cursor = cursor - dispnum; curpage++; break }
           if ( (answer == "\006") && +cursor > Narr - dispnum*(curpage-1) && +curpage == +page ) { cursor = ( +curpage == +page ? Narr - dispnum*(curpage-1) : dispnum ); break }
           if ( (answer == "\006") && +cursor == Narr - dispnum*(curpage-1) && +curpage == +page ) break

           if ( (answer == "\025") && cursor >= 1 ) { oldCursor = cursor; cursor = cursor - move }
           if ( (answer == "\025") && +cursor < 1 && +curpage > 1 ) { cursor = dispnum + cursor; curpage--; break }
           if ( (answer == "\025") && +cursor < 1 && +curpage == 1 ) { cursor = 1; break }
           if ( (answer == "\025") && +cursor == 1 && +curpage == 1 ) break

           if ( answer == "H" ) { oldCursor = cursor; cursor = 1; }
           if ( answer == "M" ) { oldCursor = cursor; cursor = ( +curpage == +page ? int((Narr - dispnum*(curpage-1))*0.5) : int(dispnum*0.5) ); }
           if ( answer == "L" ) { oldCursor = cursor; cursor = ( +curpage == +page ? Narr - dispnum*(curpage-1) : dispnum ); }

            ####################
            #  Key: Selection  #
            ####################

           if ( answer == " " ) {
               if (selected[dir,Ncursor] == "") {
                   TMP = disp[Ncursor];
                   gsub(/\033\[[0-9][0-9]m|\033\[[0-9]m|\033\[m/, "", TMP)
                   selected[dir,Ncursor] = dir TMP;
                   seldisp[dir,Ncursor] = TMP;
                   selpage[dir,Ncursor] = curpage;
                   selnum[dir,Ncursor] = Ncursor;
                   selorder[++order] = dir SUBSEP Ncursor
                   bmsg = disp[Ncursor] " selected"
               }
               else {
                   for (idx in selorder) { if (selorder[idx] == dir SUBSEP Ncursor) { delete selorder[idx]; break } }
                   delete selected[dir,Ncursor];
                   delete seldisp[dir,Ncursor];
                   delete selpage[dir,Ncursor];
                   delete selnum[dir,Ncursor];
                   bmsg = disp[Ncursor] " cancelled"
               }
               if (+Narr == 1) { break }
               if (+cursor <= +dispnum || +cursor <= +Narr) { cursor++ }
               if (+cursor > +dispnum || +cursor > +Narr) { cursor = 1; curpage = ( +curpage == +page ? 1 : curpage + 1 ) }
               break
           }

           if (answer == "S") {
               if (isEmpty(selected)) {
                   selp = 0
                   for (entry = 1; entry in disp; entry++) {
                       TMP = disp[entry];
                       gsub(/\033\[[0-9][0-9]m|\033\[[0-9]m|\033\[m/, "", TMP)
                       if (TMP != "./" && TMP != "../") {
                           selected[dir,entry] = dir TMP;
                           seldisp[dir,entry] = TMP;
                           selpage[dir,entry] = ((+entry) % (+dispnum) == 1 ? ++selp : selp)
                           selnum[dir,entry] = entry;
                           selorder[++order] = dir SUBSEP entry
                       }
                   }
                   bmsg = "All selected"
               }
               else {
                   empty_selected()
                   bmsg = "All cancelled"
               }
               break
           }

           if (answer == "s") {
               # for (sel in selected) {
               #     selcontent = selcontent "\n" selected[sel]
               # }
               idx = maxidx(selorder)
               for (j = 1; j <= idx; j++) {
                   if (selorder[j] == "") continue
                   selcontent = selcontent "\n" j ". " selected[selorder[j]]
               }
               pager("Selected item: \n" selcontent); selcontent = ""; break;
           }

            ####################################################################
            #  Partial redraw: tmsg, bmsg, old entry, new entry, and selected  #
            ####################################################################

            Ncursor = cursor+dispnum*(curpage-1); oldNcursor = oldCursor+dispnum*(curpage-1);
            if (Ncursor > Narr) { Ncursor = Narr; cursor = Narr - dispnum*(curpage-1); continue }
            if (Ncursor < 1) { Ncursor = 1; cursor = 1; continue }

            CUP(dim[1] - 2, 1); # bmsg
            printf a_clean >> "/dev/stderr" # clear line
            print bmsg >> "/dev/stderr"

            CUP(top + oldCursor*num - num, 1); # old entry
            for (i = 1; i <= num; i++) {
                printf a_clean >> "/dev/stderr" # clear line
                CUP(top + oldCursor*num - num + i, 1)
            }
            CUP(top + oldCursor*num - num, 1);
            printf "%s", oldNcursor ". " disp[oldNcursor] >> "/dev/stderr"

            CUP(top + cursor*num - num, 1); # new entry
            for (i = 1; i <= num; i++) {
            printf a_clean >> "/dev/stderr" # clear line
            CUP(top + cursor*num - num + i, 1)
            }
            CUP(top + cursor*num - num, 1);
            printf "%s%s%s%s", Ncursor ". ", a_reverse, disp[Ncursor], a_reset >> "/dev/stderr"

            if (bmsg !~ /Action.*|Selecting\.\.\./ && ! isEmpty(selected)) draw_selected()
            if (bmsg !~ /Action.*|Selecting\.\.\./ && PREVIEW == 1) draw_preview(disp[Ncursor])
        }

    }

    result[1] = disp[answer]
    result[2] = bmsg
}

function pager(msg) { # pager to print out stuff and navigate
    printf "\033\1332J\033\133H" >> "/dev/stderr"
    if (PREVIEW == 1) { printf "{\"action\": \"remove\", \"identifier\": \"PREVIEW\"}\n" > FIFO_UEBERZUG; close(FIFO_UEBERZUG) }
    Nmsgarr = split(msg, msgarr, "\n")
    Npager = (Nmsgarr >= dim[1] ? dim[1] : Nmsgarr)
    for (i = 1; i <= Npager; i++) {
        CUP(i, 1)
        printf "%s", msgarr[i] >> "/dev/stderr"
    }

    pagerind = 1;
    while (key = key_collect(list, pagerind)) {
        if (key == "\003" || key == "\033" || key == "q" || key == "h") break
        if ((key == "j" || key ~ /\[B/) && i < Nmsgarr) { printf "\033\133%d;H\n", Npager >> "/dev/stderr"; printf msgarr[i++] >> "/dev/stderr" }
        if ((key == "k" || key ~ /\[A/) && i > dim[1] + 1) { printf "\033\133H\033\133L" >> "/dev/stderr"; i--; printf msgarr[i-dim[1]] >> "/dev/stderr" }
    }
    pagerind = 0;
}

######################
#  Start of Preview  #
######################

function draw_preview(item) {

    border = int(dim[2]*RATIO) # for preview

    # clear RHS of screen based on border
    clean_preview()

    gsub(/\033\[[0-9][0-9]m|\033\[[0-9]m|\033\[m/, "", item)
    path = dir item
    if (path ~ /.*\/$/) { # dir
        content = gen_content(path)
        split(content, prev, "\f")
        for (i = 1; i <= ((end - top) / num); i++) {
            CUP(top + i - 1, border + 1)
            print prev[i] >> "/dev/stderr"
        }
    }
    else { # Standard file
        if (FMAWK_PREVIEWER == "") {
            cmd = "file " path
            cmd | getline props
            if (props ~ /text/) {
                getline content < path
                close(path)
                split(content, prev, "\n")
                for (i = 1; i <= ((end - top) / num); i++) {
                    CUP(top + i - 1, border + 1)
                    code = gsub(/\000/, "", prev[i])
                    if (code > 0) {
                        # printf "\033\13338;5;0m\033\13348;5;15m%s\033\133m", "binary" >> "/dev/stderr"
                        printf "%s%s%s%s", a_reverse, f_white, "binary", a_reset >> "/dev/stderr"
                        break
                    }
                    print prev[i] >> "/dev/stderr"
                }
            }
        }
        else {
            system(FMAWK_PREVIEWER " \"" path "\" \"" CACHE "\" \"" border+1 "\" \"" ((end - top)/num) "\" \"" top "\" \"" dim[2]-border-1 "\"")
        }

    }
}

function clean_preview() {
    for (i = top; i <= end; i++) {
        CUP(i, border - 1)
        printf "\033\133K" >> "/dev/stderr" # clear line
    }
    if (FIFO_UEBERZUG == "") return
    printf "{\"action\": \"remove\", \"identifier\": \"PREVIEW\"}\n" > FIFO_UEBERZUG
    close(FIFO_UEBERZUG)
}
