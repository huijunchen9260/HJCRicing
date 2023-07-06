call plt%initialize(&
    usetex = .true., &
    xlabel = '$<++>$', &
    ylabel = '$<++>$', &
    title = '<++>',&
    legend = .true., &
    tight_layout = .true. &
    )
call plt%add_plot(&
    <++>, &
    <++>, &
    label = "<++>", &
    linestyle = '-', &
    linewidth = 1 &
    )
call plt%showfig()
