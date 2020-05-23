`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Texas Tech University
// Engineer: Austin Cawley
// 
// Create Date: 02/06/2020 08:20:22 PM
// Design Name: Motor Mini-Project Demo Drive
// Module Name: PWM_tutorial
// Project Name: Motor Mini-Project Demo
// Target Devices: Digilent Basys3, Artix7 FPGA
// Tool Versions: Vivado 2019.2
// Description: 
// 		This file contains the code to drive the motors on the Rover Chassis using
//		PWM to control speed and switches to control the motor direction.
//		This program also reads output of a current sensing curcuit to stop and
//		protect the motors in the event they are stuck.
//
// Revision:
// Revision 2.00 - Finishing touches applied.
//////////////////////////////////////////////////////////////////////////////////


module PL1_DeliveryRover_MotorDriver(
    input reset,
    
	input [7:0] state,
	
	output reg [3:0] direction,
	output reg [2:0] speedLeft,
	output reg [2:0] speedRight,
    output PIN_IN0,PIN_IN1,PIN_IN2,PIN_IN3
    );
        
//-------------STATE DECODING----------------------------------		
		localparam stop = 'd0;
		localparam forward_fast = 'd1;
		localparam forward_slow = 'd2;
		localparam backward_fast = 'd3;
		localparam backward_slow = 'd4;
		localparam right_pivot = 'd5;
		localparam right_slow = 'd6;
		localparam left_pivot = 'd7;
		localparam left_slow = 'd8;
		
//------------------STATE ENCODING----------------------------------
		localparam stop_control = 4'b0000;
		localparam forward_control = 4'b1001; //also for slow turns
		localparam backward_control = 4'b0110;
		localparam right_pivot_control = 4'b0101;
		localparam left_pivot_control = 4'b1010;
		
		localparam speed_fast = 3'b111;
		localparam speed_slow = 3'b100;
		
//-------------PARAMETER INITIALIZATION------------------------
        initial begin
			direction = 0;
			speedLeft = 0;
			speedRight = 0;
        end
//----------CHANGE DETECTION BASED CONTROL-----------------------------------
        always @ (*) begin
            if(reset) begin
                direction = 0;
                speedLeft = 0;
                speedRight = 0;
                end
            else
			case(state)
				stop : begin
					direction = 0;
					speedLeft = 0;
					speedRight = 0;
				end
				forward_fast : begin
					direction = forward_control;
					speedLeft = speed_fast;
					speedRight = speed_fast;
				end
				forward_slow : begin
					direction = forward_control;
					speedLeft = speed_slow;
					speedRight = speed_slow;
				end
				backward_fast : begin
					direction = backward_control;
					speedLeft = speed_fast;
					speedRight = speed_fast;
				end
				backward_slow : begin
					direction = backward_control;
					speedLeft = speed_slow;
					speedRight = speed_slow;
				end
				right_pivot : begin
					direction = right_pivot_control;
					speedLeft = speed_fast;
					speedRight = speed_fast;
				end
				right_slow : begin
					direction = forward_control;
					speedLeft = speed_slow;
					speedRight = speed_fast;
				end
				left_pivot : begin
					direction = left_pivot_control;
					speedLeft = speed_fast;
					speedRight = speed_fast;
				end
				left_slow : begin
					direction = forward_control;
					speedLeft = speed_fast;
					speedRight = speed_slow;
				end
				default : begin
					direction = 0;
					speedLeft = 0;
					speedRight = 0;
				end
			endcase
        end

//---------FINAL OUTPUT ASSIGNMENTS-----------------------------------------

	//set control bits to value of control switches
	assign PIN_IN0 = direction[0];
	assign PIN_IN1 = direction[1];
	assign PIN_IN2 = direction[2];
	assign PIN_IN3 = direction[3];
	
endmodule
