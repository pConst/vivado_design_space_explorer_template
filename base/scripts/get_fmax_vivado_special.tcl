#------------------------------------------------------------------------------
# get_fmax_vivado_special.tcl
# published as part of https://github.com/pConst/basic_verilog
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------


# compuiting fmax, in MHz, given target clock is 1000 MHz
open_project test.xpr
open_run impl_1
puts [expr round(1e3/(1-[get_property SLACK [get_timing_paths]]))]

