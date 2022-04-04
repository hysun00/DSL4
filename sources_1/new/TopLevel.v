`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: The University of Edinburgh
// Engineer: Haoyuan Sun
//
// Create Date: 09.03.2022 16:53:20
// Design Name:
// Module Name: TOP
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


module TOP (input CLK,
            input RESET,
            output IR_LED,
            output [7:0] DIGIT,
            output [3:0] SEL,
            inout CLK_MOUSE,
            inout DATA_MOUSE,
            input [15:0] SW,          // Change DPI using the 2 LSB switches
            output [15:0] LEDS,
            output VGA_HS,
            output VGA_VS,
            output [7:0] VGA_COLOUR);

/////////////////////////////////////////////////////////////////////////////////////Internal  Signals/////////////////////////////////////////////////////////////////////////////////////
    wire bus_write_en;
    wire [1:0] bus_interrupts_raise;
    wire [1:0] bus_interrupts_ack;
    wire [7:0] bus_data;
    wire [7:0] bus_addr;
    wire [7:0] instruction_mem_addr;
    wire [7:0] instruction_mem_data;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////CPU////////////////////////////////////////////////////////////////////////////////////////////
    Processor CPU (
        .CLK                 (CLK),
        .RESET               (RESET),
        .BUS_DATA            (bus_data),            // Exclusive data bus.
        .BUS_ADDR            (bus_addr),            // Address the data memory(i.e. RAM) and I/O devices.
        .BUS_WE              (bus_write_en),        // Enable writing.
        .ROM_ADDRESS         (instruction_mem_addr),// Address the instruction memory(i.e. ROM)
        .ROM_DATA            (instruction_mem_data),// Exclusive instruction bus
        .BUS_INTERRUPTS_RAISE(bus_interrupts_raise),
        .BUS_INTERRUPTS_ACK  (bus_interrupts_ack)
    );
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////Instruction  Memory/////////////////////////////////////////////////////////////////////////////////////
    ROM INSTRUCTION_MEM (
        .CLK (CLK),
        .ADDR(instruction_mem_addr),
        .DATA(instruction_mem_data)
    );
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////Data Memory////////////////////////////////////////////////////////////////////////////////////////
    RAM DATA_MEM (
        .CLK      (CLK),
        .BUS_DATA (bus_data),
        .BUS_ADDR (bus_addr),   // Address the data memory(i.e. RAM)
        .BUS_WE   (bus_write_en)// Enable writing data to RAM.
    );
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////Timer///////////////////////////////////////////////////////////////////////////////////////////
    Timer U_Timer (
        .CLK                 (CLK),
        .RESET               (RESET),
        .BUS_DATA            (bus_data),            // Exclusive data bus.
        .BUS_ADDR            (bus_addr),            // Address the timer
        .BUS_WE              (bus_write_en),        // Enable writing to timer.
        .BUS_INTERRUPT_RAISE (bus_interrupts_raise[0]),
        .BUS_INTERRUPT_ACK   (bus_interrupts_ack[0])
    );
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////IR  Transmitter//////////////////////////////////////////////////////////////////////////////////////
    IRTransmitter U_IRTransmitter (
        .CLK      (CLK),
        .RESET    (RESET),
        .BUS_WE   (bus_write_en),
        .BUS_DATA (bus_data),
        .BUS_ADDR (bus_addr),
        .IR_LED   (IR_LED)
    );
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    PS2_MOUSE mouse(
        .RESET(RESET),
        .CLK(CLK),
        .CLK_MOUSE(CLK_MOUSE),
        .DATA_MOUSE(DATA_MOUSE),
        .BUS_DATA(bus_data),
        .BUS_ADDR(bus_addr),
        .BUS_WE(bus_write_en),
        .MOUSE_INTERRUPT_RAISE(bus_interrupts_raise[1]),
        .MOUSE_INTERRUPT_ACK(bus_interrupts_ack[1]),
        .DPI(SW[1:0])
    );

    SevenSeg U_SevenSeg (
        .CLK      (CLK),
        .RESET    (RESET),
        .BUS_DATA (bus_data),
        .BUS_ADDR (bus_addr),
        .BUS_WE   (bus_write_en),
        .SEL      (SEL),
        .DIGIT    (DIGIT)
    );

    LED led(
        .CLK(CLK),
        .RESET(RESET),
        .BUS_DATA(bus_data),
        .BUS_ADDR(bus_addr),
        .BUS_WE(bus_write_en),
        .LED_OUT(LEDS)
    );

    VGA_Controller VGA (
        .CLK(CLK),
        .RESET(RESET),
        .BUS_DATA(bus_data),
        .BUS_ADDR(bus_addr),
        .BUS_WE(bus_write_en),
        .BACKFORE(SW[2]),
        .VGA_COLOUR(VGA_COLOUR),
        .VGA_HS(VGA_HS),
        .VGA_VS(VGA_VS)
    );

endmodule
