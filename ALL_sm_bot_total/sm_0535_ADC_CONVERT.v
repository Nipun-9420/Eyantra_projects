
module sm_0535_ADC_CONVERT(

	input sclk, dout,
	
	output chip_select, din,
	output [2:0] ADC_data,
	
	output clk_module
	
	);
	
	// variables needed
	reg r_adc_data_0;
	reg r_adc_data_1;
	reg r_adc_data_2;
	reg [11:0] r_data_temp;
	reg [4:0] sclk_counter = 0;
	reg r_din = 0;
	reg [1:0] r_chip_select = 1;
	reg [2:0] current_ch = 0; // the channel address for conversion ------using 2 channel for this code.

	
	
	
	//assign output
	assign chip_select = r_chip_select ;
	assign din = r_din ;
	assign ADC_data[0] = r_adc_data_1 ;
	assign ADC_data[1] = r_adc_data_2 ;
	assign ADC_data[2] = r_adc_data_0 ;
	assign clk_module = sclk;
	
 
	// sclk counter---------------------------------------------------------------------------------------------------------------------------------
	always @ (posedge sclk)
	begin
	
		
			//sclk counter--------------------------------------------------------------
			if(sclk_counter == 17)
			begin
				sclk_counter = 0 ;
				sclk_counter = sclk_counter + 1;
			end
			else
			begin
				sclk_counter = sclk_counter + 1;
			end
			
			//to control chip select----------------------------------------------------------
			if(sclk_counter == 17) 
			begin
				r_chip_select[1] = 1;
			end
			
			else if(sclk_counter == 1 ) 
			begin
				r_chip_select[1] = 0;
			end
			
			case(sclk_counter)
			
			
			// to get data from ADC-------------------------------------------------
			6:
			begin
				 
				r_data_temp[11] = dout;
				
			end
		
			7: r_data_temp[10] = dout;
			
			8: r_data_temp[9] = dout;
			
			9: r_data_temp[8] = dout;
			
			10: r_data_temp[7] = dout;
			
			11: r_data_temp[6] = dout;
		
			12: r_data_temp[5] = dout;
			
			13: r_data_temp[4] = dout;
			
			14: r_data_temp[3] = dout;
			
			15: r_data_temp[2] = dout;
			
			16: r_data_temp[1] = dout;
		
			17:	 
			begin 
				r_data_temp[0] = dout;
				
				r_data_temp = r_data_temp > 500 ? 1:0 ;
				
				case(current_ch) // this to send outut to correct output channel pin
			
				3'b000: r_adc_data_0 <= r_data_temp[0];
				
				3'b001: r_adc_data_1 <= r_data_temp[0];
				
				3'b010: r_adc_data_2 <= r_data_temp[0];
			
				endcase
				
				if(current_ch > 3)
				begin
					current_ch = 0;
				end
				
				else
				begin
					current_ch = current_ch + 1;
				end
				
			end
			
			
		
			endcase
			
			
			
			
	
	end
	
	
	
	//din output------------------------------------------------------------------------------------------------------------
	always @ (negedge sclk)
	begin
				
		
					
			// to control chip select----------------------------------------------------------
			if(sclk_counter == 1 & r_chip_select[1] == 0)
			begin
				r_chip_select[0] = 0;
			end
		
			else if(sclk_counter == 17)
			begin
				r_chip_select[0] = 1;
			end
			
			// to give DIN to ADC---------------------------------------------------------------
			case(sclk_counter)
			3: 
			begin 
				r_din = current_ch[2];
			end
		
			4:
			begin
				r_din = current_ch[1];
			end
		
			5: 
			begin 
				r_din = current_ch[0];
				
				
				
			end
		
			endcase
			
	end
	
	
	//to update chip_select------------------------------------------------------------------------------------------------
	
	
	
endmodule
		
		