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
# - Separate vivado project will be created and compiled for every var value
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

fmax.csv: ${JOBS}
	echo '# FMAX summary report for iterative compilation' > fmax.csv; \
	echo 'var, clk1, clk2' >> fmax.csv; \
	export BC_LINE_LENGTH=0; \
	v=$(VAR_START);	while [ "$$v" -le $(VAR_STOP) ]; do \
		echo $$v | xargs echo -n >> fmax.csv; \
		echo -n ', ' >> fmax.csv; \
		(cat ./$$v/test.runs/impl_1/main_timing_summary_routed.rpt | \
			grep -A6 '| Intra Clock Table' | tail -n1 | gawk {'print $$2'} | \
			xargs echo -n '1000/(1-'; echo ')') | bc | xargs echo -n >> fmax.csv; \
		echo -n ', ' >> fmax.csv; \
		(cat ./$$v/test.runs/impl_1/main_timing_summary_routed.rpt | \
			grep -A7 '| Intra Clock Table' | tail -n1 | gawk {'print $$2'} | \
			xargs echo -n '1000/(1-'; echo ')') | bc | xargs echo -n >> fmax.csv; \
		echo >> fmax.csv; \
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

