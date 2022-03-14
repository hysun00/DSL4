`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.02.2022 22:08:33
// Design Name: 
// Module Name: seven_seg
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


module SEVEN_SEG
(
  input CLK,
  input EN,
  input RESET,
  input [3:0] COMMAND,
  output reg [3:0] SEL,
  output reg [7:0] DIGIT
);

reg [1:0] next_state;
reg [1:0] curr_state;

//Selection bits
localparam IDLE   = 2'b11;
localparam LR     = 2'b10;
localparam FB     = 2'b01;

// Seven-segment display
localparam L   = 8'hC7;
localparam R   = 8'hAF;
localparam B   = 8'h83;
localparam F   = 8'h8E;
localparam NIL = 8'hFF;

// *****************************
// State registers
// *****************************
always @(posedge CLK)begin
    if(RESET == 1'b1) curr_state <= IDLE;
    else  curr_state <= next_state;
end
// *****************************

// *****************************
//State transition logic
// *****************************
always@(*) 
    case(curr_state)
            IDLE:   if (EN == 1'b1) next_state = LR; 
                    else next_state = curr_state;
            LR:     next_state = FB; 
            FB:     next_state = LR;
            default: next_state = IDLE;
    endcase
// *****************************


// *****************************
//Output logic
// *****************************
always @(*)
    case(curr_state)
            IDLE:   SEL = {IDLE,IDLE}; 
            LR:     if(COMMAND[0] || COMMAND[1]) SEL = {IDLE,LR}; 
                    else SEL = {IDLE,IDLE}; 
            FB:     if(COMMAND[2] || COMMAND[3]) SEL = {IDLE,FB};  
                    else SEL = {IDLE,IDLE};  
            default: SEL = {IDLE,IDLE}; 
    endcase
    
always @(*)
    case(curr_state)
            IDLE:   DIGIT = NIL; 
            LR:     if(COMMAND[0] == 1'b1) DIGIT = R;
                    else if(COMMAND[1] == 1'b1 ) DIGIT = L;
                    else DIGIT = NIL;
            FB:     if(COMMAND[2] == 1'b1) DIGIT = B;
                    else if(COMMAND[3] == 1'b1 ) DIGIT = F;
                    else DIGIT = NIL;
            default: DIGIT = NIL;
    endcase    
// *****************************

endmodule