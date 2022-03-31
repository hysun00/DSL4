`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2022 00:04:15
// Design Name: 
// Module Name: TopLevel
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


module TopLevel
(
    inout  CLK_MOUSE,
    inout  DATA_MOUSE,
    input  CLK,
    input  RESET,
    input  [1:0] DPI,    
    output IR_LED, 
    output VGA_HS,
    output VGA_VS,
    output [3:0] SEL,
    output [7:0] DIGIT, 
    output [7:0] VGA_COLOUR,
    output [15:0] LEDS                  
);
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
Processor
CPU
(
    .CLK                 (CLK),
    .RESET               (RESET),
    .BUS_DATA            (bus_data),            
    .BUS_ADDR            (bus_addr),            
    .BUS_WE              (bus_write_en),        
    .ROM_ADDRESS         (instruction_mem_addr), 
    .ROM_DATA            (instruction_mem_data),
    .BUS_INTERRUPTS_RAISE(bus_interrupts_raise),
    .BUS_INTERRUPTS_ACK  (bus_interrupts_ack)
);
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////Instruction  Memory/////////////////////////////////////////////////////////////////////////////////////
ROM
INSTRUCTION_MEM
(
    .CLK (CLK),
    .ADDR(instruction_mem_addr),
    .DATA(instruction_mem_data)
);
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////Data Memory////////////////////////////////////////////////////////////////////////////////////////
RAM
DATA_MEM
(
    .CLK      (CLK),
    .BUS_DATA (bus_data),   
    .BUS_ADDR (bus_addr),   
    .BUS_WE   (bus_write_en)
);
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////Timer///////////////////////////////////////////////////////////////////////////////////////////
// Timer should have the service priority
Timer
U_Timer
(
    .CLK                 (CLK),
    .RESET               (RESET),
    .BUS_DATA            (bus_data),            
    .BUS_ADDR            (bus_addr),            
    .BUS_WE              (bus_write_en),        
    .BUS_INTERRUPT_RAISE (bus_interrupts_raise[0]),
    .BUS_INTERRUPT_ACK   (bus_interrupts_ack[0])
);
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////Mouse///////////////////////////////////////////////////////////////////////////////////////////
// Mouse interruption will be served only if timer doesnot request one.
PS2_MOUSE
U_PS2_MOUSE
(
    .CLK                  (CLK),
    .RESET                (RESET),
    .BUS_DATA             (bus_data),            
    .BUS_ADDR             (bus_addr),     
    .BUS_WE               (bus_write_en),
    .MOUSE_INTERRUPT_RAISE(bus_interrupts_raise[1]),
    .MOUSE_INTERRUPT_ACK  (bus_interrupts_ack[1]),
    .CLK_MOUSE            (CLK_MOUSE),
    .DATA_MOUSE           (DATA_MOUSE),
    .DPI                  (DPI)
);
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////VGA////////////////////////////////////////////////////////////////////////////////////////////
VGA_Controller 
U_VGA_Controller
(
        .CLK       (CLK),
        .RESET     (RESET),
        .BUS_DATA  (bus_data),
        .BUS_ADDR  (bus_addr),
        .BUS_WE    (bus_write_en),
        .VGA_COLOUR(VGA_COLOUR),
        .VGA_HS    (VGA_HS),
        .VGA_VS    (VGA_VS)
);
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    
//////////////////////////////////////////////////////////////////////////////////////IR  Transmitter//////////////////////////////////////////////////////////////////////////////////////
IRTransmitter
U_IRTransmitter
(
    .CLK      (CLK),
    .RESET    (RESET),
    .BUS_DATA (bus_data),            
    .BUS_ADDR (bus_addr), 
    .BUS_WE   (bus_write_en),
    .IR_LED   (IR_LED)
);
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////Seven Segment///////////////////////////////////////////////////////////////////////////////////////
SevenSeg
U_SevenSeg
(
    .CLK      (CLK),
    .RESET    (RESET),
    .BUS_DATA (bus_data),            
    .BUS_ADDR (bus_addr),
    .BUS_WE   (bus_write_en),     
    .SEL      (SEL),
    .DIGIT    (DIGIT) 
);
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////VGA////////////////////////////////////////////////////////////////////////////////////////////
LEDs_Module 
U_LEDs_Module 
(
    .CLK(CLK),
    .RESET(RESET),
    .BUS_DATA(bus_data),
    .BUS_ADDR(bus_addr),
    .BUS_WE(bus_write_en),
    .LED_OUT(LEDS)
);
////////////////////////////////////////////////////////////////////////////////////////////VGA////////////////////////////////////////////////////////////////////////////////////////////
endmodule
