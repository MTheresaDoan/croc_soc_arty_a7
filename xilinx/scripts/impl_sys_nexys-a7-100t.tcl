# Copyright 2018 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51
#
# Florian Zaruba <zarubaf@iis.ee.ethz.ch>
# Nils Wistoff <nwistoff@iis.ee.ethz.ch>
# Cyril Koenig <cykoenig@iis.ee.ethz.ch>
# Paul Scheffler <cykoenig@iis.ee.ethz.ch>

# Initialize implementation
set xilinx_root [file dirname [file dirname [file normalize [info script]]]]
source ${xilinx_root}/scripts/common-nexys-a7-100t.tcl
init_impl $xilinx_root $argc $argv

# Addtional args provide IPs
read_ip [exec realpath {*}[lrange $argv 2 end]]

# Load constraints
# import_files -fileset constrs_1 -norecurse ${xilinx_root}/src/${proj}.xdc
import_files -fileset constrs_1 -norecurse ${xilinx_root}/src/${board}.xdc

# Load RTL sources
source ${xilinx_root}/scripts/add_sources.${board}.tcl
# ---------> BẮT ĐẦU ĐOẠN CODE THÊM VÀO <---------
puts "INFO: impl_sys_nexys-a7-100t.tcl Sourced Bender's add_sources.tcl. Original verilog_define: '[get_property verilog_define [current_fileset]]'"

# Lấy danh sách define hiện tại (có thể do Bender thiết lập)
set current_defines [get_property verilog_define [current_fileset]]


# Ghi chú: 'llist::islist' là một cách kiểm tra mạnh mẽ hơn. 
# Nếu không có, bạn có thể dùng cách kiểm tra đơn giản hơn, nhưng cẩn thận với trường hợp chỉ có 1 define.
# Cách kiểm tra đơn giản hơn (có thể không hoàn hảo cho mọi trường hợp Tcl):
if {![catch {llength $current_defines} len] || $len == 0} {
    # Nếu current_defines không phải là list hợp lệ hoặc là list rỗng
    if {[string is list $current_defines]} {
        # Nó là list (có thể rỗng)
     } else {
        # Nó là string, cần chuyển thành list
        if {[string length $current_defines] > 0} {
           set current_defines [list $current_defines]
        } else {
           set current_defines [list]
        }
     }
 }


# Các define bạn muốn đảm bảo có mặt (bao gồm cả những cái Bender có thể đã thêm)
# Bạn nên liệt kê tất cả các define bạn muốn có ở đây
set desired_defines [list \
    TARGET_FPGA \
    TARGET_NEXYS-A7-100T \
    TARGET_RTL \
    TARGET_SYNTHESIS \
    TARGET_VIVADO \
    TARGET_XILINX \
    COMMON_CELLS_ASSERTS_OFF \
    SYNTHESIS \
]

# Thêm các define trong desired_defines vào current_defines nếu chúng chưa tồn tại
foreach def $desired_defines {
    if {[lsearch -exact $current_defines $def] == -1} {
        lappend current_defines $def
    }
}

# Đặt lại thuộc tính verilog_define với danh sách đã được cập nhật đầy đủ
set_property verilog_define $current_defines [current_fileset]
# Nếu bạn cũng dùng simset và muốn áp dụng các define này (có thể cần điều chỉnh danh sách):
# set_property verilog_define $current_defines [current_fileset -simset]

puts "INFO: impl_sys_nexys-a7-100t.tcl Updated verilog_define for synthesis to: '[get_property verilog_define [current_fileset]]'"
# ---------> KẾT THÚC ĐOẠN CODE THÊM VÀO <---------
# Set top module
set_property top ${proj}_xilinx [current_fileset]
update_compile_order -fileset sources_1

# Set synthesis properties
# TODO: investigate resource-affordable retiming
set_property XPM_LIBRARIES XPM_MEMORY [current_project]
set_property strategy Flow_PerfOptimized_high [get_runs synth_1]

# Elaborate and open design to explore all clocks
synth_design -rtl -name rtl_1
report_clocks -file ${project_root}/clocks.rpt

# Synthesis
launch_runs -jobs $num_jobs synth_1
wait_on_run synth_1
open_run synth_1

# Generate synthesis reports
gen_reports ${project_root}/reports.synth

# Instantiate debug core and ILAs
# TODO: debug this
insert_ilas {soc_clk}

# Set implementation properties
set_property strategy Performance_ExtraTimingOpt [get_runs impl_1]

# Implementation
launch_runs -jobs $num_jobs impl_1 -to_step write_bitstream
wait_on_run impl_1
open_run impl_1

# Generate implementation reports
gen_reports ${project_root}/reports.impl

# Check timing constraints
set trep [report_timing_summary -no_header -no_detailed_paths -return_string]
if { ![string match -nocase {*timing constraints are met*} $trep] } {
    puts "Error: Timing constraints not met for ${proj} on ${board}."
    return -code error
}

# Copy out final bitstream
file mkdir ${xilinx_root}/out
file copy -force ${project_root}/${proj}.runs/impl_1/croc_xilinx.bit \
    ${xilinx_root}/out/${proj}.${board}.bit
file copy -force ${project_root}/${proj}.runs/impl_1/croc_xilinx.ltx \
    ${xilinx_root}/out/${proj}.${board}.ltx
