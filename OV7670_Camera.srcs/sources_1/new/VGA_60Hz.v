`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2026 08:18:26 PM
// Design Name: 
// Module Name: VGA_60Hz
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

//Horizontal:
//Visible     = 640
//Front Porch = 16
//Sync Pulse  = 96
//Back Porch  = 48
//Total       = 800

//Vertical:
//Visible     = 480
//Front Porch = 10
//Sync Pulse  = 2
//Back Porch  = 33
//Total       = 525

//////////////////////////////////////////////////////////////////////////////Need to check some issues under simulation. The detail about those issues represent in seperate word file.  ///////////////////////////////////

module VGA_60Hz(CLK, RST, FINISH_CONFIG, VSYNC_I, DATA_IN, VGA_ADD, VSYNC, HSYNC, RED, BLUE, GREEN, VCNT_O);
    
    input CLK;
    input RST;
    input FINISH_CONFIG;
    input VSYNC_I;
    input [15:0] DATA_IN;
    output reg [17:0] VGA_ADD;
    output reg VSYNC;
    output reg HSYNC;
    output reg [3:0] RED;
    output reg [3:0] BLUE;
    output reg [3:0] GREEN;
    output wire[9:0] VCNT_O;
    
    
    localparam H_total = 10'd800, H_active = 10'd639, H_front = 10'd16, H_synch = 10'd96, H_QVGA_low = 10'd160, H_QVGA_high = 10'd480;
    localparam V_total = 10'd525, V_active = 10'd480, V_front = 10'd10, V_synch = 10'd2,  V_QVGA_low = 10'd120, V_QVGA_high = 10'd360;
    reg [9:0] VCNT;
    reg [9:0] HCNT;
    reg [3:0] RED_cld;
    reg [3:0] BLUE_cld;
    reg [3:0] GREEN_cld;
    
    reg flag;
   
   
always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        flag <= 1'b0;             
    end else begin 
        if ((FINISH_CONFIG == 1) && (VSYNC_I == 1)) begin
            flag <= 1'b1;
        end
    end
end
   
   
    
always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        VCNT    <= 10'b0000000000;
        HCNT    <= 10'b0000000000;
                  
    end else begin
        if ((FINISH_CONFIG == 1)&&(flag == 1))  begin
            if (HCNT == (H_total - 1)) begin
                HCNT    <= 10'b0000000000;            
                if (VCNT == (V_total - 1)) begin
                    VCNT <= 10'b0000000000;            
                end else begin
                    VCNT <= VCNT + 1;
                end
        
            end else begin
                HCNT <= HCNT + 1;
            end
        end
    end
end 


always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        VSYNC    <= 1'b1;
        HSYNC    <= 1'b1;
                  
    end else begin
        if ((FINISH_CONFIG == 1)&&(flag == 1))  begin
            if ((HCNT >= H_active + H_front) && (HCNT < H_active + H_front + H_synch)) begin
                HSYNC <= 1'b0;
            end else begin
                HSYNC <= 1'b1;
            end
        
            if ((VCNT >= V_active + V_front) && (VCNT < V_active + V_front + V_synch)) begin
                VSYNC <= 1'b0;
            end else begin
                VSYNC <= 1'b1;
            end
        end        
    end
end  
 
 
always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        VGA_ADD     <= 18'b000000000000000000;
        RED         <= 1'b0000;
        BLUE        <= 1'b0000;
        GREEN       <= 1'b0000;  
                     
    end else begin
        if ((FINISH_CONFIG == 1)&&(flag == 1))  begin
            if((VCNT >= V_QVGA_low) &&(VCNT < V_QVGA_high)) begin
                if ((VCNT == V_QVGA_low) && (HCNT == H_QVGA_low)) begin 
                    VGA_ADD <= 18'b000000000000000000;
                    RED     <= 1'b0000;
                    BLUE    <= 1'b0000;
                    GREEN   <= 1'b0000;  
                    
                 end else if ((HCNT >= H_QVGA_low) &&(HCNT < H_QVGA_low +  10'd3)) begin
                    VGA_ADD <= VGA_ADD + 1;
                    RED     <= 1'b0000;
                    BLUE    <= 1'b0000;
                    GREEN   <= 1'b0000;  
                                        
                end else if ((HCNT >= H_QVGA_low + 10'd3 ) &&(HCNT < H_QVGA_high)) begin
                    VGA_ADD <= VGA_ADD + 1;
                //  RED     <= DATA_IN[3:0];
                //  BLUE    <= DATA_IN[11:8];
                //  GREEN   <= DATA_IN[15:12]; 
                    RED     <= DATA_IN[15:12];
                    BLUE    <= DATA_IN[7:4];
                   GREEN   <= DATA_IN[3:0];

                    
                end else if ((HCNT >= H_QVGA_high ) &&(HCNT < H_QVGA_high + 10'd3)) begin
                    VGA_ADD <= VGA_ADD;
                 // RED     <= DATA_IN[3:0];
                 // BLUE    <= DATA_IN[11:8];
                 // GREEN   <= DATA_IN[15:12]; 
                    RED     <= DATA_IN[15:12];
                    BLUE    <= DATA_IN[7:4];
                    GREEN   <= DATA_IN[3:0];

                 
                end else begin
                    VGA_ADD <= VGA_ADD;
                    RED     <= 1'b0000;
                    BLUE    <= 1'b0000;
                    GREEN   <= 1'b0000;  
                end
            end
            
        end else begin
            VGA_ADD   <= 18'b000000000000000000;
            RED       <= 1'b0000;
            BLUE      <= 1'b0000;
            GREEN     <= 1'b0000;            
        end
    end  
end        
                  


 
assign VCNT_O = VCNT;
 


    
endmodule
