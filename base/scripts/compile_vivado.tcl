#------------------------------------------------------------------------------
# compile_vivado.tcl
# published as part of https://github.com/pConst/basic_verilog
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------


open_project test.xpr

reset_runs impl_1
launch_runs impl_1
wait_on_run impl_1

#open_run impl_1
#write_bitstream -force test.bit

# TODO create marker file only when Vivado is successful
exec touch .compile.done

