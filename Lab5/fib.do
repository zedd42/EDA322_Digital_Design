restart -f nowave
add wave -radix unsigned CLK master_load_enable ARESETN disp2seg acc2seg aluOut2seg

force clk 0 0,1 1ns -repeat 2ns
force externalIn "00000000"
force aresetn 0
force master_load_enable 1
run 5ns

force aresetn 1
run 500ns