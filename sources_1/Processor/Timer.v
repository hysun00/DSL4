`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: The University of Edinburgh
// Engineer:
//
// Create Date: 08.03.2022 17:03:26
// Design Name:
// Module Name: Timer
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


module Timer
(
//standard signals
    input CLK,
    input RESET,
//BUS signals
    inout  [7:0] BUS_DATA,
    input  [7:0] BUS_ADDR,
    input  BUS_WE,
    input  BUS_INTERRUPT_ACK,
    output BUS_INTERRUPT_RAISE
);

localparam [7:0] TimerBaseAddr   = 8'hF0;// Timer Base Address in the Memory Map
localparam InitialIterruptRate   = 100;  // Default interrupt rate leading to 1 interrupt every 1s
localparam InitialIterruptEnable = 1'b1; // By default the Interrupt is Enabled
//////////////////////
//BaseAddr + 0 -> reports current timer value
//BaseAddr + 1 -> Address of a timer interrupt interval register, 100 ms by default
//BaseAddr + 2 -> Resets the timer, restart counting from zero
//BaseAddr + 3 -> Address of an interrupt Enable register, allows the microprocessor to disable
 // the timer
//This module will raise an interrupt flag when the designated time is up. It will
//automatically set the time of the next interrupt to the time of the last interrupt plus
//a configurable value (in milliseconds).
//Interrupt Rate Configuration - The Rate is initialised to 100 by the parameter above, but can
//also be set by the processor by writing to mem address BaseAddr + 1;
reg [31:0] DownCounter;
reg [31:0] Timer;
reg [31:0] LastTime;
reg [7:0]  InterruptRate;
reg InterruptEnable;//Interrupt Enable Configuration - If this is not set to 1, no interrupts will becreated.
reg TargetReached;
reg TransmitTimerValue;
reg Interrupt;

//First we must lower the clock speed from 100MHz to 100Hz (10ms period)
always@(posedge CLK) begin
    if(RESET)
        DownCounter <= 0;
    else begin
        if(DownCounter == 32'd999999)
            DownCounter <= 0;
        else
            DownCounter <= DownCounter + 1'b1;
    end
end

//Tristate output for interrupt timer output value
always@(posedge CLK) begin
    if(BUS_ADDR == TimerBaseAddr)
        TransmitTimerValue <= 1'b1;
    else
        TransmitTimerValue <= 1'b0;
end

always@(posedge CLK) begin
    if(RESET)
        InterruptRate <= InitialIterruptRate;
    else if((BUS_ADDR == TimerBaseAddr + 8'h01) & BUS_WE)
        InterruptRate <= BUS_DATA;
end

//Now we can record the last time an interrupt was sent, and add a value to it to determine if it BUS_ADDR
// time to raise the interrupt.
// But first, let us generate the 10ms counter (Timer)
always@(posedge CLK) begin
    if(RESET | (BUS_ADDR == TimerBaseAddr + 8'h02))
        Timer <= 0;
    else begin
        if((DownCounter == 0))
            Timer <= Timer + 1'b1;
        else
            Timer <= Timer;
    end
end

always@(posedge CLK) begin
    if(RESET)
        InterruptEnable <= InitialIterruptEnable;
    else if((BUS_ADDR == TimerBaseAddr + 8'h03) & BUS_WE)
        InterruptEnable <= BUS_DATA[0];
end

//Interrupt generation
always@(posedge CLK) begin
    if(RESET) begin
        TargetReached <= 1'b0;
        LastTime <= 0;
    end
    else if((LastTime + InterruptRate) == Timer) begin
        if(InterruptEnable)
            TargetReached <= 1'b1;
        LastTime <= Timer;
    end
    else
        TargetReached <= 1'b0;
end

//Broadcast the Interrupt
always@(posedge CLK) begin
    if(RESET)
        Interrupt <= 1'b0;
    else if(TargetReached)
        Interrupt <= 1'b1;
    else if(BUS_INTERRUPT_ACK)
        Interrupt <= 1'b0;
end

assign BUS_DATA = (TransmitTimerValue) ? Timer[7:0] : 8'hZZ;
assign BUS_INTERRUPT_RAISE = Interrupt;

endmodule