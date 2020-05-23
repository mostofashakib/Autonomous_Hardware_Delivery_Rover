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


module PL1_DeliveryRover_PWM(
	input clock,
	input reset,
	input speedLeft,
	input speedRight,
	
	output PIN_EN0,PIN_EN1
    );
		//registers to control PWM
        reg temp_PWM_left;
		reg temp_PWM_right;
		
		//counter sets the 100MHz clock to output at 60hz
        reg [19:0] widthLeft;
		reg [19:0] widthRight;
		reg [19:0] counter;
		
        initial begin
			//speed and direction
            counter = 0;
			widthLeft = 0;
			widthRight = 0;
			temp_PWM_left = 0;
			temp_PWM_right = 0;
        end

//--------------------CLOCK BASED CONTROL-----------------------------------
        always@(posedge clock) begin
			if(reset)
                counter <= 0;
            else
                counter <= counter + 1;
			
			if(counter < widthLeft)
                temp_PWM_left <= 1;
            else
                temp_PWM_left <= 0;
				
			if(counter < widthRight)
                temp_PWM_right <= 1;
            else
                temp_PWM_right <= 0;
				
        end
//----------------UPDATE BASED CONTROL-------------------------------------
		always @ (*) begin
			
			case(speedLeft)
                3'd0 : widthLeft = 20'd0;       //0% duty
                3'd1 : widthLeft = 20'd349524;  // 3/9 duty
                3'd2 : widthLeft = 20'd466033;  // 4/9 duty
                3'd3 : widthLeft = 20'd582541;  // 5/9 duty
                3'd4 : widthLeft = 20'd699049;  // 6/9 duty
                3'd5 : widthLeft = 20'd815558;  // 7/9 duty
                3'd6 : widthLeft = 20'd932066;  // 8/9 duty
                3'd7 : widthLeft = 20'd1040000; // 100% duty
                default : widthLeft= 20'd0;
            endcase
			case(speedRight)
                3'd0 : widthRight = 20'd0;       //0% duty
                3'd1 : widthRight = 20'd349524;  // 3/9 duty
                3'd2 : widthRight = 20'd466033;  // 4/9 duty
                3'd3 : widthRight = 20'd582541;  // 5/9 duty
                3'd4 : widthRight = 20'd699049;  // 6/9 duty
                3'd5 : widthRight = 20'd815558;  // 7/9 duty
                3'd6 : widthRight = 20'd932066;  // 8/9 duty
                3'd7 : widthRight = 20'd1040000; // 100% duty
                default : widthRight= 20'd0;
            endcase
			
		end
		 
	assign PIN_EN0 = temp_PWM_left;
	assign PIN_EN1 = temp_PWM_right;
endmodule
