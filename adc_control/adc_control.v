// SM : Task 2 A : ADC
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design ADC Controller.

Recommended Quartus Version : 19.1
The submitted project file must be 19.1 compatible as the evaluation will be done on Quartus Prime Lite 19.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

//ADC Controller design
//Inputs  : clk_50 : 50 MHz clock, dout : digital output from ADC128S022 (serial 12-bit)
//Output  : adc_cs_n : Chip Select, din : Ch. address input to ADC128S022, adc_sck : 2.5 MHz ADC clock,
//				d_out_ch5, d_out_ch6, d_out_ch7 : 12-bit output of ch. 5,6 & 7,
//				data_frame : To represent 16-cycle frame (optional)

//////////////////DO NOT MAKE ANY CHANGES IN MODULE//////////////////
module adc_control(
	input  clk_50,				//50 MHz clock
	input  dout,				//digital output from ADC128S022 (serial 12-bit)
	output adc_cs_n,			//ADC128S022 Chip Select
	output din,					//Ch. address input to ADC128S022 (serial)
	output adc_sck,			//2.5 MHz ADC clock
	output [2:0]d_out_ch,	//12-bit output of ch. 7 (parallel)
	output [1:0]data_frame	//To represent 16-cycle frame (optional)
);
	
////////////////////////WRITE YOUR CODE FROM HERE////////////////////
//assign variable
	reg [3:0] count; //counter for clock scaling
	reg [5:0] n;  //value of n in our case n=20(50/2.5)
	reg r_adc_sck;
	reg [11:0]r_d_out_ch5 =0;
	reg [11:0]r_d_out_ch6 =0;
	reg [11:0]r_d_out_ch7 =0;
	reg [11:0] r_data_temp;
	reg [4:0] sclk_counter = 1;
	reg r_din = 0 ;
	reg [1:0]r_adc_cs_n = 1;
	reg [2:0] current_ch = 5; // the channel address for conversion ------using 2 channel for this code.
	reg [1:0]r_data_frame = 2'b00;
	
	
	assign adc_sck = r_adc_sck;
	assign adc_cs_n = r_adc_cs_n ;
	assign din = r_din ;
	assign d_out_ch[0] = r_d_out_ch5;
	assign d_out_ch[1] = r_d_out_ch6;
	assign d_out_ch[2] = r_d_out_ch7;
	assign data_frame = r_data_frame;
	
	//clock scaling
	initial
	begin 
		count = 1;
		n = 20;
		r_adc_sck =0;
	end
	
	 
 //clock scaling
always@(posedge clk_50)
	begin 
		if (count < (n/2))
		 begin
			count = count +1;
		end
		else if (count ==(n/2))
		 begin 
			count =1;
			r_adc_sck = ~r_adc_sck;
		end
	end
	
// sclk counter-------------------------- -------------------------------------------------------------------------------------------------------
	always @ (posedge adc_sck)
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
				r_adc_cs_n[1] = 1;
			end
			
			else if(sclk_counter == 1 ) 
			begin
				r_adc_cs_n[1] = 0;
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
				
				r_data_temp = r_data_temp > 700 ? 1:0 ;
				
				case(current_ch) // this to send outut to correct output channel pin
			
				5: r_d_out_ch7 <= r_data_temp;
				
				6: r_d_out_ch5 <= r_data_temp;
			
				7: r_d_out_ch6 <= r_data_temp;
			
				endcase
				
				if(current_ch > 8)
				begin
					current_ch = 5;
				end
				
				else
				begin
					current_ch = current_ch + 1;
				end
			end
			endcase
			
	end
	
	
	
	//din output------------------------------------------------------------------------------------------------------------
	always @ (negedge adc_sck)
	begin
				
		   if (sclk_counter == 17)
			begin
				r_data_frame = r_data_frame +1;
			end
					
			// to control chip select----------------------------------------------------------
			if(sclk_counter ==1 & r_adc_cs_n[1] == 0)
			begin
				r_adc_cs_n[0] = 0;
			end
		
			else if(sclk_counter == 17)
			begin
				r_adc_cs_n[0] = 1;
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

	
////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////