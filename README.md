
vivado_design_space_explorer_template
-------------------------------------

This project shows how to make iterative compilation for AMD / Xilinx FPGAs

The idea is similar to the small utility, that is being shipped with Altera /
Intel Quartus suite, called dse.exe

We create a bunch of generated Vivado project copies which differ only one variable.
All projects get compiled in parallel collecting FMAX data

This particular test shows FMAX advantage of using 'fast_counter.sv' module

Launch compilation using "make -j". And be careful with large j's there ;)

