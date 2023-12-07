module sm_0535_uart_rx_controller( 
	input clk,
	input [7:0] o_rx_byte,
	output [16:0] paths_av // this `16 bit shows availabilty of paths each bit show a single path 
	);
	
	reg [4:0] count = 0;
	
	reg [16:0] r_paths_av = 17'b11111111101111111;
	reg [7:0] msgs_rec [2:0];
	reg [3:0] path_no ;
	
	reg [1:0] current_state = 0; 
	
	parameter START = 2'b00; 
	parameter REC_PATHS = 2'b01;
	parameter STOP = 2'b10;
	
	assign paths_av = r_paths_av;
	
	
	always @ (posedge clk)
	begin 
	
		case(current_state)
		
			START:
			begin
				msgs_rec[count] = o_rx_byte;
				if (msgs_rec[count] == "-")
				begin
					current_state = REC_PATHS;
				end
				else
				begin
					current_state = START;
				end
			end
			
			REC_PATHS:
			begin
				msgs_rec[count] = o_rx_byte;
				if(msgs_rec[count] != "-" & msgs_rec[count] != "#")
				begin
					path_no = msgs_rec[0] - 48;
					r_paths_av[path_no] = 0;
				end
				
				else if(msgs_rec[count] == "#")
				begin
					current_state = STOP;
				end
				
				else
				begin
					count = count + 1;
				end
			end
			
			STOP:
			begin
				current_state = STOP;
			end
			
		endcase
		
	end
endmodule	