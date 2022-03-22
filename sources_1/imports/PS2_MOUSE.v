`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Edinburgh
// Engineer: Yichen Zhang
//
// Create Date: 15.02.2022 11:16:36
// Design Name:
// Module Name: PS2_MOUSE
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

/*
    Top wrapper for PS/2 Mouse
    Extra features:
    1. Add support for scrolling wheel using Microsoft Intellimouse Extensions, seein in MouseMasterSM.v. By scrolling wheel, the result is displayed with the 8 MSB LEDs.
    2. Add support for changing the DPI by changing the result of MouseDxRaw and MouseDyRaw
*/
module PS2_MOUSE(input RESET,
                 input CLK,
                 inout CLK_MOUSE,
                 inout DATA_MOUSE,
                 inout [7:0] BUS_DATA,
                 input [7:0] BUS_ADDR,
                 input BUS_WE,
                 output reg MOUSE_INTERRUPT_RAISE,
                 input MOUSE_INTERRUPT_ACK,
                 input [1:0] DPI   // Change DPI using the 2 LSB switches
                 );

    wire [7:0] MouseX,MouseY;
    wire [3:0] MouseStatus;  // Display Mouse status using the 4 LSB LEDs,
                             // The order from MSB to LSB is: Initialized, Left click, middle click and right click
    wire [7:0] LED_Scroll;   // Display the mouse wheel using the 8 MSB LEDs
    wire MouseInterrupt;

    MouseTransceiver PS2(
        .RESET(RESET),
        .CLK(CLK),
        .CLK_MOUSE(CLK_MOUSE),
        .DATA_MOUSE(DATA_MOUSE),
        .DPI(DPI),
        .SendInterrupt(MouseInterrupt),
        .MouseStatus(MouseStatus),
        .MouseX(MouseX),
        .MouseY(MouseY),
        .MouseZ(LED_Scroll)
    );

     // The below part is for data bus reading and writing
    reg [7:0] Out;
    reg MOUSEBusWE;

    //Only place data on the bus if the processor is NOT writing, and it is addressing this memory
    assign BUS_DATA = (MOUSEBusWE) ? Out : 8'hZZ;

    always @(posedge CLK) begin
        if(BUS_WE) begin    // Write
            case(BUS_ADDR)
                8'hA0: MouseStatus <= BufferedBusData;
                8'hA1: MouseX <= BufferedBusData;
                8'hA2: MouseY <= BufferedBusData;
            endcase
            MOUSEBusWE <= 1'b0;
        end
        else begin  // Read
            case(BUS_ADDR)
                8'hA0: begin
                    Out <= MouseStatus;
                    MOUSEBusWE <= 1'b1;
                end

                8'hA1: begin
                    Out <= MouseX;
                    MOUSEBusWE <= 1'b1;
                end

                8'hA2: begin
                    Out <= MouseY;
                    MOUSEBusWE <= 1'b1;
                end

                8'hA3: begin
                    Out <= LED_Scroll;
                    MOUSEBusWE <= 1'b1;
                end

                default: MOUSEBusWE <= 1'b0;
            endcase
        end
    end

    // This part is for mouse interrupt send and receive
    always @(posedge CLK) begin
        if (RESET)
            MOUSE_INTERRUPT_RAISE <= 1'b0;
        else if (MouseInterrupt)    // Mouse interrupt generated
            MOUSE_INTERRUPT_RAISE <= 1'b1;
        else if (MOUSE_INTERRUPT_ACK)   // Mouse interrupt acknowledge received
            MOUSE_INTERRUPT_RAISE <= 1'b0;
    end

endmodule
