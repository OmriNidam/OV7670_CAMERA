`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2026 10:12:48 PM
// Design Name: 
// Module Name: I2C_BIT_SM
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


module SCCB_BIT_SM (RST, CLK, SIO_D_O, SCCB_TRIG, SM_ACTION, DATA_IN, SCCB_READY, CONTINUOUS_OPER, OE, SIO_D_I, SIO_C);
input RST;
input CLK;
input SIO_D_O;
input SCCB_TRIG;
input [2:0] SM_ACTION;
input [7:0] DATA_IN;
output reg SCCB_READY;
output reg CONTINUOUS_OPER;
output reg OE;
output reg SIO_D_I;
output reg SIO_C;

parameter CLK_FREQ_H_M = 48;
localparam DO_NOTHING = 3'b000, ACTION_START = 3'b001, ACTION_TALK = 3'b010, ACTION_N_A = 3'b011, ACTION_STOP = 3'b100;
localparam IDLE = 4'b0000, ACTION = 4'b0001, START = 4'b0010, TALK = 4'b0011, NA_BIT = 4'b0100, STOP = 4'b0101, DONT_CARE = 4'b0110, SU_STA = 4'b0111, START_CONDITION = 4'b1000, HD_STA = 4'b1001;
localparam T_FALLING = 4'b1010, T_LOW = 4'b1011, T_RISING = 4'b1100, T_HIGH = 4'b1101, T_SU_STO = 4'b1110, T_BUFF = 4'b1111 ;
localparam [31:0] T_LOW_CYCLES = (1300 * CLK_FREQ_H_M)/1000,  T_HIGH_CYCLES = (1083 * CLK_FREQ_H_M)/1000, T_FALLING_CYCLES = (21 * CLK_FREQ_H_M)/1000, T_RISING_CYCLES = (21 * CLK_FREQ_H_M)/1000;
localparam [31:0] T_HD_STA_CYCLES = 1 + (600 * CLK_FREQ_H_M)/1000, T_SU_STA_CYCLES = 1 + (600 * CLK_FREQ_H_M)/1000, T_SU_STO_CYCLES = 1 + (600 * CLK_FREQ_H_M)/1000;
localparam [31:0] T_SU_DAT_CYCLES =  (600 * CLK_FREQ_H_M)/1000;
localparam [31:0] T_BUFF_CYCLES =  1 + (1600 * CLK_FREQ_H_M)/1000;
localparam [7:0] byte = 8;


reg [3:0] NEXT_STATE, CURRENT_STATE;
reg [31:0] timing_counter;
reg [7:0] byte_counter;


always @(posedge CLK or negedge RST) begin
    if (!RST) begin
        CURRENT_STATE   <= IDLE;
        CONTINUOUS_OPER <= 1'b0;
        SCCB_READY      <= 1'b1;
        SIO_D_I         <= 1'b1;
        SIO_C           <= 1'b1;
        OE              <= 1'b0;
        byte_counter    <= 8'd0;
        timing_counter  <= 32'd0;

        
    end else begin
        CURRENT_STATE <= NEXT_STATE;
        
        case(CURRENT_STATE)
            IDLE: begin
                CONTINUOUS_OPER <= 1'b0;
                SCCB_READY      <= 1'b1;
                SIO_D_I         <= 1'b1;
                SIO_C           <= 1'b1;
                OE              <= 1'b1;
            end
            
            ACTION: begin
                CONTINUOUS_OPER <= 1'b0;
                SCCB_READY      <= 1'b0;
                SIO_D_I         <= SIO_D_I;
                SIO_C           <= SIO_C;
                OE              <= 1'b1;
            end
            
            START: begin
                CONTINUOUS_OPER <= 1'b0;
                SCCB_READY      <= 1'b0;
                SIO_D_I         <= 1'b1;
                SIO_C           <= 1'b1;
                OE              <= 1'b1;
            end  
            
            SU_STA: begin          //with 48MHz clock and minimum of 600ns at SU_STA => the minimum wait clock is 29 cycles !!!
                CONTINUOUS_OPER <= 1'b0;
                SCCB_READY      <= 1'b0;               
                SIO_D_I         <= 1'b1;
                SIO_C           <= 1'b1;
                OE              <= 1'b1;
                if (timing_counter == T_SU_STA_CYCLES) begin
                    timing_counter <= 32'd0;
                end else begin
                    timing_counter <= timing_counter + 1;
                end
            end   
            
            START_CONDITION: begin 
                CONTINUOUS_OPER <= 1'b0; 
                SCCB_READY      <= 1'b0;
                SIO_D_I         <= 1'b0;
                SIO_C           <= 1'b1;
                OE              <= 1'b1;
            end
            
            HD_STA: begin
                CONTINUOUS_OPER <= 1'b0;
                SCCB_READY      <= 1'b0;
                SIO_D_I         <= SIO_D_I;
                SIO_C           <= SIO_C;
                OE              <= 1'b1;
                if (timing_counter == T_HD_STA_CYCLES) begin
                    timing_counter <= 32'd0;
                end else begin
                    timing_counter <= timing_counter + 1;
                end    
            end
            
            TALK: begin
                CONTINUOUS_OPER <= 1'b0;
                SCCB_READY      <= 1'b0;
                SIO_D_I         <= SIO_D_I;
                SIO_C           <= SIO_C;
                OE              <= 1'b1;
            end
            
            T_FALLING: begin
                CONTINUOUS_OPER <= 1'b0;
                SCCB_READY      <= 1'b0;
                SIO_D_I         <= SIO_D_I;
                SIO_C           <= 1'b0;
                OE              <= 1'b1;
                if (timing_counter == T_FALLING_CYCLES) begin
                    timing_counter <= 32'd0;
                end else begin
                    timing_counter <= timing_counter + 1;
                end
            end 
            
            T_LOW: begin
                CONTINUOUS_OPER <= 1'b0;
                SCCB_READY      <= 1'b0;
                SIO_C           <= 1'b0;
                OE              <= 1'b1;
                if (timing_counter == T_LOW_CYCLES) begin
                    SIO_D_I        <= SIO_D_I;
                    timing_counter <= 32'd0;
                end
                else if (timing_counter == T_SU_DAT_CYCLES) begin
                    SIO_D_I        <= DATA_IN[7 - byte_counter];
                    byte_counter   <= byte_counter + 1;
                    timing_counter <= timing_counter + 1;
                end
                else begin
                    SIO_D_I        <= SIO_D_I;
                    timing_counter <= timing_counter + 1;
                end
            end
            
            T_RISING: begin
                CONTINUOUS_OPER <= 1'b0;
                SCCB_READY      <= 1'b0;
                SIO_D_I         <= SIO_D_I;
                SIO_C           <= 1'b1;
                OE              <= 1'b1;
                if (timing_counter == T_RISING_CYCLES) begin
                    timing_counter <= 32'd0;
                end else begin
                    timing_counter <= timing_counter + 1;
                end
            end
            
            T_HIGH: begin
                CONTINUOUS_OPER <= 1'b0;
                SCCB_READY      <= 1'b0;
                SIO_D_I         <= SIO_D_I;
                SIO_C           <= 1'b1;
                OE              <= 1'b1;
                if (timing_counter == T_HIGH_CYCLES) begin
                    timing_counter <= 32'd0;
                    if (byte_counter == byte) begin
                        byte_counter <= 8'd0;
                    end else begin
                        byte_counter <= byte_counter;
                    end
                end else begin
                    timing_counter <= timing_counter + 1;
                end
            end
            
            DONT_CARE: begin 
               SCCB_READY      <= 1'b0; 
               SIO_D_I         <= SIO_D_I;
               OE              <= 1'b0;
               if (timing_counter == T_LOW_CYCLES + T_FALLING_CYCLES + T_RISING_CYCLES + T_HIGH_CYCLES) begin
                    CONTINUOUS_OPER <= 1'b1;
                    SIO_C           <= 1'b1;
                    timing_counter  <= 32'd0;
               end
               else if (timing_counter == T_LOW_CYCLES + T_FALLING_CYCLES + T_RISING_CYCLES) begin
                    SIO_C          <= 1'b1;
                    timing_counter <= timing_counter + 1;
               end
               else if (timing_counter == T_LOW_CYCLES + T_FALLING_CYCLES) begin
                    SIO_C          <= 1'b0;
                    timing_counter <= timing_counter + 1;
               end
               else if (timing_counter == T_FALLING_CYCLES) begin
                    SIO_C          <= 1'b0;
                    timing_counter <= timing_counter + 1;
                end else begin
                    timing_counter <= timing_counter + 1;
                end
            end
            
            STOP: begin
               CONTINUOUS_OPER <= 1'b0;
               SCCB_READY      <= 1'b0;
               SIO_C           <= 1'b0;
               OE              <= 1'b1;
               if (timing_counter == T_LOW_CYCLES) begin
                    timing_counter <= 32'd0;
                    SIO_D_I        <= SIO_D_I;
               end
               else if (timing_counter == T_FALLING_CYCLES + T_SU_DAT_CYCLES) begin
                    SIO_D_I        <= 1'b0;
                    timing_counter <= timing_counter + 1;
               end
               else begin
                    timing_counter <= timing_counter + 1;
                    SIO_D_I       <= SIO_D_I;
               end 
            end
            
            T_SU_STO : begin
               CONTINUOUS_OPER <= 1'b0;
               SCCB_READY      <= 1'b0;
               SIO_D_I         <= SIO_D_I;
               SIO_C           <= 1'b1;
               OE              <= 1'b1;
               if (timing_counter == T_SU_STO_CYCLES) begin
                   timing_counter <= 32'd0;
               end
               else begin
                   timing_counter <= timing_counter + 1;    
               end
            end
            
            T_BUFF : begin
               CONTINUOUS_OPER <= 1'b0;
               SCCB_READY      <= 1'b0;
               SIO_D_I         <= 1'b1;
               SIO_C           <= 1'b1;
               OE              <= 1'b1;
               if (timing_counter == T_BUFF_CYCLES) begin
                   timing_counter <= 32'd0;
               end
               else begin
                   timing_counter <= timing_counter + 1;    
               end
            end
       
       
        endcase
    end
end        



always @(*) begin
    NEXT_STATE = CURRENT_STATE;
        
    case(CURRENT_STATE)
        IDLE: begin
            if (SCCB_TRIG == 1'b1) begin
                NEXT_STATE = ACTION;
            end            
        end
            
        ACTION: begin
            if (SM_ACTION == ACTION_START) begin
                NEXT_STATE = START;
            end
            else if (SM_ACTION == ACTION_TALK) begin
                NEXT_STATE = TALK;
            end
            else if (SM_ACTION == ACTION_N_A) begin
                NEXT_STATE = STOP;
            end
            else if (SM_ACTION == ACTION_STOP) begin
                NEXT_STATE = STOP;
            end
             else begin
                NEXT_STATE = ACTION;     
            end
        end
            
        START: begin
            NEXT_STATE = SU_STA;
        end  
            
        SU_STA: begin 
            if (timing_counter == T_SU_STA_CYCLES) begin
                NEXT_STATE = START_CONDITION;
            end  
        end   
            
        START_CONDITION: begin
            NEXT_STATE = HD_STA; 
        end
            
        HD_STA: begin
            if (timing_counter == T_HD_STA_CYCLES) begin
                NEXT_STATE = ACTION; 
            end
        end
        
        TALK: begin
            NEXT_STATE = T_FALLING;
        end
        
        T_FALLING: begin
             if (timing_counter == T_FALLING_CYCLES) begin
                NEXT_STATE = T_LOW;
             end
        end
        
        T_LOW: begin
             if (timing_counter == T_LOW_CYCLES) begin
                NEXT_STATE = T_RISING;
             end
        end
        
       T_RISING: begin
             if (timing_counter == T_RISING_CYCLES) begin
                NEXT_STATE = T_HIGH;
             end
        end

       T_HIGH: begin
             if (timing_counter == T_HIGH_CYCLES) begin
                if (byte_counter == byte) begin
                    NEXT_STATE = DONT_CARE;
                end else begin
                    NEXT_STATE = T_FALLING;
                end
             end
        end
        
       DONT_CARE : begin
            if (timing_counter == T_LOW_CYCLES + T_FALLING_CYCLES + T_RISING_CYCLES + T_HIGH_CYCLES) begin
                NEXT_STATE = ACTION;
            end
        end            
        
        STOP : begin
            if (timing_counter == T_LOW_CYCLES) begin
                NEXT_STATE = T_SU_STO;
            end
        end
        
        T_SU_STO : begin
            if (timing_counter == T_SU_STO_CYCLES) begin
                NEXT_STATE = T_BUFF;
            end
        end
        
        T_BUFF : begin
            if (timing_counter == T_BUFF_CYCLES) begin
                NEXT_STATE = IDLE;
            end
        end       
           
    endcase
end                                
                                                        

endmodule
