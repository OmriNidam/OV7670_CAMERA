`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/13/2026 04:12:22 PM
// Design Name: 
// Module Name: DB_RAM
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


module DB_RAM(
    input WEA,
    input [15:0] WRITE_ADD,
    input [15:0] WRITE_DATA,
    output reg REA,
    output reg [15:0] READ_ADD,
    output reg [15:0] READ_DATA
    );
endmodule
