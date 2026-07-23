`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/04/2026 10:06:17 PM
// Design Name: 
// Module Name: CAMERA_TOP
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


module CAMERA_TOP(CLK, PCLK, RST, HREF, VSYNC, DIN, XCLK, SIO_C, SDA_IO, VSYNC_O, HSYNC_O, RED_O, BLUE_O, GREEN_O, SYS_RST);
input CLK;
input PCLK;
input RST;
input HREF;
input VSYNC;
input[7:0] DIN;

output wire XCLK;
output wire SIO_C; 
inout wire SDA_IO; 
output wire VSYNC_O;
output wire HSYNC_O;
output wire [3:0] RED_O;
output wire [3:0] BLUE_O;
output wire [3:0] GREEN_O;
output wire SYS_RST;

wire SDA_O;
wire SDA_I;

wire FINISH_CONFIG;

wire CLK_25M;
wire CLK_48M;
wire pll_locked;

wire OE;

reg [1:0] SYNC_RST;
reg RST_DB;
reg [15:0] COUNTER_DB;

//reg [1:0] HREF_SYNC_FF;
//wire HREF_SYNC_48M;
//reg [1:0] VSYNC_SYNC_FF;
//wire VSYNC_SYNC_48M;
reg [1:0] VSYNC_SYNC_FF_2;
wire VSYNC_SYNC_25M;

reg [1:0] SYNC_FF_25M;
wire RST_SYNC_25M;
reg [1:0] SYNC_FF_48M;
wire RST_SYNC_48M;
reg [1:0] SYNC_FF_PCLK;
wire RST_SYNC_PCLK;

wire CLK_DEBUG;

/////////////////////////////////////////////////////////////////////
assign SYS_RST = !(RST);

// Sync reset to SYS_RST (100MHz)
always @(posedge CLK or negedge SYS_RST) begin
    if (!SYS_RST) begin
        SYNC_RST <= 2'b00;
    end else begin
        SYNC_RST[0]  <= 1'b1;
        SYNC_RST[1]  <= SYNC_RST[0];
    end
end


//Debouncing reset SYS_RST input.
always @(posedge CLK) begin
    if (SYNC_RST[1] == 1'b0) begin
        RST_DB <= 1'b0;
        COUNTER_DB <=  16'h0000;
    end else begin
        if (SYNC_RST[1] == 1'b1) begin
            if (COUNTER_DB == 16'd5000) begin
                RST_DB <= 1'b1;
                COUNTER_DB <= COUNTER_DB;
            end else begin
                COUNTER_DB <= COUNTER_DB + 16'h0001;
                RST_DB <= 1'b0;     
            end
        end else begin
            RST_DB <= 1'b0;
            COUNTER_DB <=  16'h0000;    
        end
    end
end

// Sync reset to 25MHz
always @(posedge CLK_25M or negedge RST_DB) begin
    if (!RST_DB) begin
        SYNC_FF_25M <= 2'b00;
    end else begin
        SYNC_FF_25M[0]  <= 1'b1;
        SYNC_FF_25M[1]  <= SYNC_FF_25M[0];
    end
end
assign RST_SYNC_25M = SYNC_FF_25M[1];

// Sync reset to 48MHz
always @(posedge CLK_48M or negedge RST_DB) begin
    if (!RST_DB) begin
        SYNC_FF_48M <= 2'b00;
    end else begin
        SYNC_FF_48M[0]  <= 1'b1;
        SYNC_FF_48M[1]  <= SYNC_FF_48M[0];
    end
end
assign RST_SYNC_48M = SYNC_FF_48M[1];

// Sync reset to PCLK
always @(posedge PCLK or negedge RST_DB) begin
    if (!RST_DB) begin
        SYNC_FF_PCLK <= 2'b00;
    end else begin
        SYNC_FF_PCLK[0]  <= 1'b1;
        SYNC_FF_PCLK[1]  <= SYNC_FF_PCLK[0];
    end
end
assign RST_SYNC_PCLK = SYNC_FF_PCLK[1];


////////////////////////////////////////////////////////////////////////////////////

// 2-Stage synchronizer
always @(posedge CLK_25M or negedge RST_SYNC_25M) begin
    if (!RST_SYNC_25M) begin
        VSYNC_SYNC_FF_2 <= 2'b11;
    end else begin
        VSYNC_SYNC_FF_2[0] <= VSYNC;
        VSYNC_SYNC_FF_2[1] <= VSYNC_SYNC_FF_2[0];
    end
end
assign VSYNC_SYNC_25M = VSYNC_SYNC_FF_2[1];

assign XCLK = CLK_48M;
        
clk_wiz_0 instance_pll(
    .resetn(RST_DB),
    .clk_in1(CLK),
    .clk_out1(CLK_25M),
    .clk_out2(CLK_48M),
    .clk_out3(CLK_DEBUG),
    .locked(pll_locked)
    );
    
OV7670_TOP instance_OV7670(
    .RST_SYNC_25(RST_SYNC_25M),
    .RST_SYNC_PCLK(RST_SYNC_PCLK),
    .CLK_25M(CLK_25M),
    .PCLK(PCLK),
    .FINISH_CONFIG_I(FINISH_CONFIG),
    .HREF(HREF),
    .VSYNC_48M(VSYNC),
    .VSYNC_25M(VSYNC_SYNC_25M),    
    .DIN(DIN),
    .HSYNC_O(HSYNC_O),
    .VSYNC_O(VSYNC_O),
    .RED_O(RED_O),
    .BLUE_O(BLUE_O),
    .GREEN_O(GREEN_O)
    );

SCCB_TOP instance_SCCB(
    .RST(RST_SYNC_48M),
    .CLK_48M(CLK_48M),
    .SIO_D_O(SDA_O),
    .FINISH_CONFIG(FINISH_CONFIG),
    .OE(OE),
    .SIO_D_I(SDA_I),
    .SIO_C(SIO_C)
    );
    
TRI_STATE_BUFFER instace_buffer(
    .OE(OE),
    .SDA_I(SDA_I),
    .SDA_O(SDA_O),
    .SDA_IO(SDA_IO)
    );
       
endmodule
