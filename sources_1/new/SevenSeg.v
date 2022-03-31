`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 15.03.2022 10:22:08
// Design Name:
// Module Name: SevenSeg
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


module SevenSeg
(
  input CLK,
  input RESET,
  input BUS_WE,
  input  [7:0] BUS_ADDR,
  input  [7:0] BUS_DATA,
  output [3:0] SEL,
  output [7:0] DIGIT
);

wire [7:0] data_out;

// *****************************
// Bus Interface
// *****************************
BusInterfaceSevenSeg
U_BusInterfaceSevenSeg
(
    .CLK     (CLK),
    .RESET   (RESET),
    .ADDR    (BUS_ADDR),
    .DATA_IN (BUS_DATA),
    .BUS_WE  (BUS_WE),
    .DATA_OUT(data_out)
);
// *****************************

// *****************************
// Seven-segment state machine
// *****************************
SevenSegSM
U_SevenSegSM
(
    .CLK     (CLK),
    .RESET   (RESET),
    .COMMAND (data_out[3:0]),
    .SEL     (SEL),
    .DIGIT   (DIGIT)
);
// *****************************

endmodule
