`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2026 06:36:01 PM
// Design Name: 
// Module Name: OV7670_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module OV7670_tb();

reg RST;
reg FINISH_CONFIG_I;
wire CLK;
wire XCLK;
wire HREF;
wire VSYNC;
wire [7:0] DIN; 


wire VSYNC_O;
wire HSYNC_O;
wire [3:0] RED_O;
wire [3:0] BLUE_O;
wire [3:0] GREEN_O;

wire pll_locked;
wire CLK_48M;
wire CLK_25M;

initial begin
    RST = 1'b0;      
    #100;             
    RST = 1'b1;      
end

initial begin
    FINISH_CONFIG_I = 1'b0;      
    #200;             
    FINISH_CONFIG_I = 1'b1;      
end

//////If we want run this block independently we need use the PLL component///////
clk_wiz_0 instance_pll(
   .resetn(RST),
    .clk_in1(CLK),
    .clk_out1(CLK_25M),
    .clk_out2(CLK_48M),
   .locked(pll_locked)
   );

OV7670_TOP DUT(
    .RST(RST),
    .CLK_25M(CLK_25M),
    .CLK_48M(CLK_48M),
    .XCLK(XCLK),
    .FINISH_CONFIG_I(FINISH_CONFIG_I),
    .HREF(HREF),
    .VSYNC(VSYNC),
    .DIN(DIN),
    .VSYNC_O(VSYNC_O),
    .HSYNC_O(HSYNC_O),
    .RED_O(RED_O),
    .BLUE_O(BLUE_O),
    .GREEN_O(GREEN_O)
    );
    
OV7670_tester tester(
    .RST(RST),
    .CLK(CLK),
    .XCLK(XCLK),
    .finish_config_o(FINISH_CONFIG_I),
    .VSYNC(VSYNC),
    .HREF(HREF),
    .DOUT(DIN)
    );
   


endmodule
