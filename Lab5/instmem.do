restart -f -nowave
add wave CLK WE ADDR OUTMEM

force CLK 0 0, 1 50ns -repeat 100ns
force WE 0
force ADDR 2#00000000
run 100ns

force ADDR 2#00000001
run 100ns

force ADDR 2#00000010
run 100ns

force ADDR 2#00000011
run 100ns

