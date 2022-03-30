`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.03.2022 00:32:23
// Design Name: 
// Module Name: Number_TB
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


module Number_TB(

    );
    
    reg [10:0] Time_RAM [86*86:0];
    initial $readmemb("Numbers_VGA_RAM.txt", Time_RAM);
    
    reg CLK=1;
    reg RESET=1;
    wire [9:0] ADDRH,ADDRV;
    wire HorzCountTriggOut;
    reg [9:0] out;
    Generic_counter # (.COUNTER_WIDTH(10),
                        .COUNTER_MAX(62)
                        )
                        HorzCounter(
                              .CLK(CLK),
                              .RESET(RESET),
                              .ENABLE(1'b1),
                              .TRIG_OUT(HorzCountTriggOut),
                              .COUNT(ADDRH)
                               );
    
        //Increment VCounter by one every clock cycle when HCounter is reseted. Range 0 to 520
        Generic_counter # (.COUNTER_WIDTH(9),
                          .COUNTER_MAX(87)
                          )
                          VertCounter(
                                .CLK(CLK),
                                .RESET(RESET),
                                .ENABLE(HorzCountTriggOut),
                                .COUNT(ADDRV)
                                );
         reg [12:0] ADDR=0;                        
         always@(posedge CLK) begin
            ADDR=ADDRV[8:0]*10'd62+ADDRH;
            out=Time_RAM[ADDR][0];
         end
         
       initial begin
                       forever #5 CLK = ~CLK;
                   end
        
               initial begin
                   #10 RESET=0;
               end
endmodule
