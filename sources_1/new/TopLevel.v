`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Edinburgh
// Engineer: Yichen Zhang
//
// Create Date: 11.03.2022 21:29:36
// Design Name: Top module
// Module Name: PS2_Micro
// Project Name: Second Assessment
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


module PS2_Micro(input RESET,
                 input CLK,
                 inout CLK_MOUSE,
                 inout DATA_MOUSE,
                 input [1:0] DPI,   // Change DPI using the 2 LSB switches
                 output [15:0] LEDS,
                 output [3:0] SEG_SELECT_OUT,
                 output [7:0] HEX_OUT);

    wire [7:0] BUS_ADDR, BUS_DATA;
    wire [7:0] ROM_ADDRESS, ROM_DATA;
    wire [1:0] INTERRUPT_ACK, INTERRUPT_RAISE;
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
        .BUS_INTERRUPT_RAISE(INTERRUPT_RAISE[1]),
        .BUS_INTERRUPT_ACK(INTERRUPT_ACK[1])
    );

    Processor processor(
        .CLK(CLK),
        .RESET(RESET),
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        .ROM_ADDRESS(ROM_ADDRESS),
        .ROM_DATA(ROM_DATA),
        .BUS_INTERRUPTS_RAISE(INTERRUPT_RAISE),
        .BUS_INTERRUPTS_ACK(INTERRUPT_ACK)
    );

    PS2_MOUSE mouse(
        .RESET(RESET),
        .CLK(CLK),
        .CLK_MOUSE(CLK_MOUSE),
        .DATA_MOUSE(DATA_MOUSE),
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        .MOUSE_INTERRUPT_RAISE(INTERRUPT_RAISE[0]),
        .MOUSE_INTERRUPT_ACK(INTERRUPT_ACK[0]),
        .DPI(DPI)
    );

    SevenSeg sevenseg(
        .CLK(CLK),
        .RESET(RESET),
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        .SEG_SELECT_OUT(SEG_SELECT_OUT),
        .HEX_OUT(HEX_OUT)
    );

    LEDs_Module led(
        .CLK(CLK),
        .RESET(RESET),
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        .LED_OUT(LEDS)
    );


endmodule
