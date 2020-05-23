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


module PL1_DeliveryRover_Counter(
    input clock,
    output reg [19:0] counter
    );

//--------------------CLOCK BASED CONTROL-----------------------------------
    always@(posedge clock) begin
           counter <= counter + 1;
    end
endmodule
