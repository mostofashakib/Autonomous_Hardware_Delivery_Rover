`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  Mostofa Adib Shakib
// Biography: EECS & Math, Texas Tech University.
// Create Date: 02/20/2020 09:50:40 PM
// Design Name: 
// Module Name: movement
// Project Name: Mini Project for ECE 3331 - Project Lab 1
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

module movement(
    input clock,
    input [6:0] MotorSpeeds,
    input [4:0] MotorControls,
    output EnableA, EnableB,                         //  ENB,ENA
    output reg IN1, IN2, IN3, IN4,                    // JA4,JA3,JA2,JA1  IN4,IN3,IN2,IN1 for keeping the current orientation
	output [7:0] Segments,
    output [3:0] Digits
    );
    
    // constants
    
    parameter PERIOD = 50000000;                                    // 1 HZ clock period
    parameter HALF_PERIOD = PERIOD >> 1;                            // 50%
    parameter QUARTER_PERIOD = PERIOD >> 2;                         // 25%
    parameter HALF_QUARTER_PERIOD = PERIOD >> 3;                    // 12.5%    
    parameter PERC38_PERIOD = HALF_PERIOD - HALF_QUARTER_PERIOD;    // 37.5%
    parameter PERC62_PERIOD = HALF_PERIOD + HALF_QUARTER_PERIOD;    // 62.5%
    parameter PERC75_PERIOD = HALF_PERIOD + QUARTER_PERIOD;         // 75%
    parameter PERC88_PERIOD = PERC75_PERIOD + HALF_QUARTER_PERIOD;  // 87.5%
    parameter INTERTIAL_STOP  =      4'd0;
    parameter HARD_STOP       =      4'd15; 
    parameter REVERSE         =      4'd6;
    parameter FORWARD         =      4'd9;
    parameter TURN_RIGHT      =      4'd5; 
    parameter TURN_LEFT       =      4'd10;
    
    // temporary variables
    
    reg [27:0] counter;
    reg [27:0] width;
    reg temp_PWM;
    reg [7:0] SegTemp;
	reg [3:0] DigTemp;
	reg [3:0] Dig_0;
	reg [3:0] Dig_1;
	reg [3:0] Dig_2; 
	reg [3:0] Dig_3;	
	reg [18:0] sync;
	reg [7:0] num;
    
    // initialization
    
    initial begin
        counter = 0;
        width = 0;
        temp_PWM = 0;
    end
    
    always@ (posedge clock) begin
        if(counter < width)
            counter <= counter + 1;
        else
            counter <= 0;
        
        if(counter < width)
            temp_PWM <= 1;
        else
            temp_PWM <= 0;
    end
    
    always@(posedge clock) begin
          case(MotorSpeeds)                            // needs 7 cases for 7 switches
              7'd0 :       width  = 7'd0;              // 0%duty cycle
              7'b0000001 : width  = QUARTER_PERIOD;    // 25% duty cycle                   SWITCH  0
              7'b0000010 : width  = PERC38_PERIOD;     // 37.5% duty cycle                 SWITCH  1
              7'b0000100 : width  = HALF_PERIOD;       // 50% duty cycle                   SWITCH  2
              7'b0001000 : width  = PERC62_PERIOD;     // 62.5% duty cycle                 SWITCH  3
              7'b0010000 : width  = PERC75_PERIOD;     // 75% duty cycle                   SWITCH  4
              7'b0100000 : width  = PERC88_PERIOD;     // 87.5% duty cycle                 SWITCH  5
              7'b1000000 : width  = PERIOD;            // 100% duty cycle                  SWITCH  6
              default : width <= 7'd0;                 // 0 % duty cycle
          endcase
    end
    
    always@(posedge clock) begin
        case(MotorControls)
              5'd0: 
                    begin 
                        {IN1, IN2, IN3, IN4} = 4'b0000;
                        Dig_3  <=   1;                               // s
                        Dig_2  <=   2;                               // t
                        Dig_1  <=   5;                               // r
                        Dig_0  <=   2;                               // t
                    end
              5'b00001:
                    begin 
                        {IN1, IN2, IN3, IN4} = FORWARD;              //              SWITCH 7
                        Dig_3  <=   4;                               // F
                        Dig_2  <=   5;                               // r
                        Dig_1  <=   6;                               // d
                        Dig_0  <=   14;                              // Blank
                    end	
              5'b00010:
                    begin
                        {IN1, IN2, IN3, IN4} = REVERSE;              //              SWITCH 8
                        Dig_3  <= 11;                                // b
                        Dig_2  <= 12;                                // a
                        Dig_1  <= 13;                                // c
                        Dig_0  <= 14;                                // blank
                    end
              5'b00100:
                    begin
                         {IN1, IN2, IN3, IN4} = TURN_LEFT;            //             SWITCH 9
                         Dig_3 <= 7;                                  //L
                         Dig_2 <= 8;                                  //E
                         Dig_1 <= 4;                                  //F
                         Dig_0 <= 2;                                  //t
                    end
              5'b01000:
                    begin
                        {IN1, IN2, IN3, IN4} = TURN_RIGHT;            //              SWITCH 10
                        Dig_3 <= 5;                                   //r
                        Dig_2 <= 10;                                  //g
                        Dig_1 <= 9;                                   //h
                        Dig_0 <= 2;                                   //t
                    end
             default: 
                    begin 
                        {IN1, IN2, IN3, IN4} = 4'd0;
                        Dig_3  <=   1;                                // s
                        Dig_2  <=   2;                                // t
                        Dig_1  <=   5;                                // r
                        Dig_0  <=   2;                                // t
                    end
         endcase
    end
    
    always@(posedge clock) begin
        sync <= sync + 1;  
    end

    always@(*) begin                    // Takes the anode and puts actual numbers into them
        if(sync[18:17]==0) begin 		// Right most Digit
            DigTemp <= 4'b1110;
            num  <= Dig_0;
        end 
            
        else if(sync[18:17]==1) begin   // 2nd Right most digit
            DigTemp <= 4'b1101;
            num <= Dig_1;
        end 
            
        else if(sync[18:17]==2) begin   // 2nd Left most digit
            DigTemp <= 4'b1011;
            num <= Dig_2; 
        end 
            
        else begin 				    	// Left most digit
            DigTemp <= 4'b0111;
            num <=  Dig_3;
        end		
    end

    always @ (*) begin
        case (num)
            0: SegTemp  = 8'b0011_1111;   // 0
            1: SegTemp  = 8'b0110_1101;   // S
            2: SegTemp  = 8'b0111_1000;   // t
            3: SegTemp  = 8'b0111_0011;   // P
            4: SegTemp  = 8'b0111_0001;   // F
            5: SegTemp  = 8'b0101_0000;   // r
            6: SegTemp  = 8'b0101_1110;   // d
            7: SegTemp  = 8'b0011_1000;   // L
            8: SegTemp  = 8'b0111_1001;   // E
            9: SegTemp  = 8'b0111_0100;   // h
            10: SegTemp = 8'b0110_1111;   // g
            11: SegTemp = 8'b0111_1100;   // b
            12: SegTemp = 8'b0111_0111;   // A
            13: SegTemp = 8'b0101_1000;   // c            
            14: SegTemp = 8'b0000_0000;   // blank
            15: SegTemp = 8'b0001_1100;   // u
            default: SegTemp = 8'bxxxx_xxxx;           
        endcase    
    end
   
    assign Digits = DigTemp;
    assign Segments = ~SegTemp;
    assign EnableA = temp_PWM;
    assign EnableB = temp_PWM;
endmodule