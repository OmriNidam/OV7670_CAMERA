`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2026 01:34:37 PM
// Design Name: 
// Module Name: Triple_Buffer
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


module Triple_Buffer(RST_48, RST_25, CLK_48, CLK_25, ACTIVE_FRAME_R, WEA, ADD_CAP, DATA_CAP_I, ADD_VGA, VCNT_O, DATA_VGA_O);
input RST_48;
input RST_25;
input CLK_48;
input CLK_25;
input ACTIVE_FRAME_R;                   // Rising edge
input [0:0]  WEA;
input [17:0] ADD_CAP;
input [15:0] DATA_CAP_I;
input [17:0] ADD_VGA;
input [9:0] VCNT_O;
output wire [15:0] DATA_VGA_O;

localparam V_total = 10'd525, FRAME_SIZE = 18'd76800;
wire [17:0] ADD_PORT_A;
wire [17:0] ADD_PORT_B;
reg  [1:0]  WRITE_PTR;
reg  [1:0]  READ_PTR;
reg  [1:0]  READY_PTR;

wire [1:0]  READY_PTR_GRAY;
reg  [1:0]  READY_PTR_GRAY_STAGE1;
reg  [1:0]  READY_PTR_GRAY_STAGE2;
wire [1:0]  READY_PTR_BINARY;
reg  [1:0]  READY_PTR_GRAY_d;

wire [1:0]  READ_PTR_GRAY;
reg  [1:0]  READ_PTR_GRAY_STAGE1;
reg  [1:0]  READ_PTR_GRAY_STAGE2;
wire [1:0]  READ_PTR_BINARY;
reg  [1:0]  READ_PTR_GRAY_d;

DB_RAM instance_ram(
    .clka(CLK_48),
    .wea(WEA),
    .addra(ADD_PORT_A),
    .dina(DATA_CAP_I),
    .clkb(CLK_25),
    .addrb(ADD_PORT_B),
    .doutb(DATA_VGA_O)
    );



always @(posedge CLK_48 or negedge RST_48) begin
    if (!RST_48)begin
        WRITE_PTR      <= 2'd0;
        READY_PTR      <= 2'd2;
        
    end else begin
        if (ACTIVE_FRAME_R == 1) begin                  
            READY_PTR <= WRITE_PTR;
            case (WRITE_PTR)
                2'd0: WRITE_PTR <= (READ_PTR_BINARY == 2'd1) ? 2'd2 : 2'd1;
                2'd1: WRITE_PTR <= (READ_PTR_BINARY == 2'd0) ? 2'd2 : 2'd0;
                2'd2: WRITE_PTR <= (READ_PTR_BINARY == 2'd0) ? 2'd1 : 2'd0;
                default: WRITE_PTR <= 2'd0;
            endcase
        end       
    end
end


always @(posedge CLK_25 or negedge RST_25) begin
    if (!RST_25)begin
        READ_PTR <= 2'd1;
        
    end else begin
        if (VCNT_O == (V_total - 1)) begin 
            READ_PTR <= READY_PTR_BINARY;                          
        end       
    end
end

/////////////////////////////////////////////
////////////SYNC READY_PTR to 25M////////////
////////////////////////////////////////////
//binary to gray
assign READY_PTR_GRAY[0] = READY_PTR[1] ^ READY_PTR[0];
assign READY_PTR_GRAY[1] = READY_PTR[1];

always @(posedge CLK_48 or negedge RST_48) begin
    if (!RST_48)begin
        READY_PTR_GRAY_d  <= 2'd3;   
    end else begin
        READY_PTR_GRAY_d  <= READY_PTR_GRAY;
    end
end

//2 stage sync
always @(posedge CLK_25 or negedge RST_25) begin
    if (!RST_25)begin
        READY_PTR_GRAY_STAGE1  <= 2'd3;
        READY_PTR_GRAY_STAGE2  <= 2'd3;        
    end else begin
        READY_PTR_GRAY_STAGE1  <= READY_PTR_GRAY_d;
        READY_PTR_GRAY_STAGE2  <= READY_PTR_GRAY_STAGE1;
    end
end

//gray to binary
assign READY_PTR_BINARY[0] = READY_PTR_GRAY_STAGE2[1] ^ READY_PTR_GRAY_STAGE2[0];
assign READY_PTR_BINARY[1] = READY_PTR_GRAY_STAGE2[1];
///////////////////////////////////////////

/////////////////////////////////////////////
////////////SYNC READ_PTR to 48M////////////
////////////////////////////////////////////
//binary to gray
assign READ_PTR_GRAY[0] = READ_PTR[1] ^ READ_PTR[0];
assign READ_PTR_GRAY[1] = READ_PTR[1];

always @(posedge CLK_25 or negedge RST_25) begin
    if (!RST_25)begin
        READ_PTR_GRAY_d  <= 2'd3;   
    end else begin
        READ_PTR_GRAY_d  <= READ_PTR_GRAY;
    end
end

//2 stage sync
always @(posedge CLK_48 or negedge RST_48) begin
    if (!RST_48)begin
        READ_PTR_GRAY_STAGE1  <= 2'd1;
        READ_PTR_GRAY_STAGE2  <= 2'd1;        
    end else begin
        READ_PTR_GRAY_STAGE1  <= READ_PTR_GRAY_d;
        READ_PTR_GRAY_STAGE2  <= READ_PTR_GRAY_STAGE1;
    end
end

//gray to binary
assign READ_PTR_BINARY[0] = READ_PTR_GRAY_STAGE2[1] ^ READ_PTR_GRAY_STAGE2[0];
assign READ_PTR_BINARY[1] = READ_PTR_GRAY_STAGE2[1];
///////////////////////////////////////////

assign ADD_PORT_A = (FRAME_SIZE * WRITE_PTR)  + ADD_CAP;
assign ADD_PORT_B = (FRAME_SIZE * READ_PTR)   + ADD_VGA;



endmodule
