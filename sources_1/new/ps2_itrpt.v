`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 13.03.2022 17:48:03
// Design Name:
// Module Name: ps2_itrpt
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


module ps2_itrpt(
    input CLK,
    input RESET,
    output BUS_INTERRUPT_RAISE,
    input BUS_INTERRUPT_ACK,
    input BUS_WE,
    inout [7:0] BUS_DATA,
    input [7:0] BUS_ADDR
    );

    reg [31:0] DownCounter;
    always@(posedge CLK) begin
        if (RESET)
            DownCounter <= 0;
        else begin
            if (DownCounter == 32'd9)
                DownCounter <= 0;
            else
                DownCounter <= DownCounter + 1'b1;
        end
    end

    reg [31:0] Timer;
    always@(posedge CLK) begin
        if (RESET)
            Timer <= 0;
        else begin
            if ((DownCounter == 0))
                Timer <= Timer + 1'b1;
            else
                Timer <= Timer;
        end
    end

    reg TargetReached;
    reg InterruptEnable = 1;
    reg [31:0] LastTime;
    reg [7:0] InterruptRate = 9;
    always@(posedge CLK) begin
        if (RESET) begin
            TargetReached <= 1'b0;
            LastTime      <= 0;
        end
        else if ((LastTime + InterruptRate) == Timer) begin
            if (InterruptEnable)
                TargetReached <= 1'b1;

            LastTime      <= Timer;
        end
        else
            TargetReached <= 1'b0;
    end

    reg Interrupt;
    always@(posedge CLK) begin
        if (RESET)
            Interrupt <= 1'b0;
        else if (TargetReached)
            Interrupt <= 1'b1;
        else if (BUS_INTERRUPT_ACK)
            Interrupt <= 1'b0;
    end

    assign BUS_INTERRUPT_RAISE = Interrupt;

    reg [7:0] Out;
    reg MOUSEBusWE;

    //Only place data on the bus if the processor is NOT writing, and it is addressing this memory
    assign BUS_DATA = (MOUSEBusWE) ? Out : 8'hZZ;

    always @(posedge CLK) begin
        if(BUS_WE)
            MOUSEBusWE <= 1'b0;
        else begin
            case(BUS_ADDR)
                8'hA0: begin
                    Out <= 8'hA0;
                    MOUSEBusWE <= 1'b1;
                end

                8'hA1: begin
                    Out <= 8'hA2;
                    MOUSEBusWE <= 1'b1;
                end

                8'hA2: begin
                    Out <= 8'hA2;
                    MOUSEBusWE <= 1'b1;
                end

                default: MOUSEBusWE <= 1'b0;
            endcase
        end
    end

endmodule
