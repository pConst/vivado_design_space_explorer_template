#------------------------------------------------------------------------------
# set_prj_vivado.tcl
# published as part of https://github.com/pConst/basic_verilog
# Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------


# quickly read args, and don't even close file handles :)
set proj [split [read [open ".proj" r]] "\n"]
set part [split [read [open ".part" r]] "\n"]
set srcs [split [read [open ".srcs" r]] "\n"]
set xdcs [split [read [open ".xdcs" r]] "\n"]
set scripts [split [read [open ".scripts" r]] "\n"]

# remove last empty elements
set idx [lsearch ${proj} ""]
set proj [lreplace ${proj} ${idx} ${idx}]
set idx [lsearch ${part} ""]
set part [lreplace ${part} ${idx} ${idx}]
set idx [lsearch ${srcs} ""]
set srcs [lreplace ${srcs} ${idx} ${idx}]
set idx [lsearch ${xdcs} ""]
set xdcs [lreplace ${xdcs} ${idx} ${idx}]
set idx [lsearch ${scripts} ""]
set scripts [lreplace ${scripts} ${idx} ${idx}]

#puts "proj = [list ${proj}]"
#puts "part = [list ${part}]"
#puts "srcs = [list ${srcs}]"
#puts "xdcs = [list ${xdcs}]"
#puts "scripts = [list ${scripts}]"

# for example, xc7k325tffg900-2
create_project -force ${proj} . -part ${part}

if {${srcs} ne ""} {
  add_files -fileset sources_1 ${srcs}
  update_compile_order -fileset sources_1
}

if {${xdcs} ne ""} {
  add_files -fileset constrs_1 ${xdcs}
}

if {${scripts} ne ""} {
  add_files -fileset utils_1 ${scripts}
}

set aup_script "scripts/allow_undefined_ports.tcl"
if {${aup_script} in ${scripts}} {
  set_property STEPS.WRITE_BITSTREAM.TCL.PRE [get_files ${aup_script} -of [get_fileset utils_1]] [get_runs impl_1]
}

exec touch .setup.done

