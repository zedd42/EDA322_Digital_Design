restart -f -nowave

force INSTRUCTION 2#00000000
force DATA 2#00000001
force ACC 2#00000010
force EXTDATA 2#00000011
run 100ns

force instrSEL 1
run 100ns

force instrSEL 0
force dataSEL 1
run 100ns

force dataSEL 0
force accSEL 1
run 100ns

force accSEL 0
force extdataSEL 1
run 100ns

force accSEL 1
run 100ns
