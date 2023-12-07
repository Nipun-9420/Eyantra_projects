
module sm_0535_UART_Receiver
	 // clocks per bit = freq. of clock / freq. of UART i.e., 25000000/115200 = 217
	(
		input 		 CLOCK,
		input 		 i_RX_Serial,
		output [7:0] o_RX_Byte
	);
	
	parameter 	IDLE			  = 3'b000,
					RX_START_BIT  = 3'b001,
					RX_DATA_BITS  = 3'b010,
					RX_STOP_BIT	  = 3'b011,
					CLEANUP		  = 3'b100;
					
	
	integer r_Clock_Count = 1;
	reg [3:0]	r_Bit_Index	  = 0; 
	reg [7:0]	r_RX_Byte = 0;     
	reg [7:0]	temp_r_RX_Byte = 0;
	reg [2:0]	current_state = 0;
	integer CLOCKS_PER_BIT = 434;
	reg [2:0]   r_current_state = 0;
	
	assign o_RX_Byte = r_RX_Byte;
	assign o_current_state = current_state;
	
	always@(posedge CLOCK)
	begin
	
		case(current_state)
			IDLE :
				begin
					
					if (!i_RX_Serial )
					begin
						current_state <= RX_START_BIT;
						r_current_state <= 1;
						r_Clock_Count <= 1;	
					end
					else
					begin
						current_state <= IDLE;
						
					end
				end 
		
      RX_START_BIT :
			begin
				
				if (r_Clock_Count < (CLOCKS_PER_BIT - 1))
				begin
					  r_Clock_Count <= r_Clock_Count + 1;
					  current_state <= RX_START_BIT;
			   end
			   else
				begin
				  
					r_Clock_Count <= 1;	      
					current_state <= RX_DATA_BITS;
				end				
			end
			

      RX_DATA_BITS :
		begin	
			
			if(r_Bit_Index < 8)
			begin
				if(r_Clock_Count > CLOCKS_PER_BIT - 1)
				begin
					temp_r_RX_Byte[r_Bit_Index]  <= i_RX_Serial;	
					r_Clock_Count = 1;
					r_Bit_Index <= r_Bit_Index + 1;
				end
				
				else
				begin
					r_Clock_Count <= r_Clock_Count + 1;
				end				
			end
			
			else
			begin
				r_Clock_Count = 1;
				current_state <= RX_STOP_BIT;
				
			end				
		end
			
		
		RX_STOP_BIT  :
			begin
				current_state   <= CLEANUP;
				r_RX_Byte <= temp_r_RX_Byte;
			end
			
		
		CLEANUP :
			begin
			   temp_r_RX_Byte <= 0 ;
				r_Clock_Count   <= 1;
				r_Bit_Index <= 0;
				current_state  <= IDLE;
					
			end
	endcase
	end
endmodule
		