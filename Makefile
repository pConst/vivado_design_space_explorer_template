#------------------------------------------------------------------------------
#  vivado_design_space_explorer_template
#  Makefile for iterative compilation for AMD / Xilinx Vivado
#  published as part of https://github.com/pConst/basic_verilog
#  Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------
#
#
# INFO ------------------------------------------------------------------------
# - This is a top-level Makefile
# - It makes a bunch of Vivado project copies which differ only one variable
# - Then it compiles all projects in parallel and collects FMAX data
#
# - Please define var sweep range below
# - Separate quartus project will be created and compiled for every var value
#
# - This makefile is "make -j"-friendly
#


VAR_START = 5
VAR_STOP = 64
VAR = $(shell seq $(VAR_START) ${VAR_STOP})

JOBS = $(addprefix job,${VAR})


.PHONY: all report clean


all: report
	echo '$@ success'

${JOBS}: job%:
	mkdir -p ./$*; \
	cp -r ./base/* ./$*; \
	echo "// Do not edit. This file is auto-generated" > ./$*/src/define.vh; \
	echo "\`define WIDTH $*" >> ./$*/src/define.vh; \
	$(MAKE) -C ./$* all

# TODO: Launching Vivado is inefficient here
#       Analyze text reports instead
fmax.csv: ${JOBS}
	echo '# FMAX summary report for iterative compilation' > fmax.csv; \
	v=$(VAR_START);	while [ "$$v" -le $(VAR_STOP) ]; do \
		cd $$v; \
		vivado -mode batch -source scripts/get_fmax_vivado_special.tcl \
			| tail -n2 | head -n1 >> ../fmax.csv; \
		cd ..; \
		v=$$((v+1)); \
	done

report: fmax.csv
	cat fmax.csv

clean:
	v=$(VAR_START);	while [ "$$v" -le $(VAR_STOP) ]; do \
		rm -rfv $$v; \
		rm -rfv fmax.csv; \
		v=$$((v+1)); \
	done

