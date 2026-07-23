`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/04/2026 10:36:18 PM
// Design Name: 
// Module Name: CAMERA_tb
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


module CAMERA_tb();
reg RST_p;
wire CLK;
wire PCLK;
wire HREF;
wire VSYNC;
wire [7:0] DIN; 
wire VSYNC_O;
wire HSYNC_O;
wire [3:0] RED_O;
wire [3:0] BLUE_O;
wire [3:0] GREEN_O;
wire XCLK;
wire SIO_C;
wire SDA_IO;
wire [7:0] SSEG_AN;





initial begin
    RST_p = 1'b0;  
    #10
    RST_p = 1'b1;      
    #100000;             
    RST_p = 1'b0;          
end

CAMERA_TOP DUT(
    .CLK(CLK),
    .PCLK(PCLK),
    .RST(RST_p),
    .HREF(HREF),
    .VSYNC(VSYNC),
    .DIN(DIN),
    .VSYNC_O(VSYNC_O),
    .HSYNC_O(HSYNC_O),
    .RED_O(RED_O),
    .BLUE_O(BLUE_O),
    .GREEN_O(GREEN_O),
    .XCLK(XCLK),
    .SIO_C(SIO_C),
    .SDA_IO(SDA_IO),
    .SSEG_AN(SSEG_AN)
    );


OV7670_tester tester(
    .RST(RST_p),
    .XCLK(XCLK),
    .CLK(CLK),
    .PCLK(PCLK),
    .VSYNC(VSYNC),
    .HREF(HREF),
    .DOUT(DIN)
    );

endmodule
