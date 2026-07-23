`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Omri's GIT
// Engineer: Omri Nidam
//
// Create Date: 01/25/2026 04:28:07 PM
// Design Name: O7670_Camera
// Module Name: OV7670_CAPTURE
//
// Tool Versions: Vivado 2019.1
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module OV7670_CAPTURE (RST, CLK,FINISH_CONFIG, DIN, HREF,HREF_RISING, HREF_FALLING, VSYNC, ACTIVE_FRAME, WEA, ADD, DOUT, DATA_CNT);
input  RST;
input CLK;
input FINISH_CONFIG;
input [7:0] DIN;
input HREF;
input HREF_RISING;
input HREF_FALLING;
input VSYNC;
output reg ACTIVE_FRAME;
output reg WEA;
output reg [17:0] ADD;
output reg [15:0] DOUT;
output reg [17:0] DATA_CNT;

localparam H_QVGA_low = 10'd160, H_QVGA_high = 10'd480;
localparam V_QVGA_low = 10'd120, V_QVGA_high = 10'd360;
localparam IDLE = 3'b000, NEW_FRAME = 3'b001, NEW_LINE = 3'b010,INCR_LINE = 3'b011, LSB_BYTE = 3'b100, MSB_BYTE = 3'b101;
reg [2:0] NEXT_STATE, CURRENT_STATE;
reg [15:0] DATA_2BYTE;
reg [15:0] PIXEL_CNT;
reg [15:0] LINE_CNT;


always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        CURRENT_STATE <= IDLE;
        ACTIVE_FRAME  <= 1'b0;
        WEA           <= 1'b0;
        PIXEL_CNT     <= 16'h0000;
        LINE_CNT      <= 16'h0000;
        ADD           <= 18'b000000000000000000;
        DATA_2BYTE    <= 16'h0000;
        DOUT          <= 16'h0000;
        DATA_CNT      <= 18'b000000000000000000;
        
    end else begin
        CURRENT_STATE <= NEXT_STATE;
        
        case(CURRENT_STATE)
            IDLE: begin
                ACTIVE_FRAME      <= 1'b0;
                WEA               <= 1'b0;
                PIXEL_CNT         <= 16'h0000;
                LINE_CNT          <= 16'h0000;
                ADD               <= 18'b000000000000000000;
                DATA_2BYTE        <= 16'h0000;
                DOUT              <= 16'h0000;
                DATA_CNT          <= 18'b000000000000000000;
            end
            
            NEW_FRAME: begin
                ACTIVE_FRAME      <= 1'b0;
                WEA               <= 1'b0;
                PIXEL_CNT         <= 16'h0000;
                LINE_CNT          <= 16'h0000;
                ADD               <= 18'b000000000000000000;
                DATA_2BYTE        <= 16'h0000;
                DOUT              <= 16'h0000;
                DATA_CNT          <= 18'b000000000000000000;
            end
            
            NEW_LINE: begin
                ACTIVE_FRAME      <= 1'b1;
                WEA               <= 1'b0;
                PIXEL_CNT         <= 16'h0000;
                LINE_CNT          <= LINE_CNT;
                ADD               <= ADD;
                DATA_2BYTE        <= 16'h0000;
                DOUT              <= 16'h0000;
                DATA_CNT          <= DATA_CNT;
            end
            
            INCR_LINE: begin
                ACTIVE_FRAME      <= 1'b1;
                WEA               <= 1'b0;
                PIXEL_CNT         <= 16'h0000;
                LINE_CNT          <= LINE_CNT + 1;
                ADD               <= ADD;
                DATA_2BYTE        <= 16'h0000;
                DOUT              <= 16'h0000;
                DATA_CNT          <= DATA_CNT;
            end
            
            
            LSB_BYTE: begin
                ACTIVE_FRAME      <= ACTIVE_FRAME;
                WEA               <= 1'b0;
                PIXEL_CNT         <= PIXEL_CNT;
                LINE_CNT          <= LINE_CNT;
                ADD               <= ADD;
                DATA_2BYTE        <= {DIN, DATA_2BYTE[15:8]};
                DOUT              <= DOUT;
                DATA_CNT          <= DATA_CNT;
            end
            
            MSB_BYTE: begin
                DATA_2BYTE        <= {DIN, DATA_2BYTE[15:8]};
                DOUT              <= {DIN, DATA_2BYTE[15:8]};
                ACTIVE_FRAME      <= ACTIVE_FRAME;
                PIXEL_CNT         <= PIXEL_CNT +  1;
                LINE_CNT          <= LINE_CNT;
                if ((LINE_CNT >= V_QVGA_low) && (LINE_CNT <= (V_QVGA_high - 10'd1))) begin
                    if ((PIXEL_CNT == H_QVGA_low) && (LINE_CNT == V_QVGA_low)) begin
                        ADD      <= 18'b000000000000000000;
                        DATA_CNT <= 18'b000000000000000000;
                        WEA      <= 1'b1;
                    end
                    
                    else if ((PIXEL_CNT >= H_QVGA_low) && (PIXEL_CNT <= (H_QVGA_high - 10'd1))) begin
                        ADD       <= ADD + 1;
                        DATA_CNT  <= DATA_CNT + 1;
                        WEA       <= 1'b1;                  
                    end
                    
                    else begin
                        ADD      <= ADD;
                        DATA_CNT <= DATA_CNT;
                        WEA      <= 1'b0;                        
                    end
                end
                
                else begin                    
                    ADD          <= ADD;
                    DATA_CNT     <= DATA_CNT;
                    WEA          <= 1'b0; 
                end               
            end
            
            default: begin
                ACTIVE_FRAME      <= 1'b0;
                WEA               <= 1'b0;
                PIXEL_CNT         <= 16'h0000;
                LINE_CNT          <= 16'h0000;
                ADD               <= 18'b000000000000000000;
                DATA_2BYTE        <= 16'h0000;
                DOUT              <= 16'h0000;
                DATA_CNT          <= 18'b000000000000000000;
            end 
         endcase
    end  
end


always @(*) begin
    NEXT_STATE = CURRENT_STATE;                             // Default: stay in current state (prevents latches)
     
    case(CURRENT_STATE)
            IDLE: begin
                if ((FINISH_CONFIG == 1)&&(VSYNC == 1)) begin
                    NEXT_STATE = NEW_FRAME;
                end
            end
                  
            NEW_FRAME: begin
                if (!VSYNC) begin
                    NEXT_STATE = NEW_LINE;
                end
            end
            
            NEW_LINE: begin
                if (VSYNC) begin
                   NEXT_STATE = NEW_FRAME; 
                end
                else if (HREF_RISING && !VSYNC) begin
                   NEXT_STATE = INCR_LINE;
                end
            end
            
            INCR_LINE: begin
                NEXT_STATE = LSB_BYTE;
            end    
             
            LSB_BYTE: begin
                 NEXT_STATE = MSB_BYTE;
            end

            
            MSB_BYTE: begin
                if (VSYNC) begin
                    NEXT_STATE = NEW_FRAME;
                end
                else if (HREF_FALLING && !VSYNC) begin
                    NEXT_STATE = NEW_LINE;
                end
                else if (HREF && !VSYNC) begin
                    NEXT_STATE = LSB_BYTE;
                end   
           end
           
           default: NEXT_STATE = IDLE;
    endcase
end  

endmodule
