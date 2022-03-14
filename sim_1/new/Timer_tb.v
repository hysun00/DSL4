`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.03.2022 01:57:12
// Design Name: 
// Module Name: Timer_tb
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


module Timer_tb();


reg CLK;
reg RESET;
//BUS signals
    wire  [7:0] BUS_DATA;
reg [7:0] BUS_ADDR;
reg  BUS_WE;
reg  BUS_INTERRUPT_ACK;   
wire BUS_INTERRUPT_RAISE;

Timer
DUT_Timer
(
   CLK, RESET,BUS_DATA,BUS_ADDR,BUS_WE,BUS_INTERRUPT_ACK, BUS_INTERRUPT_RAISE
);
endmodule
