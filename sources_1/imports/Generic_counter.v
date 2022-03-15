`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/26 05:25:55
// Design Name: 
// Module Name: Generic_counter
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


module Generic_counter(
          CLK,
          RESET,
          ENABLE,
          DIRECTION,
          TRIG_OUT,
          COUNT
    );
    
    parameter COUNTER_WIDTH = 4;
    parameter COUNTER_MAX = 9;
    
    input CLK;
    input RESET;
    input ENABLE;
    input DIRECTION;
    output TRIG_OUT;
    output [COUNTER_WIDTH-1:0] COUNT;
    
    // Declare registers that hold the current count value and trigger out
    // between clock cycles
    reg [COUNTER_WIDTH-1:0] count_value;
    reg Trigger_out;
    
    // Synchronous logic for value of count_value
    always@(posedge CLK) begin
        if(RESET)
            count_value <= 0;
        else begin
            if(ENABLE) begin
                if(DIRECTION) begin
                    if(count_value == 0)
                        count_value <= COUNTER_MAX;
                    else
                        count_value <= count_value - 1;
                end
                else begin
                    if(count_value == COUNTER_MAX)
                        count_value <= 0;
                    else
                        count_value <= count_value + 1;
                end
            end
        end
    end
    
    // Synchronous logic for Trigger_out
    always@(posedge CLK) begin
        if(RESET)
            Trigger_out <= 0;
        else begin
            if(DIRECTION) begin
                if(ENABLE && (count_value == 0))
                    Trigger_out <= 1;
                else 
                    Trigger_out <= 0;
            end
            else begin
                if(ENABLE && (count_value == COUNTER_MAX))
                    Trigger_out <= 1;
                else 
                    Trigger_out <= 0;
            end
        end
    end        
    
    // Assignment that tie the count_value and Trigger_out to
    // COUNT and TRIG_OUT respectively
    assign COUNT = count_value;
    assign TRIG_OUT = Trigger_out;
        
endmodule
