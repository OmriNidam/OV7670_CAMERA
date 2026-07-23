`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/09/2026 08:51:34 AM
// Design Name: 
// Module Name: SCCB_BYTE_SM
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


module SCCB_BYTE_SM(CLK, RST, CONTINUOUS_OPER, SCCB_TRIG_I, ADD_I, DATA_I, SM_ACTION, SCCB_TRIG_O, DATA_O);
input CLK;
input RST;
input CONTINUOUS_OPER;
input SCCB_TRIG_I;
input [7:0] ADD_I;
input [7:0] DATA_I;
output reg [2:0] SM_ACTION;
output reg SCCB_TRIG_O;
output reg [7:0] DATA_O;


localparam DO_NOTHING = 3'b000, ACTION_START = 3'b001, ACTION_TALK = 3'b010, ACTION_STOP = 3'b100;
localparam IDLE = 3'b000, START = 3'b001, IP_ADD = 3'b010, SUB_ADD = 3'b011, WRITE = 3'b100, STOP = 3'b101;
reg [2:0] CURRENT_STATE, NEXT_STATE;
reg flag;

always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        flag          <= 1'b0;
        CURRENT_STATE <= IDLE;
        SCCB_TRIG_O   <= 1'b0;
        SM_ACTION     <= DO_NOTHING;
        DATA_O        <= 8'b00000000;
        
    end else begin
        CURRENT_STATE <= NEXT_STATE;
        case(CURRENT_STATE)
            IDLE: begin
                flag        <= 1'b0;
                SM_ACTION   <= DO_NOTHING; 
                 DATA_O     <= 8'b00000000;
                if (SCCB_TRIG_I == 1'b1) begin
                    SCCB_TRIG_O <= 1'b1;
               end else begin
                    SCCB_TRIG_O <= 1'b0;            
                end
            end
            
            START: begin
                flag        <= 1'b0;
                DATA_O      <= 8'b00000000;
                SCCB_TRIG_O <= 1'b0;
                SM_ACTION   <= ACTION_START; 
            end
            
            IP_ADD: begin
                flag        <= 1'b0;
                DATA_O      <= 8'h42;
                SCCB_TRIG_O <= 1'b0;
                SM_ACTION   <= ACTION_TALK;
            end
            
            SUB_ADD: begin
                flag        <= 1'b0;
                SCCB_TRIG_O <= 1'b0;
                SM_ACTION   <= ACTION_TALK;
                if (CONTINUOUS_OPER == 1) begin
                    DATA_O  <= ADD_I;
                end
            
            end
            
            WRITE: begin
                SCCB_TRIG_O <= 1'b0;
                if (CONTINUOUS_OPER == 1) begin
                    flag      <= 1'b1;
                    DATA_O    <= DATA_I;
                    SM_ACTION <= ACTION_STOP;
                end
            end
            
            STOP: begin
                flag          <= 1'b0;
                SCCB_TRIG_O   <= 1'b0;
                SM_ACTION     <= DO_NOTHING;
                DATA_O        <= 8'b00000000;
            end  
            
               
        endcase
    end
end


always @(*) begin
    NEXT_STATE = CURRENT_STATE;

    case(CURRENT_STATE)
        IDLE: begin
            if (SCCB_TRIG_O == 1'b1) begin
                NEXT_STATE = START;
            end
        end
        
        START: begin
            NEXT_STATE = IP_ADD;      
        end
        
        IP_ADD: begin
            NEXT_STATE = SUB_ADD;    
        end
        
        SUB_ADD: begin
            if (CONTINUOUS_OPER == 1) begin
                NEXT_STATE = WRITE;
            end 
        end
        
        WRITE: begin
            if ((CONTINUOUS_OPER == 1) && (flag == 1)) begin
                NEXT_STATE = STOP;
            end 
        end
        
        STOP: begin
            NEXT_STATE = IDLE;     
        end  
                          
    endcase
end
    
    










endmodule
  