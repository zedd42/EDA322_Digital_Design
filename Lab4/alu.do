restart -f nowave
add wave ALU_inA ALU_inB Operation

force ALU_inA   2#00000000
force ALU_inB   2#00000000
force Operation 2#00
run 100ns

force ALU_inA   2#00000001
force ALU_inB   2#00000000
force Operation 2#00
run 100ns

force ALU_inA   2#00000001
force ALU_inB   2#00000001
force Operation 2#00
run 100ns

force ALU_inA   2#00000001
force ALU_inB   2#00000001
force Operation 2#01
run 100ns

force ALU_inA   2#00000001
force ALU_inB   2#00000001
force Operation 2#10
run 100ns

force ALU_inA   2#00000001
force ALU_inB   2#00000001
force Operation 2#11
run 100ns
