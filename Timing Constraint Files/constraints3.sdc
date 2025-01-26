# create a clock with 50% duty cycle , freq 571MHz(1.75s period) and name clk
create_clock [get_ports clk] -name clk -period 1.75 -waveform {0 0.875} 

# set latency to 250ps
set_clock_latency -source 0.25 [get_clocks clk]

# set uncertainty to 15ps for setup analysis and 10 ps for hold analysis
set_clock_uncertainty -setup 0.015 [get_clocks clk]
set_clock_uncertainty -hold 0.01 [get_clocks clk]

# set transition time to 1% of clock period(17.5ps)
set_clock_transition 0.0175[get_clocks clk]

# set output delay for setup analysis for all outputs to 0.75ns
set_output_delay -clock clk -network_latency_included -max 0.75 [all_outputs]

# set output delay for hold analysis to 0.25ns
set_output_delay -clock clk -network_latency_included -min 0.25 [all_outputs]

# set output load for setup analysis at 0.4pF
set_load 0.4 -max [all_outputs]

# set output load for hold analysis at 0.05pF
set_load 0.05 -min [all_outputs]

# set input delay for all inputs for setup analysis at 0.75ns
set_input_delay -clock clk -max 0.75 [all_inputs]

# set input delay for all inputs for hold time analysis at 0.25ns
set_input_delay -clock clk -min 0.25 [all_inputs]

# set setup driving cell BUFX4 and hold driving cell BUFX8
set_driving_cell -lib_cell BUFX4 -max [all_inputs]
set_driving_cell -lib_cell BUFX8 -min [all_inputs] 
