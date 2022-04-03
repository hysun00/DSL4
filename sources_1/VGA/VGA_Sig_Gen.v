`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01.04.2022 10:53:26
// Design Name:
// Module Name: VGA_Sig_Gen
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

module VGA_Sig_Gen(input CLK,
                   input RESET,
                   input [15:0] CONFIG_COLOURS,
                   output DPR_CLK,
                   output [14:0] VGA_ADDR,
                   input VGA_DATA,
                   output reg VGA_HS,
                   output reg VGA_VS,
                   output reg [9:0] ADDRH,
                   output reg [9:0] ADDRV,
                   output reg [7:0] VGA_COLOUR);

    // Use the following signal parameters
    localparam HTs    = 800;  // Total Horizontal Sync Pulse Time
    localparam HTpw   = 96;   // Horizontal Pulse Width Time
    localparam HTDisp = 640;  // Horizontal Display Time
    localparam Hbp    = 48;   // Horizontal Back Porch Time
    localparam Hfp    = 16;   // Horizontal Front Porch Time

    localparam VTs    = 521;  // Total Vertical Sync Pulse Time
    localparam VTpw   = 2;    // Vertical Pulse Width Time
    localparam VTDisp = 480;  // Vertical Display Time
    localparam Vbp    = 29;   // Vertical Back Porch Time
    localparam Vfp    = 10;   // Vertical Front Porch Time

    // Vertical Lines Timeline
    localparam VertTimeToPulseWidthEnd  = 10'd2;
    localparam VertTimeToBackPorchEnd   = 10'd31;
    localparam VertTimeToDisplayTimeEnd = 10'd511;
    localparam VertTimeToFrontPorchEnd  = 10'd521;

    // Horizental Lines Timeline
    localparam HorzTimeToPulseWidthEnd  = 10'd96;
    localparam HorzTimeToBackPorchEnd   = 10'd144;
    localparam HorzTimeToDisplayTimeEnd = 10'd784;
    localparam HorzTimeToFrontPorchEnd  = 10'd800;


    //Horizontal and Vertical Counters to know which section we are in
    wire [9:0] HCounter,VCounter;
    wire HorzCountTriggOut;

    Generic_counter # (.COUNTER_WIDTH(2),
                        .COUNTER_MAX(3)
                        )
                        VGA_CLK (
                        .CLK(CLK),
                        .RESET(1'b0),
                        .ENABLE(1'b1),
                        .TRIG_OUT(DPR_CLK)
                        );

    //Increment HCounter by one every clock cycle. Range 0 to 799
    Generic_counter # (.COUNTER_WIDTH(10),
                        .COUNTER_MAX(799)
                        )
                        HorzCounter(
                        .CLK(CLK),
                        .RESET(1'b0),
                        .ENABLE(DPR_CLK),
                        .TRIG_OUT(HorzCountTriggOut),
                        .COUNT(HCounter)
                        );

    //Increment VCounter by one every clock cycle when HCounter is reseted. Range 0 to 520
    Generic_counter # (.COUNTER_WIDTH(10),
                        .COUNTER_MAX(520)
                        )
                        VertCounter(
                        .CLK(CLK),
                        .RESET(1'b0),
                        .ENABLE(HorzCountTriggOut),
                        .COUNT(VCounter)
                        );

    //VGA address to get data from frame buffer.
    //15 bits bus, MSB 7 bits are y axis and the rest is x axis
    //by not taking the LSB 2 bits of V and H Counter is equal to divide by 4
    assign VGA_ADDR = {ADDRV[8:2], ADDRH[9:2]};


    always@(posedge DPR_CLK) begin
        // Decide the Horizontal Sync signal
        if (HCounter <= HorzTimeToPulseWidthEnd)
            VGA_HS <= 0;
        else
            VGA_HS <= 1;

        // Decide the Vertical Sync signal
        if (VCounter <= VertTimeToPulseWidthEnd)
            VGA_VS <= 0;
        else
            VGA_VS <= 1;

        // Generate the correct y address
        if ((VertTimeToBackPorchEnd < VCounter) && (VCounter <= VertTimeToDisplayTimeEnd))
            ADDRV <= VCounter- VertTimeToBackPorchEnd;
        else
            ADDRV <= 0;

        // Generate the correct x address
        if ((HorzTimeToBackPorchEnd < HCounter) && (HCounter <= HorzTimeToDisplayTimeEnd))
            ADDRH <= HCounter-HorzTimeToBackPorchEnd;
        else
            ADDRH <= 0;

        /*
         Finally, tie the output of the frame buffer to the colour ouput VGA_COLOUR
         */
        //if H & V counter is in display section then show the correct colour else VGA_COLOUR = 0
	    //correct display colour is control by VGA_DATA and CONFIG_COLOURS.
        if ((VertTimeToBackPorchEnd < VCounter) && (VCounter <= VertTimeToDisplayTimeEnd) && (HorzTimeToBackPorchEnd < HCounter) &&(HCounter <= HorzTimeToDisplayTimeEnd)) begin
            if (VGA_DATA)begin
                VGA_COLOUR <= CONFIG_COLOURS[15:8];
            end
            else begin
                VGA_COLOUR <= CONFIG_COLOURS[7:0];
            end
        end
        else
            VGA_COLOUR <= 16'h00;
    end

endmodule
