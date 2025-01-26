
set_db init_lib_search_path /mnt/apps/prebuilt/eda/designkits/GPDK/gsclib045/lan/flow/t1u1/reference_libs/GPDK045/gsclib045_svt_v4.4/gsclib045
set_db script_search_path /home/a/atsarnad/
set_db init_hdl_search_path /home/a/atsarnad/


set_db library {timing/slow_vdd1v0_basicCells.lib}
set_db lef_library {lef/gsclib045_tech.lef lef/gsclib045_macro.lef} 
read_qrc qrc/qx/gpdk045.tch

read_hdl picorv32.v

elaborate picorv32

set_db / .dft_scan_style muxed_scan
set_db / .dft_prefix DFT_
set_db / .dft_identify_top_level_test_clocks true
set_db / .dft_identify_test_signals true
set_db / .dft_identify_internal_test_clocks false
set_db / .use_scan_seqs_for_non_dft false
set_db "design:picorv32" .dft_scan_map_mode tdrc_pass
set_db "design:picorv32" .dft_connect_shift_enable_during_mapping tie_off
set_db "design:picorv32" .dft_connect_scan_data_pins_during_mapping loopback
set_db "design:picorv32" .dft_scan_output_preference auto
set_db "design:picorv32" .dft_lockup_element_type preferred_level_sensitive
set_db "design:picorv32" .dft_mix_clock_edges_in_scan_chains true
define_test_clock -name scanclk -period 20000 clk
define_shift_enable -name se -active high -create_port se
define_test_mode -name test_mode -active high -create_port test_mode
define_scan_chain -name top_chain -sdi scan_in -sdo scan_out -shift_enable se -create_ports

check_dft_rules
report_scan_registers
report_scan_setup

check_dft_rules -advanced

connect_scan_chains -auto_create_chains
report_scan_chains

report_scan_setup
write_scandef -scanDEF
write_dft_abstract_model
write_hdl -abstract
write_script -analyze_all_scan_chains


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

