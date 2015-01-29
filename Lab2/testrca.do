#restart -f -nowave

#add wave A B CIN COUT SUM

force A     10#1 
force B     10#1
force CIN   10#0
run 100ns

force A     10#8 
force B     10#2
force CIN   10#1
run 100ns

force A     10#12 
force B     10#4
force CIN   10#0
run 100ns

force A     10#10 
force B     10#10
force CIN   10#1
run 100ns

force A     10#2 
force B     10#7
force CIN   10#1
run 100ns

force A     10#132 
force B     10#123
force CIN   10#0
run 100ns

force A     10#150
force B     10#105
force CIN   10#1
run 100ns

force A     10#255 
force B     10#0
force CIN   10#1
run 100ns


