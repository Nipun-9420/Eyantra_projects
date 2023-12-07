module control_bot(
	input clk,
	input [2:0] adc_data,
	output [6:0] speed_a1_a , // speed of right motor 
	output [6:0] speed_b1_a , // speed of right motor
	output [6:0] speed_a1_b , // speed of left motor
	output [6:0] speed_b1_b,  // speed of left motor
	
	//***************
	output l_1,
	output l_2,
	output l_3,
	output l_4,
	
	output start_detecting
	
	//***************
);

//****************
	reg r_l_1 = 0; 
	reg r_l_2 = 0;
	reg r_l_3 = 0;
	reg r_l_4 = 0;
	
	assign l_1 = r_l_1;
	assign l_2 = r_l_2;
	assign l_3 = r_l_3;
	assign l_4 = r_l_4;	
//****************
	



// varialbles for speed
	reg [6:0] r_speed_a1_a ; // speed of right motor 
	reg [6:0] r_speed_a1_b = 0 ; // speed of right motor
	reg [6:0] r_speed_b1_a = 0 ; // speed of left motor
	reg [6:0] r_speed_b1_b = 0 ; // speed of left mot
	
	// for nodes 4 bits regs
	reg c_d = 1;
	reg [5:0] counter = 1;
	reg [6:0] current_node = wait_for_node;  // to indicate current node 
	reg [6:0] next_node [9:0];  // to indicate next node	
	reg [6:0] previous_node;
	reg [6:0] next;	
	
	//for actions and processes			
	reg [2:0] action_to_take = follow_line ;  // 3 bit  to hold the actions(turns) to take		
		
	// defining states to use in the state macine logic
	parameter wait_for_node = 7'b0000001;
	parameter n_8 = 7'b0001000;
	parameter n_0 = 7'b0000000;
	parameter n_2 = 7'b0000010;
	parameter n_3 = 7'b0000011;
	parameter n_6 = 7'b0000110; 
	parameter n_14 = 7'b001110;
	parameter n_12 = 7'b001100;
	parameter n_11 = 7'b001011;
	parameter n_18 = 7'b010010;
	
	//--------------node_condition------------------
	
	parameter	follow_line = 3'b000;
	parameter	turn_R = 3'b001;
	parameter	turn_L = 3'b011;
	parameter	go_st = 3'b110;
	
	
	
	//**********
	initial
	begin
		next_node[0]=33;
		next_node[1]=8;
		next_node[2]=0;
		next_node[3]=2;
		next_node[4]=3;
		next_node[5]=6;
		next_node[6]=14;
		next_node[7]=12;
		next_node[8]=11;
		next_node[9]=18;
	end
	
	// defining tasks for line following and turning ---------------------------------------------------------------------------------------
 	task line_follow ();  // this is used to follow line
	begin
		// adac_data is 3 bit bus and the bits represent the sensors itself. '1' means line detected '0' otherwise
		case (adc_data)
							// MSB is left_sensor and LSB is right_sensor
			3'b001 :
			begin
				r_speed_a1_a = 0;
				r_speed_b1_a = 0; 
				r_speed_a1_b = 79;//79
				r_speed_b1_b = 44;//34
			end
			
			//------------------right_turn-------------------
			3'b011 :
			begin
				r_speed_a1_a = 0; 
				r_speed_b1_a = 0; 
				r_speed_a1_b = 79;//79
				r_speed_b1_b = 49;//39
			end
			//-----------------straight--------------------
			3'b010 :
			begin	
				r_speed_a1_a = 0; 
				r_speed_b1_a = 0; 
				r_speed_a1_b = 62.5;//62.5
				r_speed_b1_b = 58.5;//58.5
			end

			//-----------------left_turn----------------
			3'b110 :
			begin
				r_speed_a1_a = 0; 
				r_speed_b1_a = 0; 
				r_speed_a1_b = 29;
				r_speed_b1_b = 74;
			end
			//-------------------left_arc-----------
			3'b100 :
			begin
				r_speed_a1_a = 0; 
				r_speed_b1_a = 0; 
				r_speed_a1_b = 24;
				r_speed_b1_b = 74;
		   end
			
			3'b000 :
			begin
				r_speed_a1_a = 0; 
				r_speed_b1_a = 90; 
				r_speed_a1_b = 75;
				r_speed_b1_b = 0;
			end
		endcase
	end
	endtask
	
	task turn_right ();  // to turn right
		begin
		r_speed_a1_a = 0;
		r_speed_b1_a = 65;
		r_speed_a1_b = 75;
		r_speed_b1_b = 0; 
		end
	endtask
	
	task turn_left (); // to turn left
		begin
		r_speed_a1_a = 60;
		r_speed_b1_a = 0;
		r_speed_a1_b = 0;
		r_speed_b1_b = 95; 
		end
	endtask
	
	
	task go_straight (); // to go straight speed should be as low as possible
		begin
		r_speed_a1_a = 0;
		r_speed_b1_a = 0;
		r_speed_a1_b = 62.5;
		r_speed_b1_b = 58.5;
		end
	endtask
	
	//-----------------clock_scaling---------------------------------
	
	reg clk_o =0;
	reg [20:0] count;
	reg [31:0] n;
	
	initial
	begin
		count =1 ;
		n =500;
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
 /////////////////////////////////////////////////////////////////// 
 
	//*******Main Function****
	always @ (posedge clk_o)
	begin
	
	line_follow();
		case(current_node)
		
		wait_for_node:
		begin
			case(action_to_take)
					
				follow_line:
					begin
						if (next == 33)
						begin
							r_speed_a1_a = 0;
							r_speed_b1_a = 65;
							r_speed_a1_b = 75;
							r_speed_b1_b = 0; 
							next = 8;
							previous_node = 33;
						end
						
						else
						begin
							if( adc_data == 3'b111)	
							begin
							
								line_follow();
								current_node =  next;
								previous_node = current_node;
							end
						end
					end
					
					turn_R:
					begin
						turn_right();
						if (adc_data != 3'b111 &  adc_data != 3'b000 & (adc_data == 3'b001 || adc_data == 3'b011)) action_to_take = follow_line;
					end
					
					turn_L:
					begin
						turn_left();
						if (adc_data != 3'b111 &  adc_data != 3'b000) action_to_take = follow_line;
					end

					go_st:
					begin
						go_straight();
						if (adc_data != 3'b111 &  adc_data != 3'b000 &  (adc_data == 3'b010)) action_to_take = follow_line;
					end
				endcase
			end

		n_8:
		begin
			next = next_node[2];
			case(previous_node)
			33:
			begin
				case(next)
				n_0:
				begin
					action_to_take = go_st;
					current_node = wait_for_node;
					c_d = 0;
				end
				endcase
			end
			endcase
			
		end
		
		n_0:
		begin
			next = next_node[3];
			case(previous_node)
			n_8:
			begin
				case(next)
				n_2:
				begin
					action_to_take = go_st;
					current_node = wait_for_node;
					c_d = 0;
				end
				endcase
			end
			endcase
		end
		
		n_2:
		begin
			next = next_node[4];
			case(previous_node)
			n_0:
			begin
				case(next)
				n_3:
				begin
					action_to_take = go_st;
					current_node = wait_for_node;
					c_d = 0;
				end
				endcase
			end
			endcase
		end
		
		n_3:
		begin
			next = next_node[5];
			case(previous_node)
			n_2:
			begin
				case(next)
				n_6:
				begin
					action_to_take = turn_L;
					current_node = wait_for_node;
					c_d = 0;
				end
				endcase
			end
			endcase
		end
			
		n_6:
		begin
			next = next_node[6];
			case(previous_node)
			n_3:
			begin
				case(next)
				n_14:
				begin
					action_to_take = go_st;
					current_node = wait_for_node;
					c_d = 0;
				end
				endcase
			end
			endcase
		end
			
		n_14:
		begin
			next = next_node[7];
			case(previous_node)
			n_6:
			begin
				case(next)
				n_12:
				begin
					action_to_take = turn_L;
					current_node = wait_for_node;
					c_d = 0;
				end
				endcase
			end
			endcase
		end
			
		n_12:
		begin
			next = next_node[8];
			case(previous_node)
			n_14:
			begin
				case(next)
				n_11:
				begin
					action_to_take = go_st;
					current_node = wait_for_node;
					c_d = 0;
				end
				endcase
			end
			endcase
		end
		
		n_11:
		begin
			next = next_node[9];
			case(previous_node)
			n_12:
			begin
				case(next)
				n_18:
				begin
					action_to_take = turn_R;
					current_node = wait_for_node;
					c_d = 0;
				end
				endcase
			end
			endcase
		end
		
		n_18:
		begin
			//next = next_node[2];
			case(previous_node)
			n_11:
			begin
				r_speed_a1_a = 0;
				r_speed_b1_a = 0;
				r_speed_a1_b = 0;
				r_speed_b1_b = 0;
			end
			endcase
		end
		
		/*node_7:
		begin
		
			if (counter == 2)
			begin
			
				next_node = node_0;
				action_to_take = go_st;
				current_node = wait_for_node;
			
			end
			else
			begin
				counter = counter + 1;
				next_node = node_8;
				action_to_take = turn_R;
				current_node = wait_for_node;
			//************
				r_l_1 = 1; 
				r_l_2 = 1;
				r_l_3 = 1;
				r_l_4 = 0;
			//************
				c_d = 1;
			end
		end*/
				
		/*node_8:
		begin
				next_node = node_1;
				action_to_take = go_st;
				current_node = wait_for_node;
			//************
				r_l_1 = 0; 
				r_l_2 = 0;
				r_l_3 = 0;
				r_l_4 = 1;
			//************
				c_d = 1;
    	end
		
			
	   node_0:
		begin
			r_speed_a1_a = 0;
			r_speed_b1_a = 0;
			r_speed_a1_b = 0;
			r_speed_b1_b = 0;
		end
		
		default:
		begin
			r_l_1 = 0; 
			r_l_2 = 0;
			r_l_3 = 0;
			r_l_4 = 0;
		end*/
		endcase
	end
	
	//assigning output
	
	assign start_detecting = c_d;
	assign speed_a1_a =  r_speed_a1_a ; 
	assign speed_a1_b =  r_speed_a1_b ;
	assign speed_b1_a =  r_speed_b1_a ; 
	assign speed_b1_b =  r_speed_b1_b ;
	
endmodule
