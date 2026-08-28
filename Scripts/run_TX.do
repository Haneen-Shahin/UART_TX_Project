vlib work
vlog Main_controller_FSM.v Serializer.v mux.v paritybit_calc.v UART_TX_tb.v
vsim -voptargs=+acc work.UART_TX_tb
add wave *
run -all 
#quit -sim
