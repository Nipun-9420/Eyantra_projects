module pwm(
   input clk,
	output A1_A,
	output A1_B,
	output B1_A,
	output B1_B
	);

	reg [10:0] counter = 1; // 0-64 Counter
	reg clk_o =0;
	reg [3:0] count;
	reg [5:0] n;
	
	initial
	begin
		count =1 ;
		n =20;
		clk_o =0;
	end
	
	always @ (posedge clk)
	begin
		if (count < (n/2))
		begin
			count = count +1;
		end
		
		else if (count == (n/2))
		begin
			count = 0;
			clk_o = ~clk_o;
		end
	end


	assign A1_A = (counter < 0) ? 1:0;
	assign B1_A = (counter < 0) ? 1:0;
	assign A1_B = (counter < 70) ? 1:0;
	assign B1_B = (counter < 73) ? 1:0;

	always@ (posedge clk_o)
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
