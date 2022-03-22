`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Edinburgh
// Engineer: Yichen Zhang
//
// Create Date: 10.03.2022 21:28:23
// Design Name:
// Module Name:
// Project Name:
// Target Devices:
// Tool Versions:
// Description: This module only contains microprocessor, without PS2 mouse interface. It is for testbench simulation purpose only
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module Micro(input CLK,
           input RESET);

    wire [7:0] BUS_ADDR, BUS_DATA;
    wire [7:0] ROM_ADDRESS, ROM_DATA;
    wire [1:0] BUS_INTERRUPT_ACK, BUS_INTERRUPT_RAISE;
    wire BUS_WE;


    RAM ram(
        .CLK(CLK),
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE)
    );

    ROM rom(
        .CLK(CLK),
        .DATA(ROM_DATA),
        .ADDR(ROM_ADDRESS)
    );

    Timer timer(
        .CLK(CLK),
        .RESET(RESET),
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        .BUS_INTERRUPT_RAISE(BUS_INTERRUPT_RAISE[1]),
        .BUS_INTERRUPT_ACK(BUS_INTERRUPT_ACK[1])
    );

    Processor processor(
        .CLK(CLK),
        .RESET(RESET),
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        .ROM_ADDRESS(ROM_ADDRESS),
        .ROM_DATA(ROM_DATA),
        .BUS_INTERRUPTS_RAISE(BUS_INTERRUPT_RAISE),
        .BUS_INTERRUPTS_ACK(BUS_INTERRUPT_ACK)
    );

    // A test for mouse interrupt
    ps2_itrpt ps2itrpt(
        .CLK(CLK),
        .RESET(RESET),
        .BUS_INTERRUPT_RAISE(BUS_INTERRUPT_RAISE[0]),
        .BUS_INTERRUPT_ACK(BUS_INTERRUPT_ACK[0]),
        .BUS_WE(BUS_WE),
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR)
    );

endmodule
