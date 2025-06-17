# Copyright 2022 ETH Zurich and University of Bologna.
# Solderpad Hardware License, Version 0.51, see LICENSE for details.
# SPDX-License-Identifier: SHL-0.51
#
# NOTE: This file has been corrected to use explicit port names in timing constraints
#       to avoid wildcard resolution issues during synthesis.
# NOTE: Fan-related constraints (`fan_sw`, `fan_pwm`) have been removed

#############
# Sys Clock #
#############

# 100 MHz input clock
create_clock -period 10.000 -name sys_clk [get_ports sys_clk]
############
# Switches #
############

# NOTE: Replaced wildcard get_ports with an explicit list of all switch-related ports.
set_input_delay -clock [get_clocks -of_objects [get_pins i_clkwiz/clk_out1]] -min 5.000 [get_ports {{gpio_i[0]} {gpio_i[1]} {gpio_i[2]} {gpio_i[3]} fetch_en_i}]
set_input_delay -clock [get_clocks -of_objects [get_pins i_clkwiz/clk_out1]] -max 17.500 [get_ports {{gpio_i[0]} {gpio_i[1]} {gpio_i[2]} {gpio_i[3]} fetch_en_i}]

set_max_delay -from [get_ports {{gpio_i[0]} {gpio_i[1]} {gpio_i[2]} {gpio_i[3]} fetch_en_i}] 100.000
set_false_path -hold -from [get_ports {{gpio_i[0]} {gpio_i[1]} {gpio_i[2]} {gpio_i[3]} fetch_en_i}]

# LEDs
# NOTE: Replaced wildcard with an explicit list for the gpio_o bus.
set_output_delay -clock [get_clocks -of_objects [get_pins i_clkwiz/clk_out1]] -min 5.000 [get_ports {{gpio_o[0]} {gpio_o[1]} {gpio_o[2]} {gpio_o[3]}}]
set_output_delay -clock [get_clocks -of_objects [get_pins i_clkwiz/clk_out1]] -max 17.500 [get_ports {{gpio_o[0]} {gpio_o[1]} {gpio_o[2]} {gpio_o[3]}}]

###############
# Assign Pins #
###############

## Clock Signal
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports sys_clk]; #IO_L12P_T1_MRCC_35 Sch=clk100mhz

## Buttons
# NOTE: Pin for reset on Nexys A7/Arty A7 is typically C12
set_property -dict {PACKAGE_PIN B8 IOSTANDARD LVCMOS33} [get_ports sys_resetn]; #IO_L6N_T0_VREF_16 Sch=btn[3]

## Switches
# NOTE: IOSTANDARD for switches on Nexys/Arty boards is typically LVCMOS33.
set_property -dict {PACKAGE_PIN A8 IOSTANDARD LVCMOS33} [get_ports {gpio_i[0]}]; #IO_L12N_T1_MRCC_16 Sch=sw[0]
set_property -dict {PACKAGE_PIN C11 IOSTANDARD LVCMOS33} [get_ports {gpio_i[1]}]; #IO_L13P_T2_MRCC_16 Sch=sw[1]
set_property -dict {PACKAGE_PIN C10 IOSTANDARD LVCMOS33} [get_ports {gpio_i[2]}]; #IO_L13N_T2_MRCC_16 Sch=sw[2]
set_property -dict {PACKAGE_PIN A10 IOSTANDARD LVCMOS33} [get_ports {gpio_i[3]}]; #IO_L14P_T2_SRCC_16 Sch=sw[3]
set_property -dict {PACKAGE_PIN C9 IOSTANDARD LVCMOS33} [get_ports fetch_en_i]; #IO_L11P_T1_SRCC_16 Sch=btn[1]

## LEDs
set_property -dict {PACKAGE_PIN H5 IOSTANDARD LVCMOS33} [get_ports {gpio_o[0]}]; #IO_L24N_T3_35 Sch=led[4]
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports {gpio_o[1]}]; #IO_25_35 Sch=led[5]
set_property -dict {PACKAGE_PIN T9 IOSTANDARD LVCMOS33} [get_ports {gpio_o[2]}]; #IO_L24P_T3_A01_D17_14 Sch=led[6]
set_property -dict {PACKAGE_PIN T10 IOSTANDARD LVCMOS33} [get_ports {gpio_o[3]}]; #IO_L24N_T3_A00_D16_14 Sch=led[7]
set_property -dict {PACKAGE_PIN F6 IOSTANDARD LVCMOS33} [get_ports status_o]; #IO_L19N_T3_VREF_35 Sch=led0_g

## UART
set_property -dict { PACKAGE_PIN D10   IOSTANDARD LVCMOS33 } [get_ports { uart_tx_o }]; #IO_L19N_T3_VREF_16 Sch=uart_rxd_out
set_property -dict { PACKAGE_PIN A9   IOSTANDARD LVCMOS33 } [get_ports { uart_rx_i }]; #IO_L14N_T2_SRCC_16 Sch=uart_txd_in


## JTAG for CPU Debug (DPTI)
# This section remains commented out. If you need to debug the CPU via an external JTAG probe,
# you must uncomment these lines and assign valid pins (e.g., from a PMOD header).
set_property -dict { PACKAGE_PIN F4  IOSTANDARD LVCMOS33 } [get_ports { jtag_tck_i }]; #IO_L12N_T1_MRCC_35 Sch=jd[3]
set_property -dict { PACKAGE_PIN D3   IOSTANDARD LVCMOS33 } [get_ports { jtag_tdi_i }]; #IO_L13P_T2_MRCC_35 Sch=jd[2]
set_property -dict { PACKAGE_PIN D4   IOSTANDARD LVCMOS33 } [get_ports { jtag_tdo_o }]; #IO_L13P_T2_MRCC_35 Sch=jd[1]
set_property -dict { PACKAGE_PIN F3   IOSTANDARD LVCMOS33 } [get_ports { jtag_tms_i }]; #IO_L13N_T2_MRCC_35 Sch=jd[4]
set_property -dict { PACKAGE_PIN E2   IOSTANDARD LVCMOS33 } [get_ports { jtag_trst_ni }]; #IO_L13N_T2_MRCC_35 Sch=jd[7]