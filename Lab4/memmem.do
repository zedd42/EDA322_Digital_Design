restart -f -nowave
add wave CLK WE ADDR DATAIN OUTMEM

force CLK 0 0, 1 25ns -repeat 50ns
force WE 0
force ADDR 2#00000000
force DATAIN 2#00000000
run 50ns

force ADDR 2#00000001
run 50ns

force ADDR 2#00000010
run 50ns

force ADDR 2#00000011
run 50ns
