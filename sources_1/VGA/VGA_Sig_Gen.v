`timescale 1ns / 1ps

module VGA_Sig_Gen(
    input CLK,
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
    output reg [9:0] ADDRH,
    output reg [9:0] ADDRV,
    output reg [7:0] VGA_COLOUR
);

    // Use the following signal parameters
    parameter HTs       = 800;  // Total Horizontal Sync Pulse Time
    parameter HTpw      = 96;   // Horizontal Pulse Width Time
    parameter HTDisp    = 640;  // Horizontal Display Time
    parameter Hbp       = 48;   // Horizontal Back Porch Time
    parameter Hfp       = 16;   // Horizontal Front Porch Time

    parameter VTs       = 521;  // Total Vertical Sync Pulse Time
    parameter VTpw      = 2;    // Vertical Pulse Width Time
    parameter VTDisp    = 480;  // Vertical Display Time
    parameter Vbp       = 29;   // Vertical Back Porch Time
    parameter Vfp       = 10;   // Vertical Front Porch Time

     //Vertical Lines Timeline
    parameter VertTimeToPulseWidthEnd  = 10'd2;
    parameter VertTimeToBackPorchEnd   = 10'd31;
    parameter VertTimeToDisplayTimeEnd = 10'd511;
    parameter VertTimeToFrontPorchEnd  = 10'd521;

    //Horizental Lines Timeline
    parameter HorzTimeToPulseWidthEnd  = 10'd96;
    parameter HorzTimeToBackPorchEnd   = 10'd144;
    parameter HorzTimeToDisplayTimeEnd = 10'd784;
    parameter HorzTimeToFrontPorchEnd  = 10'd800;


    //Horizontal and Vertical Counters to know which section we are in
    wire [9:0] HCounter,VCounter;
    wire HorzCountTriggOut;

     Generic_counter # (.COUNTER_WIDTH(2),
                    .COUNTER_MAX(3)
                    )
                    VGACounter (
                           .CLK(CLK),
                           .RESET(1'b0),     //never reset
                           .ENABLE(1'b1), //always enabled
                           .TRIG_OUT(DPR_CLK)
                           );

    //Increment HCounter by one every clock cycle. Range 0 to 799
    Generic_counter # (.COUNTER_WIDTH(10),
                    .COUNTER_MAX(799)
                    )
                    HorzCounter(
                          .CLK(CLK),
                          .RESET(RESET),
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
                            .RESET(RESET),
                            .ENABLE(HorzCountTriggOut),
                            .COUNT(VCounter)
                            );

	//VGA address to get data from frame buffer.
	//15 bits bus, MSB 7 bits are y axis and the rest is x axis
	//by not taking the LSB 2 bits of V and H Counter is equal to divide by 4
    assign VGA_ADDR = {ADDRV[8:2], ADDRH[9:2]};

	//Decide when the Horizontal Sync set high or low
    always@(posedge DPR_CLK) begin
        if (HCounter <= HorzTimeToPulseWidthEnd)
            VGA_HS <= 0;
        else
            VGA_HS <= 1;


    //Decide when the Vertical Sync set high or low

        if (VCounter <= VertTimeToPulseWidthEnd)
            VGA_VS <= 0;
        else
            VGA_VS <= 1;



     //Make the Vertical address increase at the same speed as the two counters

        if((VertTimeToBackPorchEnd < VCounter) && (VCounter <= VertTimeToDisplayTimeEnd))
           ADDRV <= VCounter- VertTimeToBackPorchEnd;
        else
           ADDRV <= 0;


     //Make the Horizontal address increase at the same speed as the two counters

        if ((HorzTimeToBackPorchEnd < HCounter) && (HCounter <= HorzTimeToDisplayTimeEnd))
            ADDRH <= HCounter-HorzTimeToBackPorchEnd;
       else
            ADDRH <= 0;


    /*
    Finally, tie the output of the frame buffer to the colour ouput VGA_COLOUR
    */
        if ((VertTimeToBackPorchEnd < VCounter) && (VCounter <= VertTimeToDisplayTimeEnd) && (HorzTimeToBackPorchEnd < HCounter) &&(HCounter <= HorzTimeToDisplayTimeEnd)) begin
            if(VGA_DATA)begin
                VGA_COLOUR <= CONFIG_COLOURS[15:8];
            end
            else begin
            VGA_COLOUR <= CONFIG_COLOURS[7:0];
            end
        end
        else
        VGA_COLOUR <=16'h00;


end
endmodule