`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 09.03.2022 17:14:43
// Design Name:
// Module Name: IRTransmitter
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


module IRTransmitter
#(
    parameter IO_ADDRESS            = 8'h90,
    parameter IN_MHZ                = 100,
    parameter SM_KHZ                = 40,
    parameter START_BURST_SIZE      = 88,
    parameter CAR_SELECT_BURST_SIZE = 22,
    parameter GAP_SIZE              = 40,
    parameter ASSERT_BURST_SIZE     = 44,
    parameter DEASSERT_BURST_SIZE   = 22
)
(
 // INPUT
    input CLK, //IN_MHZ
    input RESET,
    input BUS_WE,
    input [7:0] BUS_ADDR,
    input [7:0] BUS_DATA,
 // OUTPUT
    output IR_LED
);

// *****************************
// Define internal signals
// *****************************
wire clk_10hz;   //10HZ, 50% duty
wire send_packet;//10HZ, edge detector
wire clk_sm;     //working clock and carier wave, 50%duty
wire [7:0] data_out;
// *****************************

// *****************************
// Bus Interface
// *****************************
BusInterfaceIR
#(
    .IO_ADDRESS(IO_ADDRESS)
)
U_BusInterfaceIR
(
    .CLK     (CLK),
    .RESET   (RESET),
    .BUS_WE  (BUS_WE),
    .ADDR    (BUS_ADDR),
    .DATA_IN (BUS_DATA),
    .DATA_OUT(data_out)
);
// *****************************

// *****************************
// 10HZ clock
// *****************************
TenHz_cnt
#(
    .IN_MHZ       (IN_MHZ),
    .OUT_KHZ      (0.01),
    .COUNTER_WIDTH(25)
)
CLOCK_DIVIDER_10HZ
(
    .CLK    (CLK),
    .RESET  (RESET),
    .CLK_OUT(clk_10hz)
);

EdgeDetector
U_EdgeDetector
(
    .CLK     (clk_sm),
    .RESET   (RESET),
    .ORIGINAL(clk_10hz),
    .SAMPLED (send_packet)
);
// *****************************

// *****************************
// Working clock for state machine
// 50% duty, 0 phase shift
// *****************************
TenHz_cnt
#(
    .IN_MHZ       (IN_MHZ),
    .OUT_KHZ      (SM_KHZ),
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
//  State machine
// *****************************
IRTransmitterSM
#(
 // Subject to colour
    .START_BURST_SIZE     (START_BURST_SIZE),
    .CAR_SELECT_BURST_SIZE(CAR_SELECT_BURST_SIZE),
    .GAP_SIZE             (GAP_SIZE),
    .ASSERT_BURST_SIZE    (ASSERT_BURST_SIZE),
    .DEASSERT_BURST_SIZE  (DEASSERT_BURST_SIZE),
    .COUNTER_WIDTH        (11)
)
U_IRTransmitterSM
(
    .RESET      (RESET),
    .CLK        (clk_sm),
    .SEND_PACKET(send_packet),
    .COMMAND    (data_out[3:0]),
    .IR_LED     (IR_LED)
);
// *****************************

endmodule
