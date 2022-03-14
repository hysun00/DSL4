`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.03.2022 19:02:54
// Design Name: 
// Module Name: Processor_tb
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


module Processor_tb();

parameter CLK_PERIOD = 10;

reg  CLK;
reg  RESET;
reg  [7:0] ROM_DATA;
reg  [1:0] BUS_INTERRUPTS_RAISE;
wire [7:0] BUS_DATA;//inout signal
wire [1:0] BUS_INTERRUPTS_ACK;
wire [7:0] ROM_ADDRESS;
wire [7:0] BUS_ADDR;
wire BUS_WE;


Processor 
DUT_Processor 
(
    CLK,
    RESET,
    BUS_DATA,
    BUS_ADDR,
    BUS_WE,
    ROM_ADDRESS,
    ROM_DATA,
    BUS_INTERRUPTS_RAISE,
    BUS_INTERRUPTS_ACK
);


endmodule
