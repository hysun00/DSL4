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
    input  BUS_ADDR,
    input  BUS_DATA,
    input  MOD_SEL,
    output SEL,
    output DIGIT
);


wire sel_1;
wire digit_1;
wire sel_2;
wire digit_2;


//Haoyuan
SevenSeg_2
U_SevenSeg_2
(
  .CLK     (CLK),
  .RESET   (RESET),
  .BUS_WE  (BUS_WE),
  .BUS_ADDR(BUS_ADDR),
  .BUS_DATA(BUS_DATA),
  .SEL     (sel_2),
  .DIGIT   (digit_2),
);

mux_2_to_1
U1_mux_2_to_1
(
    IN0(digit_1),
    IN1(digit_2),
    MUX_SEL(MOD_SEL),
    OUT(DIGIT)
);


mux_2_to_1
U2_mux_2_to_1
(
    IN0(sel_1),
    IN1(sel_2),
    MUX_SEL(MOD_SEL),
    OUT(SEL)
);

endmodule
