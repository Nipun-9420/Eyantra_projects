module sm_0535_uart_controller(
	
	input clk,								//* need to include all units in conditions
	input o_tx_done,							
	input [2:0]color_in,					// ** need to include start detcting color condition for led also
	input [2:0] Unit_at,
	input start_detecting_color,
	output color_detected,
	output tx_data_valid,
	output [7:0] tx_byte,
	output led_R,
	output led_G,
	output led_B
	
	);
	
	// different states
	parameter IDLE = 2'b00,
				 SEND = 2'b01,
				 WAIT = 2'b10;
				  
	// to indicate color
	parameter red_cl = 3'b001,
				 blue_cl = 3'b010,
				 green_cl = 3'b100; 
	
	// indicates units the is at 
	parameter MPU = 3'b001;
	parameter W = 3'b010;
	parameter SSU = 3'b011;
	parameter PU = 3'b100;
	
	// variables
	reg r_tx_data_valid = 0;
	reg [1:0] current_state = IDLE;
	
	integer count = 0 ;
	
	reg [7:0] r_tx_byte;
	
	reg [7:0] msg [11:0];
	reg [2:0] r_color_in; 

	reg [3:0] previous_color_in = 0;
	reg [95:0] temp_msg  = 0;
	
	reg r_led_R = 1; 
	reg r_led_B = 1;
	reg r_led_G = 1;
	
	reg r_color_detected = 0;
	
	// PU msgs
	reg [79:0] PU_green_msg = "SI-PU-CT-#";
	reg [79:0] PU_red_msg = "SI-PU-FI-#";
	reg [79:0] PU_blue_msg = "SI-PU-CP-#";
	
	// MPU msgs
	reg [87:0] MPU_green_msg = "SI-MPU-CT-#";
	reg [87:0] MPU_red_msg = "SI-MPU-FI-#";
	reg [87:0] MPU_blue_msg = "SI-MPU-CP-#";
	
	// W msgs
	reg [71:0] W_green_msg = "SI-W-CT-#";
	reg [71:0] W_red_msg = "SI-W-FI-#";
	reg [71:0] W_blue_msg = "SI-W-CP-#";
	
	//SSU msgs
	reg [87:0] SSU_green_msg = "FR-SSU-CT-#"; //** size is different
	reg [87:0] SSU_red_msg = "FR-SSU-FI-#";
	reg [87:0] SSU_blue_msg = "FR-SSU-CP-#";
	
	
	initial
	begin
		temp_msg[7:0] = 8'h0D;
	end
		
	// initiaizing msg structure  or msg --------------------------------------------------------------------------------
	
	always @ (posedge clk)
	begin

	 
	// Actual message sending------------------------------------------------------------------------------------- 	
		
			case(current_state)
		
			IDLE: // to select which msg to send and to control only one transmission on a particular msg
			begin
				r_tx_data_valid = 0; 
				r_color_in[2:0] = color_in[2:0] > 0 ? color_in[2:0] : previous_color_in[2:0]  ;
				
				// to decide which msg to send
				case(Unit_at)
					
					PU: // when bot is at PU
					begin
						count = 1; 
						case(r_color_in)  // to decide which msg to send
							green_cl:
							begin
								temp_msg[87:8] = PU_green_msg;
								r_led_G = 0;
							end
							red_cl : 
							begin
								temp_msg[87:8] = PU_red_msg;
								r_led_R = 0;
							end
							blue_cl :
							begin
								temp_msg[87:8] = PU_blue_msg;
								r_led_B = 0;
							end
						endcase
					end
					
					W: // when bot is at W
					begin
						count = 1; 
						case(r_color_in)  // to decide which msg to send
							green_cl:
							begin
								temp_msg[79:8] = W_green_msg;
								r_led_G = 0;
							end
							red_cl : 
							begin
								temp_msg[79:8] = W_red_msg;
								r_led_R = 0;
							end
							blue_cl :
							begin
								temp_msg[79:8] = W_blue_msg;
								r_led_B = 0;
							end
						endcase
					end

					SSU: // when bot is at SSU
					begin
						count = 0;
						case(r_color_in)  // to decide which msg to send
							green_cl:
							begin
								temp_msg[95:8] = SSU_green_msg;
								r_led_G = 1;
							end
							red_cl : 
							begin
								temp_msg[95:8] = SSU_red_msg;
								r_led_R = 1;
							end
							blue_cl :
							begin
								temp_msg[95:8] = SSU_blue_msg;
								r_led_B = 1;
							end
						endcase
					end
					
					MPU: // when bot is at MPU
					begin
						count = 0;
						case(r_color_in)  // to decide which msg to send
							green_cl:
							begin
								temp_msg[95:8] = MPU_green_msg;
								r_led_G = 0;
							end
							red_cl : 
							begin
								temp_msg[95:8] = MPU_red_msg;
								r_led_R = 0;
							end
							blue_cl :
							begin
								temp_msg[95:8] = MPU_blue_msg;
								r_led_B = 0;
							end
						endcase
					end
				endcase
				
				msg[0] = temp_msg[95:88];
				msg[1] = temp_msg[87:80];
				msg[2] = temp_msg[79:72];
				msg[3] = temp_msg[71:64];
				msg[4] = temp_msg[63:56];
				msg[5] = temp_msg[55:48];
				msg[6] = temp_msg[47:40];
				msg[7] = temp_msg[39:32];
				msg[8] = temp_msg[31:24];
				msg[9] = temp_msg[23:16];
				msg[10] = temp_msg[15:8];
				msg[11] = temp_msg[7:0];
				
				if((r_color_in != previous_color_in) & start_detecting_color)  // to control only one transmission of message
				begin
					previous_color_in = r_color_in;
					current_state = SEND;
					r_color_detected = 1;
				end 
				else if(!start_detecting_color)
				begin
					r_color_detected = 0;
					current_state = IDLE;
				end
				else current_state = IDLE;
			end
			
			SEND:
			begin 
			   r_tx_data_valid = 1;
			   r_tx_byte = msg[count];
			   if (!o_tx_done)
			   begin
					current_state = WAIT;
			   end
			   else
			   begin
					current_state = SEND;
			   end
			end   
	
			WAIT:
			begin
				r_tx_data_valid = 0;
				if ( o_tx_done )
				begin
					current_state = SEND;
					count = count + 1;
					if (count > 11)
					begin
						count = 0;
						current_state = IDLE;
					end
				end
				else
				begin
					current_state = WAIT;
				end
			end
			endcase

	end
	
	
	// assiging output
	assign tx_data_valid = r_tx_data_valid ;
	assign tx_byte = r_tx_byte;
	
	assign led_R = r_led_R;
	assign led_G = r_led_G;
	assign led_B = r_led_B;
	
	assign color_detected = r_color_detected;
	
endmodule	
			
			
			
			
			
			
			
			
			
			
			
		
		
		
		
		
		
		
		
	