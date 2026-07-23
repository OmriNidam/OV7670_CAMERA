`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2026 10:49:18 PM
// Design Name: 
// Module Name: OV7670_tester
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





module OV7670_tester (RST, XCLK, CLK, PCLK, VSYNC ,HREF, DOUT);
input  wire       RST;
input  wire       XCLK;
output reg        CLK;
output reg        PCLK;
output reg        VSYNC;
output reg        HREF;
output reg [7:0]  DOUT;

wire RST_n;

parameter CLK_PERIOD   = 5; // 100MHz 
parameter PCLK_PERIOD = 10.4167; //48MHz  
parameter LINE_TOTAL    = 784; 
parameter LINE_ACTIVE   = 640; 
parameter FRAME_TOTAL   = 510; 
parameter FRAME_ACTIVE  = 480;
parameter V_SYNC_LINES  = 3;    
parameter V_BACK_PORCH  = 17;   
parameter V_FRONT_PORCH = 10;     

integer row, col;


assign RST_n = !(RST);
initial begin
    CLK  = 0; 
    forever #(CLK_PERIOD) CLK = ~CLK;
end

initial begin
    PCLK = 0;
    forever #(PCLK_PERIOD) PCLK = ~PCLK;
end


initial begin
    VSYNC = 0;
    HREF  = 0;
    DOUT  = 8'h00;
    wait(RST_n == 1'b1);     
    repeat (10) @(posedge XCLK);
    forever begin
            VSYNC = 1;
            repeat (V_SYNC_LINES * LINE_TOTAL * 2) @(posedge XCLK); 
            VSYNC = 0;
            repeat (V_BACK_PORCH * LINE_TOTAL * 2) @(posedge XCLK);
             
            for (row = 0; row < FRAME_ACTIVE; row = row + 1) begin              
                HREF = 1;
                for (col = 0; col < LINE_ACTIVE; col = col + 1) begin
                    DOUT = $random; 
                    @(posedge XCLK);
                    DOUT = $random; 
                    @(posedge XCLK);
                end
                HREF = 0;
                repeat ((LINE_TOTAL - LINE_ACTIVE) * 2) @(posedge XCLK);
            end 
            
            HREF = 0;
            repeat (V_FRONT_PORCH * LINE_TOTAL * 2) @(posedge XCLK);
        end
    end
 
 
    
endmodule