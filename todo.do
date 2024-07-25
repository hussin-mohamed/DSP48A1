vlib work
vlog *.v
vsim -voptargs=+acc work.dsptb
add wave *
run -all
#quit -sim