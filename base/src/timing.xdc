
# main reference clock, 1000 MHz requested
create_clock -name clk1 -period 1.000 -waveform {0.000 0.500} [get_ports { clk1 }]
create_clock -name clk2 -period 1.000 -waveform {0.000 0.500} [get_ports { clk2 }]