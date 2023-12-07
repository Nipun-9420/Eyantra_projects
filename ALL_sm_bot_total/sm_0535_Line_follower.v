module sm_0535_Line_follower(
	input clk_adc, clk_sm_bot, 
	input dout_adc,
	output chip_select_adc, din_adc, clk_mod_adc,
	output pwm_A1_A,
	output pwm_A1_B,
	output pwm_B1_A,
	output pwm_B1_B,
	output [1:0] Unit_at
	);
	
	wire [2:0] w_adc_data;
	
	sm_0535_ADC_CONVERT line_sensor(
	.sclk (clk_adc), 
	.dout (dout_adc),
	.chip_select (chip_select_adc),
	.din (din_adc),
	.ADC_data (w_adc_data),
	.clk_module (clk_mod_adc)
	);
	
	sm_0535_sm_bot_core follow_algo(
	.clk_core (clk_sm_bot),
	.adc_data (w_adc_data),
	.A1_A (pwm_A1_A),
	.A1_B (pwm_A1_B),
	.B1_A (pwm_B1_A),
	.B1_B (pwm_B1_B),
	.Unit_at (Unit_at)
	);

endmodule 