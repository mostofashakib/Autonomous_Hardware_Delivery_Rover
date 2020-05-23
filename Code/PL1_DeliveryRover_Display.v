`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/29/2020 09:56:46 PM
// Design Name: 
// Module Name: PL1_DeliveryRover_Display
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


module PL1_DeliveryRover_Display(
    input clock,
    input reset,	//this reset enables when current overage on left motor is detected
    
	input [2:0] speedLeft,
	input [2:0] speedRight,
	input [3:0] direction,
	
    output SEG_A,SEG_B,SEG_C,SEG_D,SEG_E,SEG_F,SEG_G,SEG_DP,
	output DIG_0,DIG_1,DIG_2,DIG_3
    );
    
		//registers to control the 4-digit 7-segment display multiplexing
		reg [17:0] digits_counter; //sets the display
		localparam multiplexing_count = 18; 
		reg [7:0] word_temp;
		reg [3:0] digit;

		initial begin
			digits_counter = 0;
			word_temp = 0;
			digit = 0;
        end
        
         always@(posedge clock) begin
          
			digits_counter <= digits_counter + 1;
        
			//Display Multiplexing
			case(digits_counter[multiplexing_count-1:multiplexing_count-2])
				2'b00 : digit = 4'b1110;
				2'b01 : digit = 4'b1101;
				2'b10 : digit = 4'b1011;
				2'b11 : digit = 4'b0111;
			endcase
			
			case(digit)
				4'b1110: //---0 (0 indicates active digit)
					case(direction)
						4'b0000 : begin
							if(reset == 1) //display Over
								word_temp = 8'b10101111; //r
						end
						4'b0110 : word_temp = 8'b10000011; //Backward: b
						4'b1001 : word_temp = 8'b10001110; //Forward: F
						4'b0101 : word_temp = 8'b10101111; //Left: L
						4'b1010 : word_temp = 8'b11000111; //Right: r
						default : word_temp = 8'b10111111;
					endcase
				4'b1101: begin//--0-
				    if(reset == 1) //display over
				        word_temp = 8'b10000110;
				    else
                        case(speedRight) //display current speed level 0 -> 7
                            3'd0 : word_temp = 8'b11000000; //display --0-
                            3'd1 : word_temp = 8'b11001111; //display --1-
                            3'd2 : word_temp = 8'b10100100; //display --2-
                            3'd3 : word_temp = 8'b10110000; //display --3-
                            3'd4 : word_temp = 8'b10011001; //display --4-
                            3'd5 : word_temp = 8'b10010010; //display --5-
                            3'd6 : word_temp = 8'b10000010; //display --6-
                            3'd7 : word_temp = 8'b11111000; //display --7-
                        endcase
				end
				4'b1011 : begin
				    case(direction)
						4'b0000 :begin//-0--
							if(reset == 1) //display over
								word_temp = 8'b11100011;
						end
						4'b0110 : word_temp = 8'b10000011; //Backward: b
						4'b1001 : word_temp = 8'b10001110; //Forward: F
						4'b0101 : word_temp = 8'b10101111; //Left: L
						4'b1010 : word_temp = 8'b11000111; //Right: r
						default : word_temp = 8'b10111111;
					endcase
                end
				4'b0111 : begin
				    if(reset == 1) //display over
				        word_temp = 8'b11000000;
					else
                        case(speedLeft) //display current speed level 0 -> 7
                            3'd0 : word_temp = 8'b11000000; //display --0-
                            3'd1 : word_temp = 8'b11001111; //display --1-
                            3'd2 : word_temp = 8'b10100100; //display --2-
                            3'd3 : word_temp = 8'b10110000; //display --3-
                            3'd4 : word_temp = 8'b10011001; //display --4-
                            3'd5 : word_temp = 8'b10010010; //display --5-
                            3'd6 : word_temp = 8'b10000010; //display --6-
                            3'd7 : word_temp = 8'b11111000; //display --7-
                        endcase
                end
			endcase
        end

//---------FINAL OUTPUT ASSIGNMENTS-----------------------------------------
	//assign 7-segments to value in word_temp
	//assign current active digit for multiplexing
	assign {SEG_DP,SEG_G,SEG_F,SEG_E,SEG_D,SEG_C,SEG_B,SEG_A} = word_temp;
	assign {DIG_3,DIG_2,DIG_1,DIG_0} = digit;
endmodule
