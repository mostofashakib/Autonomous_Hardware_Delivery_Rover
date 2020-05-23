module system(
	input clock,
    input PIN_sens0,   //this reset enables when current overage on right motor is detected.
    input PIN_sens1,	//this reset enables when current overage on left motor is detected
    input SW0,SW1,SW2,SW3,SW4,SW5,SW6,SW7,
	
	output PIN_EN0,PIN_EN1,
    output PIN_IN0,PIN_IN1,PIN_IN2,PIN_IN3,
    
    output LED0,LED1,LED2,LED3,LED4,LED5,LED6,LED7,
    
    output LED_reset,
	
	output SEG_A,SEG_B,SEG_C,SEG_D,SEG_E,SEG_F,SEG_G,SEG_DP,
	output DIG_0,DIG_1,DIG_2,DIG_3
);

	
//		//counter sets the 100MHz clock to output at 60hz
//        reg [19:0] counter; //sets the period 1111 1111 1111 1111 1111  //1048575 ticks
		
		//registers for speed and cntrol
		wire [7:0] state;
        wire [2:0] speedLeft;
		wire [2:0] speedRight;
        wire [3:0] direction;
		wire reset;
		wire end_reset;
      
	//Input: clock
	//Output: reg counter
//	PL1_DeliveryRover_Counter Counter1(
//		.clock(clock),
//		.counter(counter)
//	);
	
	//Input: clock, reg speedLeft, reg speedRight
	//Output: PIN_EN0, PIN_EN1
	PL1_DeliveryRover_PWM PWM1(
		.clock(clock),
		.reset(reset),
		.speedLeft(speedLeft[2:0]),
		.speedRight(speedRight[2:0]),
		
		.PIN_EN0(PIN_EN0), .PIN_EN1(PIN_EN1)
		
	);
	
	//Input: clock, end_reset,PIN_sens0, PIN_sens1
	//Output: reg reset
	PL1_DeliveryRover_CurrentLimiter CurrentLimiter1(
		.clock(clock),
		.PIN_sens0(PIN_sens0),
		.PIN_sens1(PIN_sens1),
		.end_reset(end_reset),
		
		.reset(reset),
		.LED_reset(LED_reset)
	);
	
	//Input: SW0,SW1,SW2,SW3,SW4,SW5,SW6,SW7
	//Output: reg state, reg end_reset
	PL1_DeliveryRover_InputControl InputControl1(
		.SW0(SW0), .SW1(SW1), .SW2(SW2), .SW3(SW3),
        .SW4(SW4), .SW5(SW5), .SW6(SW6), .SW7(SW7),
		
		.LED0(LED0),.LED1(LED1),.LED2(LED2),
		.LED3(LED3),.LED4(LED4),.LED5(LED5),
		.LED6(LED6),.LED7(LED7),
		
		.state(state[7:0]),
		.end_reset(end_reset)
	);
	
	//Input: reg reset, reg state
	//Output: PIN_IN0, PIN_IN1,PIN_IN2,PIN_IN3
	//output reg speedLeft, reg speedRight
    PL1_DeliveryRover_MotorDriver MotorDriver1(
        .reset(reset),
		.state(state),
        
        .speedLeft(speedLeft[2:0]),
		.speedRight(speedRight[2:0]),
		.direction(direction[3:0]),
        
        .PIN_IN0(PIN_IN0), .PIN_IN1(PIN_IN1),
        .PIN_IN2(PIN_IN2), .PIN_IN3(PIN_IN3)
    );
	
	//Input: clock
	//		reg reset
	//		reg speedLeft[2:0], speedRight[2:0]
	//		reg direction[3:0]
	//output SEG_A,SEG_B,SEG_C,SEG_D,SEG_E,SEG_F,SEG_G,SEG_DP,
	//output DIG_0,DIG_1,DIG_2,DIG_3
    PL1_DeliveryRover_Display Display1(
        .clock(clock),
        .reset(reset),
		
		.speedLeft(speedLeft[2:0]),
		.speedRight(speedRight[2:0]),
		.direction(direction[3:0]),
		
        
        .SEG_A(SEG_A), 
        .SEG_B(SEG_B), 
        .SEG_C(SEG_C), 
        .SEG_D(SEG_D), 
        .SEG_E(SEG_E), 
        .SEG_F(SEG_F), 
        .SEG_G(SEG_G), 
        .SEG_DP(SEG_DP), 
        
        .DIG_0(DIG_0),
        .DIG_1(DIG_1),
        .DIG_2(DIG_2),
        .DIG_3(DIG_3)
     );

    
endmodule