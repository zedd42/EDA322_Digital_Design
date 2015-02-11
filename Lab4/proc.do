restart -f nowave

add wave INSTRUCTION DATA ACC EXTDATA OUTPUT ERR instrsel datasel accsel extdatasel sel

force INSTRUCTION 2#00000000
force DATA        2#11111111
force ACC         2#00001111
force EXTDATA     2#11110000
force instrsel    0
force datasel     0
force accsel      0
force extdatasel  0
run 50ns

force instrsel 1
run 50ns

force instrsel 0
force datasel  1
run 50ns

force datasel 0
force accsel  1
run 50ns

force accsel 0
force extdatasel 1
run 50ns

force datasel 1
run 50ns

