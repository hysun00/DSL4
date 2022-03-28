`timescale 1ns / 1ps

module VGA_Sig_Gen(
    input CLK, //25MHZ
    input RESET,
    //Colour Configuration Interface
    input [15:0] CONFIG_COLOURS,
    // Frame Buffer (Dual Port memory) Interface
    output DPR_CLK,
    output [14:0] VGA_ADDR,
    input VGA_DATA,
    //VGA Port Interface
    output reg VGA_HS,
    output reg VGA_VS,
    output [9:0] ADDRX,
    output [9:0] ADDRY,
    output reg [7:0] VGA_COLOUR
);

    //Times for different section
    parameter vdisp = 10'd480;
    parameter vfp   = 10'd490;
    parameter vpw   = 10'd492;
    parameter vbp   = 10'd521;

    parameter hdisp = 10'd640;
    parameter hfp   = 10'd656;
    parameter hpw   = 10'd752;
    parameter hbp   = 10'd800;

    //Horizontal and Vertical Counters to know which section we are in
    reg [9:0] HCounter = 0;
    reg [9:0] VCounter = 0;

     Generic_counter # (.COUNTER_WIDTH(2),
                    .COUNTER_MAX(3)
                    )
                    VGACounter (
                           .CLK(CLK),
                           .RESET(1'b0),     //never reset
                           .ENABLE(1'b1), //always enabled
                           .TRIG_OUT(DPR_CLK)
                           //.COUNT()
                           );

    //Increment HCounter by one every clock cycle. Range 0 to 799
    always@(posedge DPR_CLK) begin
        if(HCounter == 799) begin
            HCounter <= 0;
        end
        else
            HCounter <= HCounter + 1;
    end

    //Increment VCounter by one every clock cycle when HCounter is reseted. Range 0 to 520
    always@(posedge DPR_CLK) begin
        if(HCounter == 799) begin
            if(VCounter == 520)
                VCounter <= 0;
            else
                VCounter <= VCounter + 1;
        end
    end

	//VGA address to get data from frame buffer.
	//15 bits bus, MSB 7 bits are y axis and the rest is x axis
	//by not taking the LSB 2 bits of V and H Counter is equal to divide by 4
    assign VGA_ADDR = {VCounter[8:2], HCounter[9:2]};

	//Pulse width for HS & VS
    always @(posedge DPR_CLK) begin
        VGA_HS <= ~(HCounter > hfp && HCounter < hpw);
        VGA_VS <= ~(VCounter > vfp && VCounter < vpw);
    end

	//if H & V counter is in display section then show the correct colour else VGA_COLOUR = 0
	//correct display colour is control by VGA_DATA and CONFIG_COLOURS.
    always@(posedge DPR_CLK) begin
        if((HCounter < hdisp) && (VCounter < vdisp)) begin
            if(VGA_DATA == 1)
                VGA_COLOUR <= CONFIG_COLOURS[15:8];
            else
                VGA_COLOUR <= CONFIG_COLOURS[7:0];
        end
        else begin
            VGA_COLOUR <= 16'h00;
        end
    end

    assign ADDRX = HCounter;
    assign ADDRY = VCounter;
endmodule