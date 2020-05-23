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


module PL1_DeliveryRover_CurrentLimiter(
//`include "system.v";
//`include "GlobalVariables.v";
    input clock,
    input PIN_sens0,   //this reset enables when current overage on right motor is detected.
    input PIN_sens1,	//this reset enables when current overage on left motor is detected
	input end_reset,
   
	output reg reset,
	output LED_reset
    );
		
		//registers to control current overage detection
//		reg reset;	//reset = 1 will stop all motors
		reg test_positive;
		reg [18:0] delay; //allows for a 0.0524287 second delay to confirm corrent overage
		reg delayToggle;
        
        initial begin
			//current protection
			test_positive = 0;
			delay = 0;
        end

//--------------------CLOCK BASED CONTROL-----------------------------------
        always@(posedge clock) begin                
			//IF SW7 is high, reset = 0;
            if(end_reset == 1)
				reset = 0;
            
			//Current Detection Delay
            if(PIN_sens0 || PIN_sens1)
                delayToggle = 1;	//start counting to 0.05 seconds
                
            if(delayToggle)
                delay <= delay + 1;
            
             
             if(delay >= 19'b1111111111111100000) //if count is at 0.0524256, check current again
                begin
                    if(PIN_sens0 || PIN_sens1)
                        begin
                            reset = 1;
                            delayToggle = 1;
                            delay <= 0;
                        end
                     else
                        begin
                            delayToggle = 0;
                            delay <= 0;
                        end
                end
        end
	assign LED_reset = reset;
endmodule
