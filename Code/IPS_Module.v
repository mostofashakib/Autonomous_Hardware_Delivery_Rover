`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  Mostofa Adib Shakib
// Biography: EECS & Math, Texas Tech University.
// Create Date: 03/5/2020 01:27:29 AM
// Design Name: 
// Module Name: IPS_Module
// Project Name: Line following using Inductive Proximity Sensors, used to keep the rover stay in the track 
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


module IPS_Module(
    input clk,
    input [2:0] ips,
    output ENA, ENB,
    output reg [1:0] motors,
    output [2:0] led
 );

    reg [11:0] dutyA, dutyB;
    assign led[2:0] = ips[2:0];

    always @(posedge clk) begin
	    case(ips)
	      3'b011: begin
	         motors = 2'b11;
	         dutyA = 2300;//550
	         dutyB = 1500;//450
	      end

	      3'b001:begin
	         motors = 2'b11;
	         dutyA = 1500;//500
	         dutyB = 1000;
	      end

	      3'b101:begin
	         motors = 2'b11;
	         dutyA = 1700;
	         dutyB = 1700;
	      end

	      3'b110:begin
	         motors = 2'b11;
	         dutyA = 1500;
	         dutyB = 2300;
	      end

	     3'b100:begin
	         motors = 2'b01;
	         dutyA = 1000;
	         dutyB = 1500;
	      end
	     3'b000:begin
	         motors = 2'b00;
	         dutyA = 0;
	         dutyB = 0;
	      end
	   endcase
   end


//pwm generation module

pwm signalA (
  .clk(clk),
  .duty(dutyA),
  .out(ENA)
);

//pwm generation module

pwm signalB (
  .clk(clk),
  .duty(dutyB),
  .out(ENB)
 );

endmodule