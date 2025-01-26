
set_db init_lib_search_path /mnt/apps/prebuilt/eda/designkits/GPDK/gsclib045/lan/flow/t1u1/reference_libs/GPDK045/gsclib045_svt_v4.4/gsclib045
set_db script_search_path /home/a/atsarnad/
set_db init_hdl_search_path /home/a/atsarnad/


set_db library {timing/slow_vdd1v0_basicCells.lib}
set_db lef_library {lef/gsclib045_tech.lef lef/gsclib045_macro.lef} 
read_qrc qrc/qx/gpdk045.tch

set_db / .use_scan_seqs_for_non_dft false


read_hdl picorv32.v

elaborate picorv32

write_netlist -lec > elab.v
write_do_lec -top picorv32 -golden_design rtl -revised_design elab.v -log_file rtl_elab.lec.log > rtl_elab.do
check_design

read_sdc constraints.sdc
check_timing_intent
syn_generic

write_netlist -lec > generic.v
write_do_lec -top picorv32 -golden_design rtl -revised_design generic.v -log_file elab_generic.lec.log > elab_generic.do
syn_map

write_do_lec -top picorv32 -golden_design rtl -revised_design fv_map -log_file generic_fvmap.lec.log > generic_fvmap.do

