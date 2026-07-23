`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Omri's GIT
// Engineer: Omri Nidam
// 
// Create Date: 01/25/2026 04:28:07 PM
// Design Name: O7670_Camera
// Module Name: OV7670_TOP

// Tool Versions: Vivado 2019.1
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module OV7670_TOP(RST_SYNC_25, RST_SYNC_PCLK, PCLK, CLK_25M, FINISH_CONFIG_I, HREF, VSYNC_48M, VSYNC_25M, DIN,  VSYNC_O, HSYNC_O, RED_O, BLUE_O, GREEN_O);
input RST_SYNC_25;
input RST_SYNC_PCLK;
input PCLK;
input CLK_25M;
input FINISH_CONFIG_I;
input HREF;
input VSYNC_48M;
input VSYNC_25M;
input [7:0] DIN;

output wire VSYNC_O;
output wire HSYNC_O;
output wire [3:0] RED_O;
output wire [3:0] BLUE_O;
output wire [3:0] GREEN_O;




/////////////////////////////////
//// OV7670_CAPTURE SIGNALS /////
////////////////////////////////
reg [1:0] HREF_d;
wire HREF_RISING;                    //Output of edge block
wire HREF_FALLING;                   //Output of edge block
reg HREF_RISING_d;                    //Output of edge block
reg HREF_FALLING_d;                   //Output of edge block

wire ACTIVE_FRAME;                   //Input to edge block
reg ACTIVE_FRAME_R_d;
wire WEA_A;
wire [17:0] ADD_A;
wire [15:0] DIN_A;
wire [17:0] DATA_CNT;

reg [1:0] FINISH_CONFIG_SYNC_PCLK;
wire FINISH_CONFIG_SYNC_I_PCLK;

////////////////////////////////
///////// Double_Buffer ////////
////////////////////////////////

reg [1:0] ACITVE_FRAME_d;
wire ACTIVE_FRAME_R;                 //Output of edge block

wire [17:0] ADD_B;
wire [15:0] DOUT_B;

///////////////////////////////
////////   VGA_60Hz   ////////
//////////////////////////////

wire[9:0] VCNT_O;
reg [1:0] FINISH_CONFIG_SYNC_25;
wire FINISH_CONFIG_SYNC_I_25;
/////////////////////////////



////////////////////////////////////////////////////////////////////////
always@(posedge PCLK or negedge RST_SYNC_PCLK) begin
    if(!RST_SYNC_PCLK) begin
        HREF_d    <= 2'b00;
    end else begin
        HREF_d[0] <= HREF;
        HREF_d[1] <= HREF_d[0];
    end
end


always@(posedge PCLK or negedge RST_SYNC_PCLK) begin
    if(!RST_SYNC_PCLK) begin
        HREF_FALLING_d   <= 0;
        HREF_RISING_d    <= 0;
    end else begin
        HREF_FALLING_d   <= (HREF_d[1] & ~HREF_d[0]);
        HREF_RISING_d    <= (~HREF_d[1] & HREF_d[0]);
    end
end


assign HREF_FALLING = HREF_FALLING_d;
assign HREF_RISING  = HREF_RISING_d;

////////////////////////////////////////////////////////////////////////
always@(posedge PCLK or negedge RST_SYNC_PCLK) begin
    if(!RST_SYNC_PCLK) begin
        ACITVE_FRAME_d    <= 2'b00;
    end else begin
        ACITVE_FRAME_d[0] <= ACTIVE_FRAME;
        ACITVE_FRAME_d[1] <= ACITVE_FRAME_d[0];
    end
end

always@(posedge PCLK or negedge RST_SYNC_PCLK) begin
    if(!RST_SYNC_PCLK) begin
        ACTIVE_FRAME_R_d    <= 2'b00;
    end else begin
         ACTIVE_FRAME_R_d   <= (~ACITVE_FRAME_d[1] & ACITVE_FRAME_d[0]);
    end
end

assign ACTIVE_FRAME_R  = ACTIVE_FRAME_R_d;


////////////////////////////////////////////////////////////////////////
always@(posedge CLK_25M or negedge RST_SYNC_25) begin
    if(!RST_SYNC_25) begin
        FINISH_CONFIG_SYNC_25    <= 2'b00;
    end else begin
        FINISH_CONFIG_SYNC_25[0] <= FINISH_CONFIG_I;
        FINISH_CONFIG_SYNC_25[1] <= FINISH_CONFIG_SYNC_25[0];
    end
end

assign FINISH_CONFIG_SYNC_I_25 = FINISH_CONFIG_SYNC_25[1];


always@(posedge PCLK or negedge RST_SYNC_PCLK) begin
    if(!RST_SYNC_PCLK) begin
        FINISH_CONFIG_SYNC_PCLK    <= 2'b00;
    end else begin
        FINISH_CONFIG_SYNC_PCLK[0] <= FINISH_CONFIG_I;
        FINISH_CONFIG_SYNC_PCLK[1] <= FINISH_CONFIG_SYNC_PCLK[0];
    end
end

assign FINISH_CONFIG_SYNC_I_PCLK = FINISH_CONFIG_SYNC_PCLK[1];
/////////////////////////////////////////////////////////////////////////


OV7670_CAPTURE instance_capture(
    .RST(RST_SYNC_PCLK),
    .CLK(PCLK),
    .FINISH_CONFIG(FINISH_CONFIG_SYNC_I_PCLK),
    .DIN(DIN),
    .HREF(HREF),
    .VSYNC(VSYNC_48M),
    .ACTIVE_FRAME(ACTIVE_FRAME),
    .HREF_RISING(HREF_RISING),
    .HREF_FALLING(HREF_FALLING),
    .WEA(WEA_A),
    .ADD(ADD_A),
    .DOUT(DIN_A),
    .DATA_CNT(DATA_CNT)
    );
    
Triple_Buffer instance_buffer(
    .RST_48(RST_SYNC_PCLK),
    .RST_25(RST_SYNC_25),
    .CLK_48(PCLK),
    .CLK_25(CLK_25M),
    .ACTIVE_FRAME_R(ACTIVE_FRAME_R),
    .WEA(WEA_A),
    .ADD_CAP(ADD_A),
    .DATA_CAP_I(DIN_A),
    .ADD_VGA(ADD_B),
    .VCNT_O(VCNT_O),
    .DATA_VGA_O(DOUT_B)
    );
 

VGA_60Hz instance_vga(
    .RST(RST_SYNC_25),
    .CLK(CLK_25M),
    .FINISH_CONFIG(FINISH_CONFIG_SYNC_I_25),
    .VSYNC_I(VSYNC_25M),
    .DATA_IN(DOUT_B),
    .VGA_ADD(ADD_B),
    .VSYNC(VSYNC_O),
    .HSYNC(HSYNC_O),
    .RED(RED_O),
    .GREEN(GREEN_O),
    .BLUE(BLUE_O),
    .VCNT_O(VCNT_O)
    );
    
    

endmodule
