module led (
   input clk,
	output led_R,
	output led_G,
	output led_B,
   output [31:0] count
   );

	reg [31:0] r_count = 1 ;
	reg r_led_R = 0; 
	reg r_led_B = 0;
	reg r_led_G = 0;
	reg [3:0] color =3'b001; 
	
	assign led_R = r_led_R;
	assign led_G = r_led_G;
	assign led_B = r_led_B;
	assign count = r_count;
	
	
	always @ (posedge clk)
	begin
		if (r_count<=25000000)
		begin
	
		r_count = r_count +1;  
			
		end
		else
		begin 
		
		r_count =1;
		r_led_R = ~r_led_R;
		r_led_B = ~r_led_B;
		r_led_G = ~r_led_G;
		end
			
	end
endmodule
	
		
		 
	