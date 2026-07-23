`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/09/2026 12:55:29 PM
// Design Name: 
// Module Name: OV7670_CTRL
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


module OV7670_CTRL(RST, CLK, READY, READY_f, TRIG_O, FINISH_CONFIG_O, ADD_O, DATA_O);
input RST;
input CLK;
input READY;
input READY_f;
output reg TRIG_O;
output reg FINISH_CONFIG_O;
output reg [7:0] ADD_O;
output reg [7:0] DATA_O;

localparam IDLE = 4'b0000, SOFT_RST = 4'b0001, WAIT1 = 4'b0010, MID_STATE = 4'b0011, COM7 = 4'b0100, COM15 = 4'b0101, RGB444 = 4'b0110, WAIT2 = 4'b0111, COM3 = 4'b1000;
reg FLAG;
reg [1:0] CNT;
reg [3:0] NEXT_STATE, CURRENT_STATE;
reg [23:0] COUNTER;

always@(posedge CLK or negedge RST) begin
    if (!RST) begin
        CURRENT_STATE   <= IDLE;
        CNT             <= 2'b00;
        FLAG            <= 1'b0;
        TRIG_O          <= 1'b0;
        FINISH_CONFIG_O <= 1'b0;
        ADD_O           <= 8'b00000000;
        DATA_O          <= 8'b00000000;
        COUNTER         <= 24'h000000;
        
        
    end else begin
        CURRENT_STATE <= NEXT_STATE;
        
        case (CURRENT_STATE)
            IDLE: begin
                CNT             <= 2'b00;
                FINISH_CONFIG_O <= FINISH_CONFIG_O;
                ADD_O           <= 8'b00000000;
                DATA_O          <= 8'b00000000;
                COUNTER         <= 24'h000000;
                if ((READY == 1'b1) && (FLAG == 1'b0)) begin
                    TRIG_O <= 1'b1;
                end
            end
            
            SOFT_RST: begin
                CNT             <= 2'b00;
                FINISH_CONFIG_O <= FINISH_CONFIG_O;
                TRIG_O          <= 1'b0;
                ADD_O           <= 8'b00010010;
                DATA_O          <= 8'b10000000;
                COUNTER         <= 24'h000000;

            end
            
            WAIT1: begin
                CNT             <= 2'b00;
                FINISH_CONFIG_O <= FINISH_CONFIG_O;
                TRIG_O          <= 1'b0;
                ADD_O           <= 8'b00010010;
                DATA_O          <= 8'b10000000;     
                COUNTER     <= COUNTER + 24'h000001;                   
            end
            
            MID_STATE: begin
                CNT             <= CNT;
                FINISH_CONFIG_O <= FINISH_CONFIG_O;
                ADD_O           <= ADD_O;
                DATA_O          <= DATA_O;    
                COUNTER         <= 24'h000000; 
                if (READY == 1) begin
                    TRIG_O   <= 1'b1;
                end else begin
                TRIG_O       <= 1'b0;
                end
            end
            
            COM7 : begin
                COUNTER         <= 24'h000000;
                FINISH_CONFIG_O <= FINISH_CONFIG_O;
                if (READY == 1) begin
                    TRIG_O   <= 1'b1;
                end else begin
                    TRIG_O   <= 1'b0;
                    ADD_O    <= 8'b00010010;
                    DATA_O   <= 8'b00000100; // RGB_selection format
                end  
            end
            
            COM15 : begin
                COUNTER         <= 24'h000000;
                FINISH_CONFIG_O <= FINISH_CONFIG_O;
                TRIG_O          <= 1'b1;
                if (READY == 1) begin
                    TRIG_O   <= 1'b1;
                end else begin    
                    TRIG_O   <= 1'b0;
                    ADD_O    <= 8'b01000000;
                    DATA_O   <= 8'b11010000;       
                end    
            end
            
            COM3 : begin
                COUNTER         <= 24'h000000;
                FINISH_CONFIG_O <= FINISH_CONFIG_O;
                TRIG_O          <= 1'b1;
                if (READY == 1) begin
                    TRIG_O   <= 1'b1;
                end else begin    
                    TRIG_O   <= 1'b0;
                    ADD_O    <= 8'b00001100;
                    DATA_O   <= 8'b00110000;
                end    
            end  
            
            RGB444 : begin
                COUNTER         <= 24'h000000;
                FINISH_CONFIG_O <= FINISH_CONFIG_O;    
                TRIG_O   <= 1'b0;
                ADD_O    <= 8'b10001100;
                DATA_O   <= 8'b00000010;              
            end                    
            
            WAIT2: begin
                CNT      <= 2'b00;
                ADD_O    <= 8'b00000000;
                DATA_O   <= 8'b00000000;
                COUNTER  <= COUNTER + 24'h000001;
                FLAG     <= 1'b1;
              if (COUNTER == 24'h7A0580) begin            // 7A0580 = 10 frames
             // if (COUNTER == 24'h000080) begin            // Value for Testbench
                    FINISH_CONFIG_O <= 1'b1;
                end   
            end
                    
        endcase
    end
end
            
            
always@(*) begin
   NEXT_STATE = CURRENT_STATE;
        
    case (CURRENT_STATE)
       IDLE: begin
            if ((READY == 1'b1) && (FLAG == 1'b0)) begin
                NEXT_STATE = SOFT_RST;
            end
       end
       
       SOFT_RST: begin
       NEXT_STATE = WAIT1;       
       end
       
       WAIT1: begin
            if (COUNTER == 24'h00BB80) begin                // BB80 clocks with frequency of 48MHz = 1ms
                NEXT_STATE = MID_STATE;
            end              
       end
       
       MID_STATE: begin
            if (READY_f == 1) begin
                NEXT_STATE <= COM7;
            end
       end
       
       COM7: begin
            if (READY_f  == 1) begin
                NEXT_STATE <= COM15;
            end
       end

       COM15: begin
            if (READY_f  == 1) begin
                NEXT_STATE <= COM3;
            end
       end
       
       COM3: begin
            if (READY_f  == 1) begin
                NEXT_STATE <= RGB444;
            end
       end

       RGB444: begin
            if (READY  == 1) begin
                NEXT_STATE <= WAIT2;
            end
       end
              
       WAIT2: begin
         if (COUNTER == 24'h7A0580) begin            // 7A0580 = 10 frames
        // if (COUNTER == 24'h000080) begin           // Value for Testbench
                NEXT_STATE = IDLE;
            end  
       end          
                   
    endcase
end

endmodule

