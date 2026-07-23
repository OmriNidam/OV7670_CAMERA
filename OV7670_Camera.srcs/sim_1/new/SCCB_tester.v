`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2026 09:35:05 PM
// Design Name: 
// Module Name: SCCB_tester
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


module SCCB_tester(RST, CLK);
input  wire       RST;
output reg        CLK;


parameter CLK_PERIOD   = 10.4166; // 48MHz 
initial begin
    CLK  = 0; 
    forever #(CLK_PERIOD) CLK = ~CLK;
end
endmodule
