

module control_bot(
	input clk,
	input [2:0] adc_data,
	output [6:0] speed_a1_a , // speed of right motor 
	output [6:0] speed_b1_a , // speed of right motor
	output [6:0] speed_a1_b , // speed of left motor
	output [6:0] speed_b1_b,  // speed of left motor
	
	//*****************************************
	output l_1,
	output l_2,
	output l_3,
	output l_4,
	
	output start_detecting
	
	//*****************************************
);

//********************************************
	reg r_l_1 = 0; 
	reg r_l_2 = 0;
	reg r_l_3 = 0;
	reg r_l_4 = 0;
	
	assign l_1 = r_l_1;
	assign l_2 = r_l_2;
	assign l_3 = r_l_3;
	assign l_4 = r_l_4;	
//********************************************




// varialbles for speed
	reg [6:0] r_speed_a1_a ; // speed of right motor 
	reg [6:0] r_speed_a1_b = 0 ; // speed of right motor
	reg [6:0] r_speed_b1_a = 0 ; // speed of left motor
	reg [6:0] r_speed_b1_b = 0 ; // speed of left mot
	
	// for nodes 4 bits regs
	reg c_d = 1;
	reg [5:0] counter = 1;
	reg [3:0] current_node = wait_for_node;  // to indicate current node 
	reg [3:0] next_node =node_1 ;  // to indicate next node	 		
	
	//for actions and processes			
	reg [2:0] action_to_take = follow_line ;  // 3 bit  to hold the actions(turns) to take		
		
	// defining states to use in the state macine logic
	parameter wait_for_node = 4'b0000;
	parameter node_1 = 4'b0001;
	parameter node_2 = 4'b0010;
	parameter node_3 = 4'b0011;
	parameter node_4 = 4'b0100;
	parameter node_5 = 4'b0101; 
	parameter node_6 = 4'b0110;
	parameter node_7 = 4'b0111;
	parameter node_8 = 4'b1000;
	parameter node_0 = 4'b1001;
	
	//--------------node_condition------------------
	
	parameter	follow_line = 3'b000;
	parameter	turn_R = 3'b001;
	parameter	turn_L = 3'b011;
	parameter	go_st = 3'b110;
	parameter	turn_Node_R = 3'b010;
	
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
				r_speed_a1_b = 70;//79
				r_speed_b1_b = 35
				;//34
			end
			
			//------------------right_turn-------------------
			3'b011 :
			begin
				r_speed_a1_a = 0; 
				r_speed_b1_a = 0; 
				r_speed_a1_b = 65;//79
				r_speed_b1_b = 31;//39
			end
			//-----------------straight--------------------
			3'b010 :
			begin	
				r_speed_a1_a = 0; 
				r_speed_b1_a = 0; 
				r_speed_a1_b = 60.5;//62.5
				r_speed_b1_b = 57.5;//58.5
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
		r_speed_b1_a = 80;//65
		r_speed_a1_b = 90;//75
		r_speed_b1_b = 0; 
		end
	endtask
	
	task turn_n_right ();  // to turn right
		begin
		r_speed_a1_a = 0;
		r_speed_b1_a = 82;//65
		r_speed_a1_b = 90;//75
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
		r_speed_a1_b = 60;
		r_speed_b1_b = 56;
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
 
	//********************Main Function*************
	always @ (posedge clk_o)
	begin
	
	line_follow();
		case(current_node)
		
		wait_for_node:
		begin
			case(action_to_take)
					
				follow_line:
					begin
						line_follow();
						if( adc_data == 3'b111)	
						begin
					
							r_speed_a1_a = 0; 
							r_speed_b1_a = 0; 
							r_speed_a1_b = 55;
							r_speed_b1_b = 58;
							current_node =  next_node;
						end
					end
					
					turn_R:
					begin
						turn_right();
						if (adc_data != 3'b111 &  adc_data != 3'b000 & (adc_data == 3'b001||adc_data == 3'b011)) action_to_take = follow_line;
					end
					
					turn_Node_R:
					begin
						turn_n_right();
						if (adc_data != 3'b111 &  adc_data != 3'b000 &  adc_data == 3'b001) action_to_take = follow_line;
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
		   
		node_1:
		begin
			c_d = 0;
			next_node = node_2;
			action_to_take = go_st;
			current_node = wait_for_node;
			//**********************************
			r_l_1 = 1; 
			r_l_2 = 0;
			r_l_3 = 0;
			r_l_4 = 0;
			//**********************************
			
		end
		
		node_2:
		begin
			c_d = 0;
			next_node = node_3;
			action_to_take = turn_R;
			current_node = wait_for_node;
			//**********************************
			r_l_1 = 0; 
			r_l_2 = 1;
			r_l_3 = 0;
			r_l_4 = 0;
			//**********************************
		end
		
		node_3:
		begin
			c_d = 0;
			next_node = node_4;
			action_to_take = go_st;
			current_node = wait_for_node;
			//**********************************
			r_l_1 = 1; 
			r_l_2 = 1;
			r_l_3 = 0;
			r_l_4 = 0;
			//**********************************
			
		end
			
		node_4:
		begin
			c_d = 0;
			next_node = node_5;
			action_to_take = go_st;
			current_node = wait_for_node;
			//**********************************
			r_l_1 = 0; 
			r_l_2 = 0;
			r_l_3 = 1;
			r_l_4 = 0;
			//**********************************
			
		end
			
		node_5:
		begin
			c_d = 1;
			next_node = node_6;
			action_to_take = turn_R;
			current_node = wait_for_node;
			//**********************************
			r_l_1 = 1; 
			r_l_2 = 0;
			r_l_3 = 1;
			r_l_4 = 0;
			//**********************************
		   
		end
			
		node_6:
		begin
			c_d = 0;
			next_node = node_7;
			action_to_take = go_st;
			current_node = wait_for_node;
			//**********************************
			r_l_1 = 0; 
			r_l_2 = 1;
			r_l_3 = 1;
			r_l_4 = 0;
			//**********************************
			
		end
		
		node_7:
		begin
		
			if (counter == 2)
			begin
				c_d = 0;
				next_node = node_0;
				action_to_take = go_st;
				current_node = wait_for_node;
			
			end
			else
			begin
				c_d = 1;
				counter = counter + 1;
				next_node = node_8;
				action_to_take = turn_R;
				current_node = wait_for_node;
			//**********************************
				r_l_1 = 1; 
				r_l_2 = 1;
				r_l_3 = 1;
				r_l_4 = 0;
			//**********************************
				
			end
		end
				
		node_8:
		begin
				c_d = 1;
				next_node = node_1;
				action_to_take = go_st;
				current_node = wait_for_node;
			//**********************************
				r_l_1 = 0; 
				r_l_2 = 0;
				r_l_3 = 0;
				r_l_4 = 1;
			//**********************************
				
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
		end
		endcase
	end
	
	//assigning output
	
	assign start_detecting = c_d;
	assign speed_a1_a =  r_speed_a1_a ; 
	assign speed_a1_b =  r_speed_a1_b ;
	assign speed_b1_a =  r_speed_b1_a ; 
	assign speed_b1_b =  r_speed_b1_b ;
	
endmodule
