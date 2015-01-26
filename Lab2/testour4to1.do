#restart -f -nowave

#add wave a b c d sel z

force a 2#01010101
force b 2#11110000
force c 2#00001111
force d 2#11111111

force sel 2#01
run 100ns
force sel 2#11
run 100ns
force sel 2#00
run 100ns
force sel 2#10
run 100ns




