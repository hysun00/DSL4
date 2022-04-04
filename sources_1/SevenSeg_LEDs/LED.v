`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 15.03.2022 09:52:38
// Design Name:
// Module Name: LEDs_Module
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


module LED(
    input CLK,
    input RESET,
    inout [7:0] BUS_DATA,
    input [7:0] BUS_ADDR,
    input BUS_WE,
    output reg [15:0] LED_OUT
    );

    wire [7:0] BufferedBusData;
    reg [7:0] Out;
    reg LEDBusWE;

    //Only place data on the bus if the processor is NOT writing, and it is addressing this memory
    assign BUS_DATA = (LEDBusWE) ? Out : 8'hZZ;
    assign BufferedBusData = BUS_DATA;

    always @(posedge CLK) begin
        if(RESET)
            LED_OUT <= 0;
        else if(BUS_WE) begin
            case(BUS_ADDR)
                8'hC0: {LED_OUT[7:3],LED_OUT[1:0],LED_OUT[2]} <= BufferedBusData;
                8'hC1: LED_OUT[15:8] <= BufferedBusData;
            endcase
            LEDBusWE <= 1'b0;
        end
        else begin
            case(BUS_ADDR)
                8'hC0: begin
                    Out <= {LED_OUT[7:3],LED_OUT[1:0],LED_OUT[2]};
                    LEDBusWE <= 1'b1;
                end

                8'hC1: begin
                    Out <= LED_OUT[15:8];
                    LEDBusWE <= 1'b1;
                end

                default: LEDBusWE <= 1'b0;
            endcase
        end
    end
endmodule
