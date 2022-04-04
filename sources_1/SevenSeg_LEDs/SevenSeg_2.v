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


module SevenSeg_2
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
wire clk_sm;

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
// Working clock for state machine
// 50% duty, 0 phase shift
// *****************************
TenHz_cnt
#(
    .IN_MHZ       (100),
    .OUT_KHZ      (40),
    .COUNTER_WIDTH(12)
)
CLOCK_DIVIDER_40KHZ
(
    .CLK    (CLK),
    .RESET  (RESET),
    .CLK_OUT(clk_sm)
);
// *****************************

// *****************************
// Seven-segment state machine
// *****************************
SevenSegSM
U_SevenSegSM
(
    .CLK     (clk_sm),
    .RESET   (RESET),
    .COMMAND (data_out[3:0]),
    .SEL     (SEL),
    .DIGIT   (DIGIT)
);
// *****************************
endmodule