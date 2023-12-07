
module colour_sensor(
	input clk,
	output S0,            
	output S1,            //  input_frequency
	output S2,               
	output S3,            //   color_filter
	input signal,         //------input_signal----
	output [2:0] color  //------output------

);
   //--------------declare_variable-------------------------
	reg r_S0 = 1;
	reg r_S1 = 0;
	reg [1:0] r_color = 2'b00;
	reg [6:0] r_red ;
	reg [6:0] r_blue;
	reg [6:0] r_green;
	reg [19:0] clk_counter = 0;
	reg [6:0] freq_counter = 0;
	reg old_sig = 0 ;
	
	//------------assign_variable-----------
	assign S0 = r_S0;
	assign S1 = r_S1;
	assign S2 = r_color[0]; 
	assign S3 = r_color[1];
	
   //-------------output_color------------
	assign color[0] = (6'h06 <= r_red & r_red <= 6'h09) & (6'h0A <= r_blue & r_blue <= 6'h0F) & (6'h01 <= r_green & r_green <= 6'h03) ? 1:0; //r_red     
	assign color[1] = (6'h03 <= r_green & r_green <= 6'h06) & (6'h02 <= r_red & r_red <= 6'h05) & (6'h0B<= r_blue & r_blue <= 6'h15) ? 1:0;//r_blue; 
	assign color[2] = (6'h16 <= r_blue & r_blue <= 6'h1A) & (6'h05 <= r_red & r_red <= 6'h08) & (6'h09 <= r_green & r_green <= 6'h0D) ? 1:0; //r_green;

	//--------------main_function------------------
	always@(posedge clk) 
	begin
		
		if (signal != old_sig) 
		begin
			freq_counter = freq_counter + 1;
		end
	
		if ( clk_counter == 100000)
		begin	
			case ( r_color)
			
			//***********Red Filter************
			2'b00 :    
				begin
					r_red = freq_counter;
					r_color = 2'b01; 
				end
			//***********Blue Filter*******
			2'b01	: 
				begin
					r_blue = freq_counter;
					r_color = 2'b11; 
				end
			//***********green filter**********
			2'b11 : 
				begin
					r_green = freq_counter;
					r_color = 2'b00; 
				end
				
			endcase
			
			
			clk_counter = 0;
			freq_counter = 0;
			
		end
		
		else
		begin
			clk_counter = clk_counter + 1;
		end
		

		old_sig = signal;
	end	
	

endmodule
		
		