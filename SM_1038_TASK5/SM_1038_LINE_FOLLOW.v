

module control_bot(
	input clk,
	input [2:0] adc_data,
	output [6:0] speed_a1_a , // speed of right motor 
	output [6:0] speed_b1_a , // speed of right motor
	output [6:0] speed_a1_b , // speed of left motor
	output [6:0] speed_b1_b,  // speed of left motor
	

	
	//*******************LED Output**********************
	output l_1,
	output l_2,
	output l_3,
	output l_4,
	
	//**************Electromagnet Output******************
	output elctro,
	output elctro_start,
	output elctro_d,
	//**************Color output
	output start_detecting
	
	//*****************************************
);


	reg r_elctro_start;
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


	reg r_elctro ;
	reg r_elctro_d ;

// varialbles for speed
	reg [6:0] r_speed_a1_a ; // speed of right motor 
	reg [6:0] r_speed_a1_b  ; // speed of right motor
	reg [6:0] r_speed_b1_a ; // speed of left motor
	reg [6:0] r_speed_b1_b  ; // speed of left mot
	
	// for nodes 4 bits regs
	reg c_d ;
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
				r_speed_a1_b = 85;//79
				r_speed_b1_b = 50;//34
			end
			
			//------------------right_turn-------------------
			3'b011 :
			begin
				r_speed_a1_a = 0; 
				r_speed_b1_a = 0; 
				r_speed_a1_b = 85;//79
				r_speed_b1_b = 55;//39
			end
			//-----------------straight--------------------
			3'b010 :
			begin	
				r_speed_a1_a = 0; 
				r_speed_b1_a = 0; 
				r_speed_a1_b = 80;//62.5
				r_speed_b1_b = 77;//58.5
			end

			//-----------------left_turn----------------
			3'b110 :
			begin
				r_speed_a1_a = 0; 
				r_speed_b1_a = 0; 
				r_speed_a1_b = 40;
				r_speed_b1_b = 80;
			end
			//-------------------left_arc-----------
			3'b100 :
			begin
				r_speed_a1_a = 0; 
				r_speed_b1_a = 0; 
				r_speed_a1_b = 40;
				r_speed_b1_b = 80;
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
		r_speed_b1_a = 35;
		r_speed_a1_b = 90;
		r_speed_b1_b = 0; 
		end
	endtask
	
	task turn_left (); // to turn left
		begin
		r_speed_a1_a = 40;
		r_speed_b1_a = 0;
		r_speed_a1_b = 0;
		r_speed_b1_b = 85; 
		end
	endtask
	
	
	task go_straight (); // to go straight speed should be as low as possible
		begin
		r_speed_a1_a = 0;
		r_speed_b1_a = 0;
		r_speed_a1_b = 80;
		r_speed_b1_b = 77;
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
	
	reg[32:0]c_T=0;
	
	
	//reg elctro_d;
 /////////////////////////////////////////////////////////////////// 
 
	//********************Main Function*************
	always @ (posedge clk_o)
	begin
	
	r_elctro_start=1;
	if(c_T< 1000000)
	begin////////////////*********PICK box
	r_elctro_d=0;
	r_elctro=1;
	c_T=c_T+1;
	end
	else
	begin////////////////********drop Box
	r_elctro_d=1;
	r_elctro=0;
	end
	/*
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
							r_speed_a1_b = 60;
							r_speed_b1_b = 60;
							
							current_node =  next_node;
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
		   
		node_1:
		begin
			next_node = node_2;
			action_to_take = go_st;
			current_node = wait_for_node;
			//**********************************
			r_l_1 = 1; 
			r_l_2 = 0;
			r_l_3 = 0;
			r_l_4 = 0;
			//**********************************
			c_d = 0;
		end
		
		node_2:
		begin
			next_node = node_3;
			action_to_take = go_st;
			current_node = wait_for_node;
			//**********************************
			r_l_1 = 0; 
			r_l_2 = 1;
			r_l_3 = 0;
			r_l_4 = 0;
			//**********************************
			c_d = 0;
		end
		
		node_3:
		begin
			
			action_to_take = turn_R;
			
			current_node = wait_for_node;
			next_node = node_4;
			//**********************************
			r_l_1 = 1; 
			r_l_2 = 1;
			r_l_3 = 1;
			r_l_4 = 1;
			//**********************************
			c_d = 0;
			r_elctro =0;
		end
			
		node_4:
		begin

			r_speed_a1_a = 100;
			r_speed_b1_a = 100;
			r_speed_a1_b = 0;
			r_speed_b1_b = 0;
			if (adc_data == 3'b010)
			begin
			//current_node = wait_for_node;
			next_node =node_6;
			r_speed_a1_a = 100;
			r_speed_b1_a = 100;
			r_speed_a1_b = 0;
			r_speed_b1_b = 0;
			current_node = node_4;
			end
			if (adc_data == 3'b010)
			begin
			//current_node = wait_for_node;
			//next_node =node_6;
			r_speed_a1_a = 100;
			r_speed_b1_a = 100;
			r_speed_a1_b = 0;
			r_speed_b1_b = 0;
			current_node = node_4;
			end
			
			if (adc_data == 3'b111)
			begin
			r_speed_a1_a = 100;
			r_speed_b1_a = 100;
			r_speed_a1_b = 0;
			r_speed_b1_b = 0;
			current_node = node_4;
			if (adc_data == 3'b111) current_node = wait_for_node;
			end
			
			r_speed_a1_a = 100;
			r_speed_b1_a = 100;
			r_speed_a1_b = 0;
			r_speed_b1_b = 0;
			//**********************************
			r_l_1 = 0; 
			r_l_2 = 0;
			r_l_3 = 1;
			r_l_4 = 0;
			
		   r_elctro =0;
			//**********************************
			c_d = 0;
		end
			
		node_5:
		begin
			next_node = node_6;
			r_speed_a1_a = 100;
			r_speed_b1_a = 0;
			r_speed_a1_b = 0;
			r_speed_b1_b = 100;
			current_node = wait_for_node;
			//**********************************
			r_l_1 = 1; 
			r_l_2 = 0;
			r_l_3 = 1;
			r_l_4 = 0;
			//**********************************
		   c_d = 0;
			r_elctro =0;
		end
			
		node_6:
		begin
			next_node = node_7;
			action_to_take = turn_R;;
			current_node = wait_for_node;
			//**********************************
			r_l_1 = 0; 
			r_l_2 = 1;
			r_l_3 = 1;
			r_l_4 = 0;
			//**********************************
			c_d = 0;
			r_elctro =0;
		end
		
		node_7:
		begin
				next_node = node_8;
				action_to_take = go_st;
				current_node = wait_for_node;
			//**********************************
				r_l_1 = 0; 
				r_l_2 = 0;
				r_l_3 = 0;
				r_l_4 = 1;
			//**********************************
				c_d = 0;
				r_elctro =0;
			
		end
				
		node_8:
		begin
				next_node = node_0;
				action_to_take = go_st;
				current_node = wait_for_node;
			//**********************************
				r_l_1 = 0; 
				r_l_2 = 0;
				r_l_3 = 0;
				r_l_4 = 1;
			//**********************************
				c_d = 0;
				r_elctro =0;
    	end
		
			
	   node_0:
		begin
			r_speed_a1_a = 0;
			r_speed_b1_a = 0;
			r_speed_a1_b = 0;
			r_speed_b1_b = 0;
			r_elctro =1;
		end
		
		default:
		begin
			r_l_1 = 0; 
			r_l_2 = 0;
			r_l_3 = 0;
			r_l_4 = 0;
		end
		endcase*/
	end
	
	//assigning output
	assign elctro_start=r_elctro_start;
	assign elctro_d = r_elctro_d;
	assign elctro = r_elctro;
	assign start_detecting = c_d;
	assign speed_a1_a =  r_speed_a1_a ; 
	assign speed_a1_b =  r_speed_a1_b ;
	assign speed_b1_a =  r_speed_b1_a ; 
	assign speed_b1_b =  r_speed_b1_b ;
	
endmodule
