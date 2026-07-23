// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Sun Apr 26 18:52:13 2026
// Host        : DESKTOP-2CSMKDQ running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               d:/Git_Project/OV7670_CAMERA/Vivado/OV7670_Camera.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(clk_in2, clk_in_sel, clk_out1, reset, locked, 
  clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_in2,clk_in_sel,clk_out1,reset,locked,clk_in1" */;
  input clk_in2;
  input clk_in_sel;
  output clk_out1;
  input reset;
  output locked;
  input clk_in1;
endmodule
