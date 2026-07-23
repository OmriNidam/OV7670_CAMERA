`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2026 08:34:59 PM
// Design Name: 
// Module Name: I2C_TOP
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


module SCCB_TOP(CLK_48M, RST, SIO_D_O, FINISH_CONFIG, OE, SIO_D_I, SIO_C);
    input CLK_48M;
    input RST;
    input SIO_D_O;
    output wire FINISH_CONFIG;
    output wire OE;
    output wire SIO_D_I;
    output wire SIO_C;


///// OV7670_CTRL ///////
wire TRIG_O;
wire [7:0] ADD_OUT;
wire [7:0] CTRL_DATA_O;
////////////////////////

///// SCCB_BYTE_SM /////
wire SCCB_TRIG_O;
wire [7:0] BYTE_DATA_O;
wire [2:0] SM_ACTION;
///////////////////////

////// SCCB_BIT_SM ////
reg [1:0] READY_d;
reg READY_FALLING_d;
wire READY_FALLING;
wire READY;
wire CONTINUOUS_OPER;

///////////////////////////////////////////////////////////////////////////
always@(posedge CLK_48M or negedge RST) begin
    if(!RST) begin
        READY_d    <= 2'b00;
    end else begin
        READY_d[0] <= READY;
        READY_d[1] <= READY_d[0];
    end
end


always@(posedge CLK_48M or negedge RST) begin
    if(!RST) begin
        READY_FALLING_d   <= 0;

    end else begin
        READY_FALLING_d   <= (READY_d[1] & ~READY_d[0]);
    end
end

assign READY_FALLING = READY_FALLING_d;

///////////////////////////////////////////////////////////////////////////
OV7670_CTRL instance_SCCB_CTRL(
    .RST(RST),
    .CLK(CLK_48M),
    .READY(READY),
    .READY_f(READY_FALLING),
    .TRIG_O(TRIG_O),
    .FINISH_CONFIG_O(FINISH_CONFIG),
    .ADD_O(ADD_OUT),
    .DATA_O(CTRL_DATA_O)   
    );
    

SCCB_BYTE_SM instance_BYTE_SM(
    .RST(RST),
    .CLK(CLK_48M),
    .CONTINUOUS_OPER(CONTINUOUS_OPER),
    .SCCB_TRIG_I(TRIG_O),
    .ADD_I(ADD_OUT),
    .DATA_I(CTRL_DATA_O),
    .SM_ACTION(SM_ACTION),
    .SCCB_TRIG_O(SCCB_TRIG_O),
    .DATA_O(BYTE_DATA_O)
    );


SCCB_BIT_SM instance_BIT_SM(
    .RST(RST),
    .CLK(CLK_48M),
    .SIO_D_O(SIO_D_O),
    .SCCB_TRIG(SCCB_TRIG_O),
    .SM_ACTION(SM_ACTION),
    .DATA_IN(BYTE_DATA_O),
    .SCCB_READY(READY),
    .CONTINUOUS_OPER(CONTINUOUS_OPER),
    .OE(OE),
    .SIO_D_I(SIO_D_I),
    .SIO_C(SIO_C)   
    );

endmodule
