`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 28.02.2022 23:26:39
// Design Name:
// Module Name: PS2_Display
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


module PS2_Display(
    input CLK,
    inout [7:0] BUS_DATA,
    input [7:0] BUS_ADDR,
    input BUS_WE,
    input [7:0] MouseX,
    input [7:0] MouseY,
    input [15:0] LED_IN,
    output reg [15:0] LED_OUT,
    output [3:0] SEG_SELECT_OUT,
    output [7:0] HEX_OUT
    );

    wire [1:0] SEG_SELECT_IN;
    wire [4:0] MuxOut;
    wire Bit17TriggerOut;

    Generic_counter # (.COUNTER_WIDTH(17),
                        .COUNTER_MAX(99999)
                        )
                        Bit17Counter (
                        .CLK(CLK),
                        .RESET(1'b0),
                        .ENABLE(1'b1),
                        .TRIG_OUT(Bit17TriggerOut)
                        );

    Generic_counter # (.COUNTER_WIDTH(2),
                        .COUNTER_MAX(3)
                        )
                        Bit2Counter (
                        .CLK(CLK),
                        .ENABLE(Bit17TriggerOut),
                        .COUNT(SEG_SELECT_IN)
                        );

    Multiplexer_4way Mux4 (
        .CONTROL(SEG_SELECT_IN),
        .IN0({1'b0,MouseY[3:0]}),
        .IN1({1'b0,MouseY[7:4]}),
        .IN2({1'b1,MouseX[3:0]}),
        .IN3({1'b0,MouseX[7:4]}),
        .OUT(MuxOut)
        );

    Seg7Display Display (
        .SEG_SELECT_IN(SEG_SELECT_IN),
        .BIN_IN(MuxOut[3:0]),
        .DOT_IN(MuxOut[4]),
        .SEG_SELECT_OUT(SEG_SELECT_OUT),
        .HEX_OUT(HEX_OUT)
        );

    wire [7:0] BufferedBusData;
    reg [7:0] Out;
    reg MOUSEBusWE;

    //Only place data on the bus if the processor is NOT writing, and it is addressing this memory
    assign BUS_DATA = (MOUSEBusWE) ? Out : 8'hZZ;
    assign BufferedBusData = BUS_DATA;

    always @(posedge CLK) begin
        if(BUS_WE) begin
            case(BUS_ADDR)
                8'hC0: LED_OUT <= BufferedBusData;
                8'hD0: MouseX <= BufferedBusData;
                8'hD1: MouseY <= BufferedBusData;
            endcase
            MOUSEBusWE <= 1'b0;
        end
        else begin
            case(BUS_ADDR)
                8'hC0: begin
                    Out <= LED_IN;
                    MOUSEBusWE <= 1'b1;
                end

                8'hD0: begin
                    Out <= MouseX;
                    MOUSEBusWE <= 1'b1;
                end

                8'hD1: begin
                    Out <= MouseY;
                    MOUSEBusWE <= 1'b1;
                end

                default: MOUSEBusWE <= 1'b0;
            endcase
        end
    end

endmodule
