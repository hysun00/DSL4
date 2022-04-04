`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2022 16:32:48
// Design Name: 
// Module Name: seg7decoder
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


module seg7decoder
(
    input  CLK,
    input  RESET,
    input  BUS_WE,
    input [7:0]  BUS_ADDR,
    input [7:0] BUS_DATA,
    input MOD_SEL,
    output [3:0] SEL,
    output [7:0] DIGIT
);

// *****************************
// Internal signals.
// *****************************
wire [3:0] sel_1;
wire [7:0] digit_1;
wire [3:0] sel_2;
wire [7:0] digit_2;
// *****************************

// *****************************
// 0xD0 to 0xD1
// *****************************
SevenSeg_1 
U_SevenSeg_1 
(
    .CLK(CLK),
    .RESET(RESET),
    .BUS_DATA(BUS_DATA),
    .BUS_ADDR(BUS_ADDR),
    .BUS_WE  (BUS_WE),
    .SEG_SELECT_OUT     (sel_1),
    .HEX_OUT   (digit_1)
);
// *****************************

// *****************************
// 0xD2
// *****************************
SevenSeg_2
U_SevenSeg_2
(
    .CLK     (CLK),
    .RESET   (RESET),
    .BUS_WE  (BUS_WE),
    .BUS_ADDR(BUS_ADDR),
    .BUS_DATA(BUS_DATA),
    .SEL     (sel_2),
    .DIGIT   (digit_2)
);
// *****************************

// *****************************
// Digit output
// *****************************
mux_2_to_1
#(
   .WIDTH (8)
)
U1_mux_2_to_1
(
    .IN0(digit_1),
    .IN1(digit_2),
    .MUX_SEL(MOD_SEL),
    .OUT(DIGIT)
);
// *****************************

// *****************************
// Selection bits output
// *****************************
mux_2_to_1
#(
   .WIDTH (4)
)
U2_mux_2_to_1
(
    .IN0(sel_1),
    .IN1(sel_2),
    .MUX_SEL(MOD_SEL),
    .OUT(SEL)
);
// *****************************

endmodule
