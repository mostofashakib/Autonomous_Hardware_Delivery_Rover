`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  Mostofa Adib Shakib
// Biography: EECS & Math, Texas Tech University.
// Create Date: 03/5/2020 01:27:29 AM
// Design Name: 
// Module Name: Servo_Motor_Module
// Description Name: Line following using Inductive Proximity Sensors, used to keep the rover stay in the track 
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


module Servo_Motor_Module(
    input clk,
    output temp_PWM
);

    reg counter;
    reg temp_PWM = 0;

always @(posedge clock) begin​

    if (reset)​
        counter <= 0;​
    else​
        counter = counter + 1;​

    if (counter == 22'd2097152)         // creates 50Hz frequency PWM​
        counter = 0;            ​

    if (counter < width)​
        temp_PWM <= 1;​
    else ​
        temp_PWM <= 0;​
end​

always @ (*) begin​

	case (speed)​

	    4'b0000: width = 22'd0;​

	    4'b0001: width = 22'd1048576; ​ //  0 degrees (initial position)​

	    4'b0010: width = 22'd1572864;​  //  90 degrees (midway)​

	    4'b0100: width = 22'd2097152;​  //  180 degrees (full rotation)​

	    default : width = 0;​
	endcase​
end

endmodule