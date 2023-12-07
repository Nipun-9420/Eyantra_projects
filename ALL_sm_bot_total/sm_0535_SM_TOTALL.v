module sm_0535_SM_TOTALL(

	// line_follow ports
	input clk_adc, clk_sm_bot, clk_pwm,
	input dout_adc,
	output chip_select_adc, din_adc, clk_mod_adc,
	output pwm_A1_A,
	output pwm_A1_B,
	output pwm_B1_A,
	output pwm_B1_B,
	
	output [3:0] z_current_node,
	output [2:0] z_current_unit,

	
	// color_sensor ports
	input clk_color,
	input color_input,
	output S0,
	output S1,
	output S2,
	output S3,
	output led_R,
	output led_G,
	output led_B, 
	
	// uart ports
	input clk_uart,
	output tx_serial,
	input i_rx_serial
	);
	
	wire [2:0] w_color_in;
	wire [7:0] w_tx_byte;
	wire w_tx_data_valid;
	wire w_tx_done;
	
	wire [2:0] w_adc_data;
	wire [2:0] w_unit_at;
	
	wire w_start_detecting;
	wire w_color_detected;
	
	wire [6:0] w_speed_a1_a ; // speed of right motor 
	wire [6:0] w_speed_a1_b ; // speed of right motor
	wire [6:0] w_speed_b1_a ; // speed of left motor
	wire [6:0] w_speed_b1_b ; // speed of left motor
	
	
	wire [7:0] w_rx_byte;
	wire [16:0] w_paths_av;
	
	// ADC block-----------------------------------------------------------------------------------------------------------
	sm_0535_ADC_CONVERT line_sensor(
	.sclk (clk_adc), 
	.dout (dout_adc),
	.chip_select (chip_select_adc),
	.din (din_adc),
	.ADC_data (w_adc_data),
	.clk_module (clk_mod_adc)
	);
	
	// sm_bot_core-----------------------------------------------------------------------------------------------------------
	sm_0535_sm_bot_core follow_algo(
	.clk_core (clk_sm_bot),
	.adc_data (w_adc_data),
	.color_detected (w_color_detected), 
	.speed_a1_a (w_speed_a1_a), // speed of right motor 
	.speed_a1_b (w_speed_a1_b), // speed of right motor
	.speed_b1_a (w_speed_b1_a), // speed of left motor
	.speed_b1_b (w_speed_b1_b), // speed of left motor
	
	.path (w_paths_av),

	.start_detecting (w_start_detecting), 
	.Unit_at (w_unit_at),
	
	.o_current_node (z_current_node),
	.o_current_unit (z_current_unit)
	);
	
	// color_sensor block-------------------------------------------------------------------------------------------------
	sm_0535_colour_sensor_detection c_sd_1(
	 .clk (clk_color),
	 .signal (color_input),
	 .S0 (S0),
	 .S1 (S1),
	 .S2 (S2),
	 .S3 (S3),
	 .color (w_color_in)
	);

	// uart controller block-----------------------------------------------------------------------------------------------------
	sm_0535_uart_controller cont_tx(
	 .clk (clk_uart),
	 .o_tx_done (w_tx_done),
	 .color_in (w_color_in),
	 .Unit_at (w_unit_at),
	 .start_detecting_color (w_start_detecting), 
	 .color_detected (w_color_detected),  
	 .tx_data_valid (w_tx_data_valid),
	 .tx_byte (w_tx_byte),
	 .led_R (led_R),
	 .led_G (led_G),
	 .led_B (led_B)
	);
		
	// uart transmitter block---------------------------------------------------------------------------------------------	
	sm_0535UART_TRANSMITTER trans_1(
		 .CLOCK (clk_uart),	          
		 .TX_DATA_VALID (w_tx_data_valid),		
		 .TX_BYTE (w_tx_byte),
		 .O_TX_SERIAL (tx_serial),		
	    .O_TX_DONE (w_tx_done)	
	);
	
	// pwm block-------------------------------------------------------------------------------------------------------------
	sm_0535_pwm speed_12(
		.clk (clk_pwm),
		.speed_a1_a (w_speed_a1_a), 
		.speed_a1_b (w_speed_a1_b), 
		.speed_b1_a (w_speed_b1_a), 
		.speed_b1_b (w_speed_b1_b), 
		.A1_A (pwm_A1_A),
		.A1_B (pwm_A1_B),
		.B1_A (pwm_B1_A),
		.B1_B (pwm_B1_B),
	);
	
	// uart reciever controller--------------------------------------------------------------------------------------------
	sm_0535_uart_rx_controller cont_rx( 
	.clk (clk_uart),
	.o_rx_byte (w_rx_byte),
	.paths_av (w_paths_av) // this `16 bit shows availabilty of paths each bit show a single path 
	);
	
	// uart reciever----------------------------------------------------------------------------------------------------
	sm_0535_UART_Receiver rec_1(
	.CLOCK (clk_uart),
	.i_RX_Serial (i_rx_serial),
	.o_RX_Byte (w_rx_byte)
	);
	

endmodule 