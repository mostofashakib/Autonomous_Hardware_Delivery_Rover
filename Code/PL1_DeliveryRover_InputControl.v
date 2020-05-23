`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2020 08:20:22 PM
// Design Name: 
// Module Name: PWM_tutorial
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


module PL1_DeliveryRover_InputControl(
    input SW0,SW1,SW2,SW3,SW4,SW5,SW6,SW7,
	
	output reg [7:0] state,
	output reg end_reset,
    
    output LED0,LED1,LED2,LED3,LED4,LED5,LED6,LED7
    );
        reg [7:0] lights;
        
        initial begin
			state = 0;
			lights = 0;
			end_reset = 0;
        end
        
        always @ (*) begin
			
			state = {SW7,SW6,SW5,SW4,SW3,SW2,SW1,SW0};
			end_reset = SW7;
			
			lights = {SW7,SW6,SW5,SW4,SW3,SW2,SW1,SW0};
        end
				
	assign LED0 = lights[0];
	assign LED1 = lights[1];
	assign LED2 = lights[2];
	assign LED3 = lights[3];
	assign LED4 = lights[4];
	assign LED5 = lights[5];
	assign LED6 = lights[6];
	assign LED7 = lights[7];                   
endmodule
