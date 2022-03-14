`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: The University of Edinburgh
// Engineer: Haoyuan SUn
// 
// Create Date: 08.02.2022 01:47:58 
// Design Name: 
// Module Name: IR_TRANSMITTER_SM
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

module IRTransmitterSM
#(
 // Yellow car
    parameter START_BURST_SIZE      = 88,
    parameter CAR_SELECT_BURST_SIZE = 22,
    parameter GAP_SIZE              = 40,
    parameter ASSERT_BURST_SIZE     = 44,
    parameter DEASSERT_BURST_SIZE   = 22,
    parameter COUNTER_WIDTH         = 12
)
(
 // INPUT
    input RESET,
    input CLK,
    input SEND_PACKET,
    input [3:0] COMMAND,
 // OUTPUT   
    output IR_LED,
    output reg CARRIER_EN
);

// Internal signals
reg [2:0] curr_state;
reg [2:0] next_state;
reg [COUNTER_WIDTH-1:0] curr_count;

// *****************************
// Define the states set  
// States are encoded by gray code
// *****************************
localparam IDLE       = 3'b000;
localparam START      = 3'b001;
localparam CAR_SELECT = 3'b011;
localparam RIGHT      = 3'b010;
localparam LEFT       = 3'b110;
localparam BACKWARD   = 3'b111;
localparam FORWARD    = 3'b101;
// *****************************

// *****************************
//  Pulse counter
// *****************************
always@(posedge CLK) 
    if (curr_state == IDLE) curr_count <= 0;           
    else curr_count <= curr_count + 1;                
// *****************************

// *****************************
//  State regiters  
// *****************************
 always@(posedge CLK) 
    if(RESET == 1'b1) curr_state <= IDLE;
    else curr_state <= next_state;    
// *****************************

// *****************************
//  State transition logic  
// *****************************
always@(*) 
    case(curr_state)
        IDLE:       if (SEND_PACKET == 1'b1) next_state = START; 
                    else next_state = curr_state;
                               
        START:      if (curr_count == START_BURST_SIZE + GAP_SIZE) next_state = CAR_SELECT;           
                    else next_state = curr_state;            
                                  
        CAR_SELECT: if (curr_count == START_BURST_SIZE + GAP_SIZE + CAR_SELECT_BURST_SIZE + GAP_SIZE) 
                        next_state = RIGHT;
                    else next_state = curr_state;
                                                      
        RIGHT:      if (curr_count == START_BURST_SIZE + GAP_SIZE + CAR_SELECT_BURST_SIZE + GAP_SIZE
                                      + ASSERT_BURST_SIZE -(~|COMMAND[0]*DEASSERT_BURST_SIZE) + GAP_SIZE)                             
                        next_state = LEFT;
                    else next_state = curr_state;  
                        
        LEFT:       if (curr_count == START_BURST_SIZE + GAP_SIZE + CAR_SELECT_BURST_SIZE + GAP_SIZE
                                      + ASSERT_BURST_SIZE -(~|COMMAND[0]*DEASSERT_BURST_SIZE) + GAP_SIZE 
                                      + ASSERT_BURST_SIZE -(~|COMMAND[1]*DEASSERT_BURST_SIZE) + GAP_SIZE)           
                        next_state = BACKWARD;
                    else next_state = curr_state;
                                       
        BACKWARD:   if (curr_count == START_BURST_SIZE + GAP_SIZE + CAR_SELECT_BURST_SIZE + GAP_SIZE
                                      + ASSERT_BURST_SIZE -(~|COMMAND[0]*DEASSERT_BURST_SIZE) + GAP_SIZE 
                                      + ASSERT_BURST_SIZE -(~|COMMAND[1]*DEASSERT_BURST_SIZE) + GAP_SIZE 
                                      + ASSERT_BURST_SIZE -(~|COMMAND[2]*DEASSERT_BURST_SIZE) + GAP_SIZE)           
                        next_state = FORWARD;
                    else next_state = curr_state;
                                               
        FORWARD:    if (curr_count == START_BURST_SIZE + GAP_SIZE + CAR_SELECT_BURST_SIZE + GAP_SIZE
                                      + ASSERT_BURST_SIZE -(~|COMMAND[0]*DEASSERT_BURST_SIZE) + GAP_SIZE 
                                      + ASSERT_BURST_SIZE -(~|COMMAND[1]*DEASSERT_BURST_SIZE) + GAP_SIZE 
                                      + ASSERT_BURST_SIZE -(~|COMMAND[2]*DEASSERT_BURST_SIZE) + GAP_SIZE 
                                      + ASSERT_BURST_SIZE -(~|COMMAND[3]*DEASSERT_BURST_SIZE) + GAP_SIZE)          
                        next_state = IDLE;
                    else next_state = curr_state;
                                                      
        default: next_state = IDLE;          
    endcase
// *****************************

// *****************************
//  Mealy output Logic 
// *****************************
always@(*)
    case(curr_state)
        IDLE:       CARRIER_EN = 1'b0;
                               
        START:      if (curr_count <= START_BURST_SIZE ) CARRIER_EN = 1'b1;           
                    else CARRIER_EN = 1'b0;           
                                  
        CAR_SELECT: if (curr_count <= START_BURST_SIZE + GAP_SIZE + CAR_SELECT_BURST_SIZE) 
                        CARRIER_EN = 1'b1; 
                    else CARRIER_EN = 1'b0; 
                                                      
        RIGHT:      if (curr_count <= START_BURST_SIZE + GAP_SIZE + CAR_SELECT_BURST_SIZE + GAP_SIZE
                                      + ASSERT_BURST_SIZE -(~|COMMAND[0]*DEASSERT_BURST_SIZE) )                             
                        CARRIER_EN = 1'b1;
                    else CARRIER_EN = 1'b0;
                        
        LEFT:       if (curr_count <= START_BURST_SIZE + GAP_SIZE + CAR_SELECT_BURST_SIZE + GAP_SIZE
                                      + ASSERT_BURST_SIZE -(~|COMMAND[0]*DEASSERT_BURST_SIZE) + GAP_SIZE 
                                      + ASSERT_BURST_SIZE -(~|COMMAND[1]*DEASSERT_BURST_SIZE) )           
                        CARRIER_EN = 1'b1;
                    else CARRIER_EN = 1'b0;
                                       
        BACKWARD:   if (curr_count <= START_BURST_SIZE + GAP_SIZE + CAR_SELECT_BURST_SIZE + GAP_SIZE
                                      + ASSERT_BURST_SIZE -(~|COMMAND[0]*DEASSERT_BURST_SIZE) + GAP_SIZE 
                                      + ASSERT_BURST_SIZE -(~|COMMAND[1]*DEASSERT_BURST_SIZE) + GAP_SIZE 
                                      + ASSERT_BURST_SIZE -(~|COMMAND[2]*DEASSERT_BURST_SIZE) )           
                        CARRIER_EN = 1'b1;
                    else CARRIER_EN = 1'b0;
                                               
        FORWARD:    if (curr_count <= START_BURST_SIZE + GAP_SIZE + CAR_SELECT_BURST_SIZE + GAP_SIZE
                                      + ASSERT_BURST_SIZE -(~|COMMAND[0]*DEASSERT_BURST_SIZE) + GAP_SIZE 
                                      + ASSERT_BURST_SIZE -(~|COMMAND[1]*DEASSERT_BURST_SIZE) + GAP_SIZE 
                                      + ASSERT_BURST_SIZE -(~|COMMAND[2]*DEASSERT_BURST_SIZE) + GAP_SIZE 
                                      + ASSERT_BURST_SIZE -(~|COMMAND[3]*DEASSERT_BURST_SIZE) )          
                        CARRIER_EN = 1'b1;
                    else CARRIER_EN = 1'b0;
                                                      
        default: CARRIER_EN = 1'b0;        
    endcase
// *****************************

assign IR_LED = ( CARRIER_EN == 1'b1 ) ? CLK : 1'b0;

endmodule