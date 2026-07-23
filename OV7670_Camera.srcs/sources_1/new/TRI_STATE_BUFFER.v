`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/09/2026 08:57:55 AM
// Design Name: 
// Module Name: TRI_STATE_BUFFER
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


module TRI_STATE_BUFFER(OE, SDA_I, SDA_O, SDA_IO);
input OE;
input SDA_I;
output wire SDA_O;
inout  wire SDA_IO;


assign SDA_IO = (OE == 1) ? SDA_I : 1'bZ;
assign SDA_O = SDA_IO;

endmodule
