`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Edinburgh
// Engineer: Yichen Zhang
//
// Create Date: 15.03.2022 10:22:08
// Design Name:
// Module Name: SevenSeg
// Project Name:
// Target Devices:
// Tool Versions:
// Description: Seven segment display
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module SevenSeg(
    input CLK,
    input RESET,
    inout [7:0] BUS_DATA,
    input [7:0] BUS_ADDR,
    input BUS_WE,
    output [3:0] SEG_SELECT_OUT,
    output [7:0] HEX_OUT
    );

    reg [7:0] MouseX, MouseY;   // Mouse addresses
    wire [1:0] SEG_SELECT_IN;
    wire [4:0] MuxOut;
    wire Bit17TriggerOut;

    // Downsample the clock to 1kHz
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


    // The below part is for data bus reading and writing
    wire [7:0] BufferedBusData;
    reg [7:0] Out;
    reg SevenSegBusWE;

    //Only place data on the bus if the processor is NOT writing, and it is addressing this memory
    assign BUS_DATA = (SevenSegBusWE) ? Out : 8'hZZ;
    assign BufferedBusData = BUS_DATA;

    always @(posedge CLK) begin
        if(RESET) begin
            MouseX <= 0;
            MouseY <= 0;
        end
        else if(BUS_WE) begin   // Write
            case(BUS_ADDR)
                8'hD0: MouseX <= BufferedBusData;
                8'hD1: MouseY <= BufferedBusData;
            endcase
            SevenSegBusWE <= 1'b0;
        end
        else begin  // Read
            case(BUS_ADDR)
                8'hD0: begin
                    Out <= MouseX;
                    SevenSegBusWE <= 1'b1;
                end

                8'hD1: begin
                    Out <= MouseY;
                    SevenSegBusWE <= 1'b1;
                end

                default: SevenSegBusWE <= 1'b0;
            endcase
        end
    end

endmodule
