`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/28/2026 12:50:56 PM
// Design Name: 
// Module Name: Double_Buffer
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


module Double_Buffer(RST, CLK_A, CLK_B, ACTIVE_FRAME_R, DATA_CNT_I, WEA, ADD_CAP, DATA_CAP_I, ADD_VGA, DATA_VGA_O);
input RST;
input CLK_A;
input CLK_B;
input ACTIVE_FRAME_R;                   // Rising edge
input [15:0] DATA_CNT_I;
input [0:0]  WEA;
input [17:0] ADD_CAP;
input [15:0] DATA_CAP_I;
input [17:0] ADD_VGA;
output reg [15:0] DATA_VGA_O;

//parameter FRAME_SIZE = 18'b010010110000000000;          //240 x 320 = 76,800
parameter FRAME_SIZE = 18'd76800;

//reg [17:0] offset_db;
reg        toggle_db;
wire [17:0] offset_db;
wire [17:0] ADD_PORT_A;
wire [17:0] ADD_PORT_B;
    
//DB_RAM instance_ram(
//    .clka(CLK_A),
//    .wea(WEA),
//    .addra(ADD_PORT_A),
//    .dina(DATA_CAP_I),
//    .clkb(CLK_B),
//    .addrb(ADD_PORT_B),
//    .doutb(DATA_VGA_O)
//    );
    
    
always @(posedge CLK_A or negedge RST) begin
    if (!RST)begin
        toggle_db <= 1'b0;
        
    end else begin
        if (ACTIVE_FRAME_R == 1) begin                  // This condition make sense?????
            toggle_db <= !(toggle_db);
        end       
    end
end

assign offset_db = (toggle_db) ? FRAME_SIZE : 0;
assign ADD_PORT_A = offset_db + ADD_CAP;
assign ADD_PORT_B = (FRAME_SIZE - offset_db) + ADD_VGA;



//always @(posedge CLK or negedge RST) begin
//    if (!RST)begin
//        offset_db <= 18'b000000000000000000;
       
//     end else begin
//        if (toggle_db == 0) begin
//            offset_db <= 18'b000000000000000000;
        
//        end else begin
//            offset_db <= FRAME_SIZE;                //240 x 320 = 76,800
//        end
//    end
//end

    
    
endmodule


