`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  Mostofa Adib Shakib
// 
// Create Date: 02/20/2020 09:31:44 PM
// Design Name: 
// Module Name: movement_TestBench
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

module movement_TestBench;
    reg clock;
    reg [6:0] MotorSpeeds;
    reg [4:0] MotorControls;
    wire EnableA, EnableB;
    wire IN1, IN2, IN3, IN4;
    wire [7:0] Segments;
    wire [3:0] Digits;
    
    movement UUT(clock, MotorSpeeds, MotorControls, EnableA, EnableB, IN1, IN2, IN3, IN4, Segments, Digits);
    
    initial begin
        clock = 1;
        MotorSpeeds = 0;
        MotorControls = 0;
        #100;
        MotorSpeeds = 1;
        MotorControls = 1;
        #100;
        MotorSpeeds = 2;
        MotorControls = 2;
        #100;
        MotorSpeeds = 2;
        MotorControls = 3;
        #100;
        MotorSpeeds = 4;
        MotorControls = 0;
        #100;
        MotorSpeeds = 5;
        MotorControls = 4;
        #100;
        MotorSpeeds = 6;
        MotorControls = 1;
        #100
        MotorSpeeds = 2;
        MotorControls = 0;
        #100;
     end 
     
     always begin
     #1 clock = ~clock;
     end
     
endmodule