#------------------------------------------------------------------------------
#  base Makefile for Vivado project
#  published as part of https://github.com/pConst/basic_verilog
#  Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------

PROJ = test

# selecting largest pin count part in the family
PART = xc7a200tffv1156-1

# # selecting target part
# PART = xc7k325tffg900-2

SRCS = src/main.sv \
       src/define.vh \
       src/fast_counter.sv

XDCS = src/timing.xdc

SCRIPTS = scripts/allow_undefined_ports.tcl

#------------------------------------------------------------------------------

.PHONY: all info setup compile clean

all: setup compile

info:
	echo -e \\n '    Project name: ' $(PROJ) \
	        \\n '    Part:         ' $(PART) \
		 \\n '    Sources:      ' $(SRCS) \
		 \\n '    Constraints:  ' $(XDCS) \
		 \\n '    Scripts:      ' $(SCRIPTS)


setup: .setup.done

.setup.done: $(SRCS) $(SCRIPTS)
	# passing args as files
	echo $(PROJ) > .proj
	echo $(PART) > .part
	echo $(SRCS) | tr -s " " "\012" > .srcs
	echo $(XDCS) | tr -s " " "\012" > .xdcs
	echo $(SCRIPTS) | tr -s " " "\012" > .scripts
	# processing
	vivado -mode batch -source scripts/set_prj_vivado.tcl
	# cleaning
	rm -f .proj
	rm -f .part
	rm -f .srcs
	rm -f .xdcs
	rm -f .scripts


compile: .compile.done

.compile.done: .setup.done
	vivado -mode batch -source scripts/compile_vivado.tcl


clean:
	$(shell ./clean_vivado.sh )
	rm -f $(PROJ).xpr
	rm -f .part
	rm -f .srcs
	rm -f .xdcs
	rm -f .scripts

