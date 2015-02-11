restart -f nowave
add wave A B

force A 2#00000000
force B 2#00000000
run 100ns

force A 2#00000001
force B 2#00000000
run 100ns

force A 2#11111111
force B 2#11111111
run 100ns

