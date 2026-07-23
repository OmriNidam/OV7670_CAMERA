`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2026 09:34:28 PM
// Design Name: 
// Module Name: SCCB_tb
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


module SCCB_tb();
reg RST;
wire CLK;
wire FINISH_CONFIG;
wire OE;
wire SIO_D_I;
wire SIO_C;
wire SDA_O;
wire SDA_IO;





initial begin
    RST = 1'b0;      
    #100;             
    RST = 1'b1;      
end

SCCB_TOP DUT1(
    .RST(RST),
    .CLK_48M(CLK),
    .SIO_D_O(1'bz),
    .FINISH_CONFIG(FINISH_CONFIG),
    .OE(OE),
    .SIO_D_I(SIO_D_I),
    .SIO_C(SIO_C)  
    );

TRI_STATE_BUFFER DUT2(
    .OE(OE),
    .SDA_I(SIO_D_I),
    .SDA_O(SDA_O),
    .SDA_IO(SDA_IO)
    );
    

SCCB_tester TESTER(
    .RST(RST),
    .CLK(CLK)
    );    
endmodule        