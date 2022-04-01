`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01.04.2022 10:53:26
// Design Name:
// Module Name: VGA_Time
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


module VGA_Time(
    input CLK,
    input RESET,
    input [7:0] BUS_ADDR,
    input BUS_WE,
    input [9:0] ADDRH,
    input [9:0] ADDRV,
    input B_DATA,
    output reg VGA_DATA
    );

    localparam [9:0] number_height = 10'd44;
    localparam [9:0] number_width = 10'd31;
    localparam [9:0] number_startx = 10'd238;
    localparam [9:0] number_starty = 10'd218;

    reg [10:0] Time_RAM [number_height * number_width - 1:0];

    reg [9:0] numberx, numbery;
    reg [12:0] number_addr;
    wire [3:0] min0,sec0;
    wire [2:0] min1,sec1;
    wire SEC0, SEC1, MIN0;
    wire sec_en;

    initial $readmemb("Numbers_VGA_RAM.txt", Time_RAM);


    Generic_counter # (.COUNTER_WIDTH(4),
                        .COUNTER_MAX(9)
                        )
                        Bit4Counter (
                        .CLK(CLK),
                        .RESET(RESET),
                        .ENABLE(sec_en),
                        .COUNT(sec0),
                        .TRIG_OUT(SEC0)
                        );
    Generic_counter # (.COUNTER_WIDTH(3),
                        .COUNTER_MAX(5)
                        )
                        Bit3Counter (
                        .CLK(CLK),
                        .RESET(RESET),
                        .ENABLE(SEC0),
                        .COUNT(sec1),
                        .TRIG_OUT(SEC1)
                        );
    Generic_counter # (.COUNTER_WIDTH(4),
                        .COUNTER_MAX(9)
                        )
                        Bit4Counter2 (
                        .CLK(CLK),
                        .RESET(RESET),
                        .ENABLE(SEC1),
                        .COUNT(min0),
                        .TRIG_OUT(MIN0)
                        );

    Generic_counter # (.COUNTER_WIDTH(3),
                        .COUNTER_MAX(5)
                        )
                        Bit3Counter2 (
                        .CLK(CLK),
                        .RESET(RESET),
                        .ENABLE(MIN0),
                        .COUNT(min1)
                        );

    always@(posedge CLK) begin
        if(ADDRH >= number_startx + number_width * 4 && ADDRH < number_startx + number_width * 5 && ADDRV >= number_starty && ADDRV < number_starty + number_height) begin
            numberx <= ADDRH - (number_startx + number_width * 4);
            numbery <= ADDRV - number_starty;
            number_addr = numbery * number_width + numberx;

            VGA_DATA=Time_RAM[number_addr][sec0];
        end
        else if(ADDRH >= number_startx + number_width * 3 && ADDRH < number_startx + number_width * 4 && ADDRV >= number_starty && ADDRV < number_starty + number_height) begin
            numberx <= ADDRH - (number_startx + number_width * 3);
            numbery <= ADDRV - number_starty;
            number_addr = numbery * number_width + numberx;

            VGA_DATA=Time_RAM[number_addr][sec1];
        end
        else if(ADDRH >= number_startx + number_width * 2 && ADDRH < number_startx + number_width * 3 && ADDRV >= number_starty && ADDRV < number_starty + number_height) begin
            numberx <= ADDRH-(number_startx + number_width * 2);
            numbery <= ADDRV - number_starty;
            number_addr = numbery * number_width + numberx;

            VGA_DATA=Time_RAM[number_addr][10];
        end
        else if(ADDRH >= number_startx + number_width * 1 && ADDRH < number_startx + number_width * 2 && ADDRV >= number_starty && ADDRV < number_starty + number_height) begin
            numberx <= ADDRH-(number_startx + number_width * 1);
            numbery <= ADDRV - number_starty;
            number_addr = numbery * number_width + numberx;

            VGA_DATA = Time_RAM[number_addr][min0];
        end
        else if(ADDRH >= number_startx + number_width * 0 && ADDRH < number_startx + number_width * 1 && ADDRV >= number_starty && ADDRV < number_starty + number_height) begin
            numberx <= ADDRH-(number_startx + number_width * 0);
            numbery <= ADDRV - number_starty;
            number_addr = numbery * number_width + numberx;

            VGA_DATA = Time_RAM[number_addr][min1];
        end
        else
            VGA_DATA <= B_DATA;
    end

    reg Addr_Hit;
    always@(posedge CLK) begin
        if(BUS_WE && BUS_ADDR == 8'hB4)
            Addr_Hit <= 1'b1;
        else
            Addr_Hit <= 1'b0;
    end

    EdgeDetector totime (
        .CLK(CLK),
        .RESET(RESET),
        .ORIGINAL(Addr_Hit),
        .SAMPLED(sec_en)
    );

endmodule