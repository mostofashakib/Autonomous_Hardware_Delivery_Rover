`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  Mostofa Adib Shakib
// Biography: EECS & Math, Texas Tech University.
// Create Date: 02/26/2020 09:50:40 PM
// Design Name: 
// Module Name: Ultrasonic_Detection_Module
// Description: Measures Distance using ultrasonic sensor, sends signal if object in range
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

module Ultrasonic_Detection_Module(
	output reg trig,
	output reg stop,
	output trigStep,
	input echo,
	input clk
);

// Declaring constants

reg stp;
parameter scale = 50;
parameter limit = 75000000;
reg clk_out = 0;
reg [15:0] count = 16'b0;
reg[15:0] dist = 16'b0;
reg[15:0] finalDist;
reg[15:0] trigCount = 16'b0;
reg prev;
reg before;
reg [27:0] countV;
reg stopR;

always @(posedge clk) //divide clock to correct frequencey
	if (count == scale - 1) begin            // from Rice's github
		count <= 16'b0;
		clk_out <= ~clk_out;
	end
	else begin
		count <= count + 1;
		clk_out <= clk_out;
	end


always @(posedge clk_out) begin              // trigger ultrasonic
	if(trigCount < 20) begin
		trig = 1;
		trigCount = trigCount + 1;
	end

	else if(trigCount >= 20 && trigCount < 65000) begin
		trig = 0;
		trigCount = trigCount + 1;
	end

	else begin
		trig = 0;
		trigCount = 16'b0;
		dist = 0;
	end

	if(echo == 1) begin
		dist = dist + 1;
	end

	else begin
		finalDist = dist;
	end
end


always @(posedge clk) begin
	if(finalDist < 588) begin
		stopR = 1;
	end

	else begin
		stopR = 0;
		stop = 0;
		stp = 0;
		countV = 0;
	end

	if(prev == 0 && stp == 1)begin
		before = 1;
	end

	else begin
		before = 0;
	end

	if(stopR == 1 && countV <= limit) begin
		countV <= countV + 1;
	end

	else begin
		countV <=0;
	end
	
	if(countV > limit) begin
		stop = 1;
		stp = 1;
	end
	
	prev = stp;
end

delay delaymar(
	.signal(stop),
	.clk(clk),
	.choice(0),
	.delay(trigStep)
);

endmodule