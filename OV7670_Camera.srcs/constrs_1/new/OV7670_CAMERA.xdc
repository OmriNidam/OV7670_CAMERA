## This file is a general .xdc for the Nexys4 DDR Rev. C
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports CLK]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports CLK]
create_clock -period 20.833 -name OV7670_PCLK [get_ports PCLK]
create_clock -period 20.833 -name OV7670_XCLK [get_ports XCLK]

##Buttons
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS33} [get_ports RST]

##Pmod Header JA
set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS33} [get_ports SDA_IO]
set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS33} [get_ports HREF]
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS33} [get_ports XCLK]
set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33} [get_ports {DIN[6]}]
set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVCMOS33} [get_ports {DIN[4]}]
set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVCMOS33} [get_ports {DIN[2]}]
set_property -dict {PACKAGE_PIN F18 IOSTANDARD LVCMOS33} [get_ports SYS_RST]
set_property -dict {PACKAGE_PIN G18 IOSTANDARD LVCMOS33} [get_ports {DIN[0]}]

##Pmod Header JB
set_property -dict {PACKAGE_PIN D14 IOSTANDARD LVCMOS33} [get_ports SIO_C]
set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVCMOS33} [get_ports VSYNC]
set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVCMOS33} [get_ports {DIN[7]}]
set_property -dict {PACKAGE_PIN H14 IOSTANDARD LVCMOS33} [get_ports {DIN[5]}]
set_property -dict {PACKAGE_PIN E16 IOSTANDARD LVCMOS33} [get_ports {DIN[3]}]
set_property -dict {PACKAGE_PIN F13 IOSTANDARD LVCMOS33} [get_ports {DIN[1]}]
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports PCLK]

##VGA Connector
set_property -dict {PACKAGE_PIN A3 IOSTANDARD LVCMOS33} [get_ports {RED_O[0]}]
set_property -dict {PACKAGE_PIN B4 IOSTANDARD LVCMOS33} [get_ports {RED_O[1]}]
set_property -dict {PACKAGE_PIN C5 IOSTANDARD LVCMOS33} [get_ports {RED_O[2]}]
set_property -dict {PACKAGE_PIN A4 IOSTANDARD LVCMOS33} [get_ports {RED_O[3]}]

set_property -dict {PACKAGE_PIN C6 IOSTANDARD LVCMOS33} [get_ports {GREEN_O[0]}]
set_property -dict {PACKAGE_PIN A5 IOSTANDARD LVCMOS33} [get_ports {GREEN_O[1]}]
set_property -dict {PACKAGE_PIN B6 IOSTANDARD LVCMOS33} [get_ports {GREEN_O[2]}]
set_property -dict {PACKAGE_PIN A6 IOSTANDARD LVCMOS33} [get_ports {GREEN_O[3]}]

set_property -dict {PACKAGE_PIN B7 IOSTANDARD LVCMOS33} [get_ports {BLUE_O[0]}]
set_property -dict {PACKAGE_PIN C7 IOSTANDARD LVCMOS33} [get_ports {BLUE_O[1]}]
set_property -dict {PACKAGE_PIN D7 IOSTANDARD LVCMOS33} [get_ports {BLUE_O[2]}]
set_property -dict {PACKAGE_PIN D8 IOSTANDARD LVCMOS33} [get_ports {BLUE_O[3]}]

set_property -dict {PACKAGE_PIN B11 IOSTANDARD LVCMOS33} [get_ports HSYNC_O]
set_property -dict {PACKAGE_PIN B12 IOSTANDARD LVCMOS33} [get_ports VSYNC_O]


###################################################################################################################
set_false_path -from [get_ports RST] -to [get_pins {SYNC_RST_reg[*]/CLR}]
set_false_path -from [get_ports VSYNC] -to [get_pins {VSYNC_SYNC_FF_2_reg[0]/D}]

##set_false_path -from [get_pins {instance_OV7670/instance_buffer/READY_PTR_GRAY_d_reg[*]/C}] -to [get_pins {instance_OV7670/instance_buffer/READY_PTR_GRAY_STAGE1_reg[*]/D}]
set_max_delay  -from [get_cells {instance_OV7670/instance_buffer/READY_PTR_GRAY_d_reg[*]}] -to [get_cells {instance_OV7670/instance_buffer/READY_PTR_GRAY_STAGE1_reg[*]}] 4.0 -datapath_only
##set_false_path -from [get_pins {instance_OV7670/instance_buffer/READ_PTR_GRAY_d_reg[*]/C}] -to [get_pins {instance_OV7670/instance_buffer/READ_PTR_GRAY_STAGE1_reg[*]/D}]
set_max_delay  -from [get_pins {instance_OV7670/instance_buffer/READ_PTR_GRAY_d_reg[*]/C}] -to [get_pins {instance_OV7670/instance_buffer/READ_PTR_GRAY_STAGE1_reg[*]/D}] 4.0 -datapath_only

set_false_path -from [get_pins instance_SCCB/instance_SCCB_CTRL/FINISH_CONFIG_O_reg/C] -to [get_pins {instance_OV7670/FINISH_CONFIG_SYNC_PCLK_reg[0]/D}]
set_false_path -from [get_pins instance_SCCB/instance_SCCB_CTRL/FINISH_CONFIG_O_reg/C] -to [get_pins {instance_OV7670/FINISH_CONFIG_SYNC_25_reg[0]/D}]

set_false_path -from [get_pins RST_DB_reg/C] -to [get_pins {SYNC_FF_48M_reg[*]/CLR}]
set_false_path -from [get_pins RST_DB_reg/C] -to [get_pins {SYNC_FF_PCLK_reg[*]/CLR}]


##################################################################################################################
set_input_delay -clock [get_clocks OV7670_PCLK] -min 3 [get_ports DIN[*]]
set_input_delay -clock [get_clocks OV7670_PCLK] -max 5 [get_ports DIN[*]]
set_input_delay -clock [get_clocks OV7670_PCLK] -min 3 [get_ports HREF]
set_input_delay -clock [get_clocks OV7670_PCLK] -max 5 [get_ports HREF]
set_input_delay -clock [get_clocks OV7670_PCLK] -min 3 [get_ports VSYNC]
set_input_delay -clock [get_clocks OV7670_PCLK] -max 5 [get_ports VSYNC]
set_input_delay -clock [get_clocks sys_clk_pin] -min 0 [get_ports RST]
set_input_delay -clock [get_clocks sys_clk_pin] -max 0 [get_ports RST]

set_output_delay -clock [get_clocks clk_out2_clk_wiz_0] -min 0   [get_ports SDA_IO]
set_output_delay -clock [get_clocks clk_out2_clk_wiz_0] -max 0   [get_ports SDA_IO]
set_output_delay -clock [get_clocks clk_out2_clk_wiz_0] -min 0   [get_ports SIO_C]
set_output_delay -clock [get_clocks clk_out2_clk_wiz_0] -max 0   [get_ports SIO_C]
set_output_delay -clock [get_clocks clk_out1_clk_wiz_0] -min 0.5 [get_ports BLUE_O[*]]
set_output_delay -clock [get_clocks clk_out1_clk_wiz_0] -max 4   [get_ports BLUE_O[*]]
set_output_delay -clock [get_clocks clk_out1_clk_wiz_0] -min 0.5 [get_ports GREEN_O[*]]
set_output_delay -clock [get_clocks clk_out1_clk_wiz_0] -max 4   [get_ports GREEN_O[*]]
set_output_delay -clock [get_clocks clk_out1_clk_wiz_0] -min 0.5 [get_ports RED_O[*]]
set_output_delay -clock [get_clocks clk_out1_clk_wiz_0] -max 4   [get_ports RED_O[*]]
set_output_delay -clock [get_clocks clk_out1_clk_wiz_0] -min 0.5 [get_ports HSYNC_O]
set_output_delay -clock [get_clocks clk_out1_clk_wiz_0] -max 4   [get_ports HSYNC_O]
set_output_delay -clock [get_clocks clk_out1_clk_wiz_0] -min 0.5 [get_ports VSYNC_O]
set_output_delay -clock [get_clocks clk_out1_clk_wiz_0] -max 4   [get_ports VSYNC_O]
##################################################################################################################
connect_debug_port dbg_hub/clk [get_nets u_ila_3_clkfbout_buf_clk_wiz_0]
connect_debug_port dbg_hub/clk [get_nets u_ila_2_clkfbout_buf_clk_wiz_0]


create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 2048 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list instance_pll/inst/clk_out3]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 4 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {RED_O_OBUF[0]} {RED_O_OBUF[1]} {RED_O_OBUF[2]} {RED_O_OBUF[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 8 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {DIN_IBUF[0]} {DIN_IBUF[1]} {DIN_IBUF[2]} {DIN_IBUF[3]} {DIN_IBUF[4]} {DIN_IBUF[5]} {DIN_IBUF[6]} {DIN_IBUF[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 4 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {BLUE_O_OBUF[0]} {BLUE_O_OBUF[1]} {BLUE_O_OBUF[2]} {BLUE_O_OBUF[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 4 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {GREEN_O_OBUF[0]} {GREEN_O_OBUF[1]} {GREEN_O_OBUF[2]} {GREEN_O_OBUF[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list CLK_25M]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list CLK_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list instance_pll/clk_out1]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list instance_SCCB/instance_BIT_SM/clk_out2]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list FINISH_CONFIG]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list HREF_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list HSYNC_O_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list instance_pll/locked]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list PCLK_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list RST_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list SDA_IO_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list SIO_C_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 1 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list SYS_RST_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 1 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list VSYNC_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 1 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list VSYNC_O_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list XCLK_OBUF]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_0_clk_out3]
