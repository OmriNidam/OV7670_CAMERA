// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Sat Apr 11 14:06:43 2026
// Host        : DESKTOP-2CSMKDQ running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               d:/Git_Project/OV7670_CAMERA/Vivado/OV7670_Camera.srcs/sources_1/ip/DB_RAM/DB_RAM_stub.v
// Design      : DB_RAM
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_3,Vivado 2019.1" *)
module DB_RAM(clka, wea, addra, dina, clkb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[17:0],dina[15:0],clkb,addrb[17:0],doutb[15:0]" */;
  input clka;
  input [0:0]wea;
  input [17:0]addra;
  input [15:0]dina;
  input clkb;
  input [17:0]addrb;
  output [15:0]doutb;
endmodule
