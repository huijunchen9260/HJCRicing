# set encoding utf8
#
# my_font = "SVBasic Manual, 12"
# my_line_width = "2"
# my_axis_width = "1.5"
# my_ps = "1.2"
# set pointsize my_ps
# See https://github.com/Gnuplotting/gnuplot-palettes
# Line styles (colorbrewer Set1)
set macros
MATLAB = "defined (0  0.0 0.0 0.5, \
                   1  0.0 0.0 1.0, \
                   2  0.0 0.5 1.0, \
                   3  0.0 1.0 1.0, \
                   4  0.5 1.0 0.5, \
                   5  1.0 1.0 0.0, \
                   6  1.0 0.5 0.0, \
                   7  1.0 0.0 0.0, \
                   8  0.5 0.0 0.0 )"
set terminal qt enhanced font "Alegreya, 14" size 1600, 960
set colors classic
# set style data linespoints
set style data lines
set style line 1 lc rgb '#E41A1C' pt 7 ps 1 lt 1 lw 2 # red
# set style line 1 lc rgb '#de181f' pt 7 ps 1 lt 1 lw 2 # red
set style line 2 lc rgb '#377EB8' pt 6 ps 1 lt 1 lw 2 # blue
set style line 3 lc rgb '#4DAF4A' pt 2 ps 1 lt 1 lw 2 # green
set style line 4 lc rgb '#984EA3' pt 3 ps 1 lt 1 lw 2 # purple
set style line 5 lc rgb '#FF7F00' pt 4 ps 1 lt 1 lw 2 # orange
set style line 6 lc rgb '#FFFF33' pt 5 ps 1 lt 1 lw 2 # yellow
set style line 7 lc rgb '#A65628' pt 1 ps 1 lt 1 lw 2 # brown
set style line 8 lc rgb '#F781BF' pt 8 ps 1 lt 1 lw 2 # pink
# Palette
set palette maxcolors 8
set palette defined ( 0 '#E41A1C', 1 '#377EB8', 2 '#4DAF4A', 3 '#984EA3',\
4 '#FF7F00', 5 '#FFFF33', 6 '#A65628', 7 '#F781BF' )
#
# # Standard border
set style line 11 lc rgb '#000000' lt 1 lw 3
# set style line 101 lc rgb '#808080' lt 1 lw 10 */
set border 3 front ls 11
set tics nomirror scale 1.5
set format '%g'
#
# # Standard grid
set style line 12 lc rgb '#808080' lt 0 lw 1
# # set style line 12 lc rgb '#6a6a6a' lt 1 lw 1
 set grid back ls 12
 set grid x y z vertical
# set style line 102 lc rgb '#808080' lt 0 lw 1
# set grid back ls 102
# # unset grid

# set macros
# png="set terminal png size 1800,1800 crop enhanced font \"/usr/share/fonts/truetype/times.ttf,30\" dashlength 2; set termoption linewidth 3"
# eps="set terminal postscript fontfile \"/usr/share/fonts/truetype/times.ttf\"; set termoption linewidth 3;
#
# set style line 1 linecolor rgb '#de181f' linetype 1  # Red
# set style line 2 linecolor rgb '#0060ae' linetype 1  # Blue
# set style line 3 linecolor rgb '#228C22' linetype 1  # Forest green
#
# set style line 4 linecolor rgb '#18ded7' linetype 1  # opposite Red
# set style line 5 linecolor rgb '#ae4e00' linetype 1  # opposite Blue
# set style line 6 linecolor rgb '#8c228c' linetype 1  # opposite Forest green
