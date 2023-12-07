module sm_0535_pwm(
   input clk,
	input [6:0] speed_a1_a , // speed of right motor 
	input [6:0] speed_a1_b , // speed of right motor
	input [6:0] speed_b1_a , // speed of left motor
	input [6:0] speed_b1_b , // speed of left motor
	output A1_A,
	output A1_B,
	output B1_A,
	output B1_B
	);

	reg [6:0] counter = 1;


	assign A1_A = (counter < speed_a1_a) ? 1:0;
	assign A1_B = (counter < speed_a1_b) ? 1:0;
	assign B1_A = (counter < speed_b1_a) ? 1:0;
	assign B1_B = (counter < speed_b1_b) ? 1:0;


	always@ (posedge clk)
   begin
      if(counter < 101)
		begin 
		   counter <= counter + 1;
		end
		else
		begin
		   counter <= 1;
		end
	end

endmodule
