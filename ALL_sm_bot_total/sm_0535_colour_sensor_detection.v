module sm_0535_colour_sensor_detection(
	output S0,
	output S1,
	output S2,
	output S3,
	input signal,
	output [2:0] color,
	input clk

);

	reg r_S0 = 0;
	reg r_S1 = 1;
	reg [1:0] r_color = 2'b00;
	reg [6:0] r_red ;
	reg [6:0] r_blue;
	reg [6:0] r_green;
	reg [12:0] clk_counter = 0;
	reg [6:0] freq_counter = 0;
	
	
	
	reg old_sig = 0 ;
	
	assign S0 = r_S0;
	assign S1 = r_S1;
	assign S2 = r_color[0]; 
	assign S3 = r_color[1];
	

	assign color[0] = (6'h0B < r_red & r_red < 6'h14) & (6'h17 < r_blue & r_blue < 6'h23) & (6'h04 < r_green & r_green < 6'h08) ? 1:0; //r_red     
	assign color[1] = (6'h13 < r_blue & r_blue < 6'h01A) & (6'h07 < r_red & r_red < 6'h0A) & (6'h07 < r_green & r_green < 6'h0C) ? 1:0;//r_blue; 
	assign color[2] = (6'h05 < r_green & r_green < 6'h08) & (6'h03 < r_red & r_red < 6'h07) & (6'h19 < r_blue & r_blue < 6'h22) ? 1:0; //r_green;


	always@(posedge clk) 
	begin
		
		clk_counter = clk_counter + 1;
		
		if (signal != old_sig) 
		begin
			freq_counter = freq_counter + 1;
		end
	
		if ( clk_counter == 1000)
		begin	
			case ( r_color)
			
			2'b00 :    
				begin
					r_red = freq_counter;
					r_color = 2'b01; 
				end
			
			2'b01	: 
				begin
					r_blue = freq_counter;
					r_color = 2'b11; 
				end
				
			2'b11 : 
				begin
					r_green = freq_counter;
					r_color = 2'b00; 
				end
				
			endcase
			
			
			clk_counter = 0;
			freq_counter = 0;
			
		end
		

		old_sig = signal;
	end	
	

endmodule
		
		
		
		
	//values below are in hexasdecimal
//	assign color[0] = (r_red==6'h0C | r_red==6'h0D | r_red==6'h0E) & (r_blue==6'h19 | r_blue==6'h1A | r_blue==6'h1B) & (r_green==6'h04 | r_green==6'h05 | r_green==6'h06) ? 1:0;      
//	assign color[1] = (r_blue==6'h19 | r_blue==6'h1A) & (r_red==6'h05 | r_red==6'h04) & (r_green==6'h06 | r_green==6'h07); //r_blue; 
//	assign color[2] = (r_green==6'h08 | r_green==6'h07) & (r_red==6'h06 | r_red==6'h07) & (r_blue==6'h15 | r_blue==6'h16);//r_green;

//assign color[0] = (r_red==6'h0C | r_red==6'h0D) & (r_blue==6'h18) & (r_green==6'h05) ? 1:0; //r_red     
//assign color[1] = (r_green==6'h08) & (r_red==6'h06) & (r_blue==6'h14) ? 1:0;//r_blue; 
//assign color[2] = (r_blue==6'h017) & (r_red==6'h04) & (r_green==6'h06) ? 1:0; //r_green;

//assign color[0] = (r_red==6'h12 | r_red==6'h13) & (r_blue==6'h22) & (r_green==6'h07) ? 1:0; //r_red     
//assign color[1] = (r_blue==6'h01C | r_blue==6'h01D) & (r_red==6'h09) & (r_green==6'h0A | r_green==6'h0B) ? 1:0;//r_blue; 
//assign color[2] = (r_green==6'h08) & (r_red==6'h05 | r_red==6'h06) & (r_blue==6'h20 | r_blue==6'h21) ? 1:0; //r_green;

		