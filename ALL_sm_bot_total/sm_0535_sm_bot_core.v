Qmodule sm_0535_sm_bot_core(  //  always double check bits whether no of bits assigned to variables are enough
	input clk_core,				// ** check if counters are updated properly
	
	input [2:0] adc_data,
	input color_detected,		// * considering bot can climb bridge 	
	
	input [16:0] path,
	
	output [6:0] speed_a1_a , // speed of right motor 
	output [6:0] speed_a1_b , // speed of right motor
	output [6:0] speed_b1_a , // speed of left motor
	output [6:0] speed_b1_b , // speed of left motor

	output start_detecting,
	output [2:0] Unit_at,			// * review code to remove unnecessary test cases
	
	output [3:0] o_current_node,
	output [2:0] o_current_unit

	);									// * reverify previous_unit , next_unit and current_unit especially during detection
										// * include START and STOP units properly
										// * comment the reasons why you skipped a few conditions/cases 
										// * check initialaization of variables 
										// * code can have begin end problem
										// ** updation of variables for eg: start_detcting
										// ** check pll for debuging
										// * include color_sensor varible to indicate color detected or not
										// * check in change unit node is include in every node's next_node case
										// ** check if color_detection_status are proper
										// * code needs to be changed a bit to include node 1 as it is detected know
										     
										// * check if next_node change_unit is updated in every node 
										
										
										//* current node , previous node and next node issue at change unit node
										
										// ** need to add reciever and proper integration
										
										// ** check if nodes_to_follow is proper
										
	// there is some problem in PU
										
	/* things to do --------
	 1. simple turns and arc_turns 
	 2. try PID code
	 3. find out optimum speed for straight line for both the motors.
	 
	 4. follow the code considering faults detected at every unit.
	 5. follow the code considering not faults detected at any unit.
	*/									
										
	
	/* to_detect nodes_to_follow is slightly not proper at MPU and SSU 
		more cases needed to be considered especially when transitioning between to_detect and detected nodes_to_follow*/
	
	
	
	// varialbles for speed
	reg [6:0] r_speed_a1_a = 0 ; // speed of right motor 
	reg [6:0] r_speed_a1_b = 0 ; // speed of right motor
	reg [6:0] r_speed_b1_a = 0 ; // speed of left motor
	reg [6:0] r_speed_b1_b = 0 ; // speed of left motor
	
	reg r_start_detecting ; // to signal uart controller to consider color detection valid
	 
	
	// for node_tasks 1 bit reg
	reg current_node_task ;
	
	// for units 3 bits regs
	reg [2:0] current_unit ;  // to indicate current node 
	reg [2:0] next_unit ;  // to indicate next node				
	reg [2:0] previous_unit ; // to indicate previous unit	
	
	// for current process to detect color or not to detect
	reg  current_process ; // 1 bit reg to indicate processes to be done	
	reg [1:0] detection_status ; // 2 bit reg to indicate color detection status		
	
	// for nodes 4 bits regs
	reg [3:0] current_node ;  // to indicate current node 
	reg [3:0] next_node ;  // to indicate next node	 		
	reg [3:0] previous_node ; // to indicate previous node
	
	//for actions and processes			
	reg [2:0] action_to_take  ;  // 3 bit  to hold the actions(turns) to take		
	
	// arrays
	reg [2:0] units_to_visit [6:0]	; // 3 bit array of 7 regs to hold the units to vist 
	reg [3:0] nodes_to_follow [4:0]	; // 4 bit array of 5 regs yo hold nodes to follow	
	
	// counters
	reg [3:0] sequence_no ;	// for nodes 
	reg [3:0] unit_no ; // for units 	
	
	// defining node_tasks to be carried out
	parameter nodes_to_decide = 1'b0;
	parameter node_follow = 1'b1;
	
	// defining states to use in the state machine logic
	parameter START = 3'b000;
	parameter MPU = 3'b001;
	parameter W = 3'b010;
	parameter SSU = 3'b011;
	parameter PU = 3'b100;
	parameter STOP = 3'b101; 
	
	// defining processes to be done at different units
	parameter	color_detection = 1'b0;
	parameter	go_to_next_unit = 1'b1;
	
	// defining color detections status
	parameter	to_detect = 2'b00;
	parameter	detecting= 2'b01;
	parameter	detected = 2'b10;
	parameter	not_detected = 2'b11;

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
	parameter node_9 = 4'b1001;
	parameter node_10 = 4'b1010;
	parameter node_11 = 4'b1011;
	parameter node_0 = 4'b1100;
	parameter change_unit = 4'b1101; //********
	
	// defining actions to take at different node
	parameter	follow_line = 3'b000;
	parameter	turn_R = 3'b001;
	parameter	turn_R_arc = 3'b010;
	parameter	turn_L = 3'b011;
	parameter	turn_L_arc = 3'b100;
	parameter	turn_A = 3'b101;
	parameter	go_st = 3'b110;
	
// -----------------------------------------------initialization--------------------------------------------------------	
	initial
	begin
		
		// initializing node_task
		current_node_task = nodes_to_decide;
		
		// initializing unit
		current_unit = START;
		
		// initializing counters
		sequence_no = 0;
		unit_no = 0;
		
		// initializing color detecting signal
		r_start_detecting = 0;
		
		// initializing detection_status
		detection_status = not_detected;
	end
	
	
// defining tasks for line following and turning ---------------------------------------------------------------------------------------
 	task line_follow ();  // this is used to follow line
	begin
		// adac_data is 3 bit bus and the bits represent the sensors itself. '1' means line detected '0' otherwise
		case (adc_data)
							// MSB is left_sensor and LSB is right_sensor
			
			3'b001 :
			begin
				r_speed_a1_a = 60; //96 60 2 80
				r_speed_b1_a = 20; //15 15 5
				r_speed_a1_b = 0;
				r_speed_b1_b = 0;
			end
			
			3'b011 :
			begin
				r_speed_a1_a = 55; //90 50 3 70
				r_speed_b1_a = 25; //70 30 10
				r_speed_a1_b = 0;
				r_speed_b1_b = 0;
			end
			
			3'b010 :
			begin	
				r_speed_a1_a = 50; //85 30 50
				r_speed_b1_a = 50; //91 30 60
				r_speed_a1_b = 0;
				r_speed_b1_b = 0;
			end
			
			3'b110 :
			begin
				r_speed_a1_a = 25; //50 30 10
				r_speed_b1_a = 55; //91 50 3 70
				r_speed_a1_b = 0;
				r_speed_b1_b = 0;
			end
			
			3'b100 :
			begin
				r_speed_a1_a = 20; //15 15 5
				r_speed_b1_a = 60; //90 60 2 80
				r_speed_a1_b = 0;
				r_speed_b1_b = 0;
			end
			
			3'b111 : // node condition 
			begin
				r_speed_a1_a = 35; //35 35 0
				r_speed_b1_a = 35; //35 35 0
				r_speed_a1_b = 0;
				r_speed_b1_b = 0;
			end
			
			3'b000 : // node condition 
			begin
				r_speed_a1_a = 0; //35 35 0
				r_speed_b1_a = 0; //35 35 0
				r_speed_a1_b = 35;
				r_speed_b1_b = 35;
			end
			
		endcase
	end
	endtask
	
	task turn_right ();  // to turn right
		begin
		r_speed_a1_a = 68;
		r_speed_b1_a = 0;
		r_speed_a1_b = 0;
		r_speed_b1_b = 30; 
		end
	endtask
	
	task turn_right_arc ();  // to turn right arc * need to modify
		begin
		r_speed_a1_a = 68;
		r_speed_b1_a = 20;
		r_speed_a1_b = 0;
		r_speed_b1_b = 0; 
		end
	endtask
	
	task turn_left (); // to turn left
		begin
		r_speed_a1_a = 0;
		r_speed_b1_a = 68;
		r_speed_a1_b = 30;
		r_speed_b1_b = 0; 
		end
	endtask
	
	task turn_left_arc (); // to turn left arc * need to modify
		begin
		r_speed_a1_a = 20;
		r_speed_b1_a = 68;
		r_speed_a1_b = 0;
		r_speed_b1_b = 0; 
		end
	endtask
	
	task go_straight (); // to go straight speed should be as low as possible
		begin
		r_speed_a1_a = 60;
		r_speed_b1_a = 55;
		r_speed_a1_b = 0;
		r_speed_b1_b = 0;
		end
	endtask
	
	task turn_around (); 
		begin
		r_speed_a1_b = 65;
		r_speed_b1_a = 65;
		r_speed_a1_a = 0;
		r_speed_b1_b = 0; 
		end
	endtask
	
//--------------------------------------line_follow_alorithm--------------------------------------------------------------	
	// working code -------------------------------------------------------------------------------------------------------------------------------------
	
		/* this algoritm works considering
		1. its cuurent unit
		2. if it is there to detect color or to move to another unit
		3. if to detect color then its color detection status if dtetct or not detected or to be detected
		4. then it decied which node to follow
		5. if detected it tend to go to SSU
		6. it takes necessary action/turn to reach the specified node considering availability of path
		p.s. this code only considers unavailability of one arch paths in a full circular path 
		and favours clockwise rotation in it every action for eg: in checking units for faults and while moving between node*/
	
always @ (posedge clk_core)
begin

	case(current_node_task)
	
	nodes_to_decide:
	begin
	
		
		// these conditions and checks are common for all units to start deetcting and end detecting 
		
		if(current_process == color_detection)
		begin
			case( detection_status)
				
				to_detect:
				begin
					r_start_detecting = 1;
				end
			
				detecting:
				begin
					r_start_detecting = 0;
					if (color_detected) 
					begin
						detection_status = detected;
					end
					else
					begin
						detection_status = not_detected;
					end
				end
			
			endcase
		end
		else
		begin
			r_start_detecting = 0;
		end

		case(current_unit) 
		
			START: // in this unit sequence of units to check is decided and node to follow for the same
			begin
				
				previous_unit = START;
				
				if(path[1]) 
				begin
					units_to_visit[0] = MPU;
					units_to_visit[1] = SSU;
					units_to_visit[2] = W;
					units_to_visit[3] = SSU;
					units_to_visit[4] = PU;
					units_to_visit[5] = SSU;
					units_to_visit[6] = STOP;
					
					nodes_to_follow[0] = node_1;
					nodes_to_follow[1] = node_2;
					nodes_to_follow[2] = change_unit;
				end
				else
				begin
					units_to_visit[0] = PU;
					units_to_visit[1] = SSU;
					units_to_visit[2] = MPU;
					units_to_visit[3] = SSU;
					units_to_visit[4] = W;
					units_to_visit[5] = SSU;
					units_to_visit[6] = STOP;
					
					nodes_to_follow[0] = node_1;
					nodes_to_follow[1] = node_11;
					nodes_to_follow[2] = change_unit;
				end
			
				current_node_task = node_follow; 
				next_unit = units_to_visit[0];
				current_process = color_detection; 
				detection_status = to_detect;
				
				current_node = wait_for_node;
				previous_node = node_0;
				next_node = nodes_to_follow[0];
				
				action_to_take = follow_line;

			end
		
	// -----------------------------------------current unit is MPU -----------------------------------------------------------------------------
		
		
			MPU: 
			begin
				unit_no = unit_no + 1;
				next_unit = units_to_visit[unit_no];
				
				case(current_process)
					
					color_detection:
					begin
						
						case(previous_unit)
							
							W: // if bot arrives from W --------------------------------------------------------------------
							// if bot arrives from W for color detection it implies that path 16 i.e. B and path 1 are 
							// unavailable thus it came from SSU via W
							// also that PU detection has been completed and W and MPU are the only units remaining
							
							begin
								previous_unit = current_unit;
								case(detection_status)
								
								to_detect: // check for faults
								begin
									sequence_no = 0;
									if(!path[11])
									begin
										nodes_to_follow[1] = node_3;
									end
									else
									begin
										nodes_to_follow[1] = node_2;
									end
									nodes_to_follow[2] = node_4;
									nodes_to_follow[3] = change_unit;
									current_node_task = node_follow;
									next_unit = MPU;
									unit_no = unit_no - 1;
									current_process = color_detection;
									detection_status = detecting;
									previous_unit = W;
								end
								
								
								detected:   // faults detected go to SSU for remidies
								begin		 
									// here as path 1 and path 16 are unavailable therefore only one way to reach SSU
									sequence_no = 0;
									nodes_to_follow[1] = node_5;
									nodes_to_follow[2] = change_unit;
									current_node_task = node_follow;
									next_unit = W;
									unit_no = unit_no - 1;
									current_process = go_to_next_unit;
									detection_status = to_detect;
								end
				
								not_detected: // no faults detected go to remaining units
								begin
									unit_no = unit_no + 1;
									next_unit = units_to_visit[unit_no];
									
									// as PU detection is over and of MPU then W is the only unit remaining
									// to go to W
									sequence_no = 0;
									nodes_to_follow[1] = node_5;
									nodes_to_follow[2] = change_unit;
									current_node_task = node_follow;
									current_process = color_detection;
									detection_status = to_detect;
								end
								endcase
							end
							
							SSU: // if bot arrives from SSU ----------------------------------------------------------------
							
							// if bot arrives from SSU for color detection it implies that path 1 is anavilable 
							// therefore bot came from SSU after completing detection of PU
							
							begin
								previous_unit = current_unit;
								case(detection_status)
								
								to_detect: // check for faults
								begin
									sequence_no = 0;
									if(!path[10])
									begin
										nodes_to_follow[1] = node_2;
									end
									else
									begin
										nodes_to_follow[1] = node_4;
									end
									nodes_to_follow[2] = node_3;
									nodes_to_follow[3] = change_unit;
									current_node_task = node_follow;
									next_unit = MPU;
									unit_no = unit_no - 1;
									current_process = color_detection;
									detection_status = detecting;
									previous_unit = SSU;
								end
								
								detected: // faults detected go to SSU for remidies
								begin
									sequence_no = 0;
									nodes_to_follow[1] = node_8;
									nodes_to_follow[2] = change_unit;
									current_node_task = node_follow;
									current_process = color_detection;	
									detection_status = to_detect;
								end
								
								not_detected: // no faults detected go to remaining units
								begin
									unit_no = unit_no + 1;
									next_unit = units_to_visit[unit_no];
									detection_status = to_detect;
									
									// as PU detection is over and of MPU then W is the only unit remaining
									// to go to W
							
									if(path[3])
									begin	
										sequence_no = 0;
										nodes_to_follow[1] = node_4;
										nodes_to_follow[2] = node_5;
										nodes_to_follow[3] = change_unit;
										current_node_task = node_follow;
										current_process = color_detection;
									end
									
									else 
									begin
										sequence_no = 0;
										nodes_to_follow[1] = node_8;
										nodes_to_follow[2] = change_unit;
										current_node_task = node_follow;
										next_unit = SSU;
										unit_no = unit_no - 1;
										current_process = go_to_next_unit;
									end
								end
								endcase
							end
							
							START: // if bot arrives from START  -----------------------------------------------------------------
							
							// as bot arrives from start bot will want to go to W as bot favours clockwise surveilence
							
							begin
								previous_unit = current_unit;
								case(detection_status)
								
								to_detect: // check for faults
								begin
									sequence_no = 0;
									if(!path[2])
									begin
										nodes_to_follow[1] = node_4;
									end
									else
									begin
										nodes_to_follow[1] = node_3;
									end
									
									nodes_to_follow[2] = node_2;
									nodes_to_follow[3] = change_unit;
									current_node_task = node_follow;
									next_unit = MPU;
									unit_no = unit_no - 1;
									current_process = color_detection;
									detection_status = detecting;
									previous_unit = START;
								end
								
								detected: // faults detected go to SSU for remidies
								begin
									detection_status = to_detect;
									if(path[16])
									begin
										sequence_no = 0;
										nodes_to_follow[1] = node_3;
										nodes_to_follow[2] = node_8;
										nodes_to_follow[3] = change_unit;
										current_node_task = node_follow;
										current_process = color_detection;
									end
									else if (path[3] & path[5])
									begin
										sequence_no = 0;
										nodes_to_follow[1] = node_4;
										nodes_to_follow[2] = node_5;
										nodes_to_follow[3] = change_unit;
										current_node_task = node_follow;
										next_unit = W;
										unit_no = unit_no - 1;
										current_process = go_to_next_unit;
									end
									else
									begin
										sequence_no = 0;
										nodes_to_follow[1] = node_1;
										nodes_to_follow[2] = node_11;
										nodes_to_follow[3] = change_unit;
										current_node_task = node_follow;
										next_unit = PU;
										unit_no = unit_no - 1;
										current_process = go_to_next_unit;
									end
								end
								
								not_detected: // no faults detected go to remaining units
								begin
									unit_no = unit_no + 1;
									next_unit = units_to_visit[unit_no];
									detection_status = to_detect;
									// as bot arrives from start bot will want to go to W as bot favours clockwise surveilence
									if(path[3])
									begin	
										sequence_no = 0;
										nodes_to_follow[1] = node_4;
										nodes_to_follow[2] = node_5;
										nodes_to_follow[3] = change_unit;
										current_node_task = node_follow;
										current_process = color_detection;
									end
									
									else if(path[16]) 
									begin
										sequence_no = 0;
										nodes_to_follow[1] = node_3;
										nodes_to_follow[2] = node_8;
										nodes_to_follow[3] = change_unit;
										current_node_task = node_follow;
										next_unit = SSU;
										unit_no = unit_no - 1;
										current_process = go_to_next_unit;
									end
									
									else 
									begin 
										sequence_no = 0;
										nodes_to_follow[1] = node_1;
										nodes_to_follow[2] = node_11;
										nodes_to_follow[3] = change_unit;
										current_node_task = node_follow;
										next_unit = PU;
										unit_no = unit_no - 1;
										current_process = go_to_next_unit;
									end
								end
								endcase
							end
							
						endcase
					end
					
					go_to_next_unit: // 
					begin
						case(previous_unit)
							W: // if bot arrives from W -----------------------------------------------------------------------
							
							// if bot arrives from W to go_to_next_unit this shows either path 5 or path 7 is unavailable
							
							begin
								previous_unit = current_unit;
								case(next_unit)
									SSU: // if bot wants to go to SSU this shows path 5 is unavailable
									begin
										if(path[16])
										begin
											sequence_no = 0;
											nodes_to_follow[1] = node_3;
											nodes_to_follow[2] = node_8;
											nodes_to_follow[3] = change_unit;
											current_node_task = node_follow;
											current_process = color_detection;
										end
	
										else
										begin
											sequence_no = 0;
											nodes_to_follow[1] = node_2;
											nodes_to_follow[2] = node_1;
											nodes_to_follow[3] = node_11;
											nodes_to_follow[4] = change_unit;
											current_node_task = node_follow;
											next_unit = PU;
											unit_no = unit_no - 1;
											current_process = go_to_next_unit;
										end
									end
									
									PU: // if bot wants to go to PU 
									begin
										
										if(path[9] & path[1])
										begin	
											sequence_no = 0;
											nodes_to_follow[1] = node_2;
											nodes_to_follow[2] = node_1;
											nodes_to_follow[3] = node_11;
											nodes_to_follow[4] = change_unit;
											current_node_task = node_follow;
											current_process = color_detection;
										end
										
										else 
										begin
											sequence_no = 0;
											nodes_to_follow[1] = node_3;
											nodes_to_follow[2] = node_8;
											nodes_to_follow[3] = change_unit;
											current_node_task = node_follow;
											next_unit = SSU;
											unit_no = unit_no - 1;
											current_process = go_to_next_unit;
										end
										
									end
									
									
								endcase
							end
							
							SSU: // if bot arrives from SSU --------------------------------------------------------------------
							
							// if bot arrives from SSU to go_to_next_unit this shows either path 5 or path 7 is unavailable
							
							begin
								previous_unit = current_unit;
								case(next_unit)
									
									W: // if bot wants to go to W this implies path 5 is unavailable therefore path 3 is available
									begin
										sequence_no = 0;
										nodes_to_follow[1] = node_4;
										nodes_to_follow[2] = node_5;
										nodes_to_follow[3] = change_unit;
										current_node_task = node_follow;
										current_process = color_detection;
									end
										
									PU: // if bot wants to go to PU this implies path 7 is unavailable therefore path 1 and path 9 is available
									begin
										sequence_no = 0;
										nodes_to_follow[1] = node_2;
										nodes_to_follow[2] = node_1;
										nodes_to_follow[3] = node_11;
										nodes_to_follow[4] = change_unit;
										current_node_task = node_follow;
										current_process = color_detection;
									end
								endcase
							end
							PU: // if bot arrives from PU ------------------------------------------------------------------------
							
							// if bot arrives from PU to go_to_next_unit it implies path 5 or path 7 is unavailable
							
							begin
								previous_unit = current_unit;
								case(next_unit)
									W: // if bot wants to go to W
									begin
										if(path[3])
										begin	
											sequence_no = 0;
											nodes_to_follow[1] = node_4;
											nodes_to_follow[2] = node_5;
											nodes_to_follow[3] = change_unit;
											current_node_task = node_follow;
											current_process = color_detection;
										end
										
										else 
										begin
											sequence_no = 0;
											nodes_to_follow[1] = node_3;
											nodes_to_follow[2] = node_8;
											nodes_to_follow[3] = change_unit;
											current_node_task = node_follow;
											next_unit = SSU;
											unit_no = unit_no - 1;
											current_process = go_to_next_unit;
										end
									end
									
									SSU: // if bot wants to go to SSU
									begin
										if(path[16])
										begin
											sequence_no = 0;
											nodes_to_follow[1] = node_3;
											nodes_to_follow[2] = node_8;
											nodes_to_follow[3] = change_unit;
											current_node_task = node_follow;
											current_process = color_detection;
										end
										else 
										begin
											sequence_no = 0;
											nodes_to_follow[1] = node_4;
											nodes_to_follow[2] = node_5;
											nodes_to_follow[3] = change_unit;
											current_node_task = node_follow;
											next_unit = W;
											unit_no = unit_no - 1;
											current_process = go_to_next_unit;
										end
									end
								endcase	
							end
						endcase
					end
				endcase
			end
			
	// -----------------------------------------current unit is W -----------------------------------------------------------------------------
			
			W:  
			begin
			
				unit_no = unit_no + 1;
				next_unit = units_to_visit[unit_no];
				
				case(current_process)
				
					color_detection:
					begin
						case(previous_unit)
							
							MPU: // if bot arrives from MPU ------------------------------------------------------------------
							begin
							previous_unit = current_unit;
							case(detection_status)
								
								to_detect: // check for faults
								begin
									sequence_no = 0;
									nodes_to_follow[1] = node_6;
									nodes_to_follow[2] = node_5;
									nodes_to_follow[3] = change_unit;
									current_node_task = node_follow;
									next_unit = W;
									unit_no = unit_no - 1;
									current_process = color_detection;
									detection_status = detecting;
									previous_unit = MPU;
								end
								
								detected: // faults detected go to SSU for remidies
								begin
									detection_status = to_detect;
									if(path[5])
									begin
										sequence_no = 0;
										nodes_to_follow[1] = node_6;
										nodes_to_follow[2] = node_7;
										nodes_to_follow[3] = change_unit;
										current_node_task = node_follow;
										current_process = color_detection;
									end
									else
									begin
										sequence_no = 0;
										nodes_to_follow[1] = node_4;
										nodes_to_follow[2] = change_unit;
										current_node_task = node_follow;
										next_unit = MPU;
										unit_no = unit_no - 1;
										current_process = go_to_next_unit;
									end
									
								end
				
								not_detected: // no faults detected go to remaining units
								begin
									unit_no = unit_no + 1;
									next_unit = units_to_visit[unit_no];
									detection_status = to_detect;
									case(next_unit) // next_unit only PU and STOP as W is either last or second last unit to be checked
										PU: // if bot wants to go to PU
										begin
											
											if( path[5] & path[7])
											begin
												sequence_no = 0;
												nodes_to_follow[1] = node_6;
												nodes_to_follow[2] = node_7;
												nodes_to_follow[3] = change_unit;
												current_node_task = node_follow;
												next_unit = SSU;
												unit_no = unit_no - 1;
												current_process = go_to_next_unit;
											end
											else
											begin
												sequence_no = 0;
												nodes_to_follow[1] = node_4;
												nodes_to_follow[2] = change_unit;
												current_node_task = node_follow;
												next_unit = MPU;
												unit_no = unit_no - 1;
												current_process = go_to_next_unit;
											end
										end

										STOP:
										begin
											current_unit = STOP;
										end
										
									endcase
								end
							endcase
							end
							
							SSU: // if bot arrives from SSU -----------------------------------------------------------------
							begin
							previous_unit = current_unit;
							case(detection_status)
								
								to_detect: // check for faults
								begin
									sequence_no = 0;
									nodes_to_follow[1] = node_5;
									nodes_to_follow[2] = node_6;
									nodes_to_follow[3] = change_unit;
									current_node_task = node_follow;
									next_unit = W;
									unit_no = unit_no - 1;
									current_process = color_detection;
									detection_status = detecting;
									previous_unit = SSU;
								end
								
								detected: // faults detected go to SSU for remidies
								begin
									sequence_no = 0;
									nodes_to_follow[1] = node_7;
									nodes_to_follow[2] = change_unit;
									current_node_task = node_follow;
									current_process = color_detection;	
									detection_status = to_detect;
								end
				
								not_detected: // no faults detected go to remaining units
								begin
									unit_no = unit_no + 1;
									next_unit = units_to_visit[unit_no];
									detection_status = to_detect;
									case(next_unit)
										PU: // if bot wants to go to PU
										begin
											
											if( path[5] & path[7])
											begin
												sequence_no = 0;
												nodes_to_follow[1] = node_7;
												nodes_to_follow[2] = change_unit;
												current_node_task = node_follow;
												next_unit = SSU;
												unit_no = unit_no - 1;
												current_process = go_to_next_unit;
											end
											else
											begin
												sequence_no = 0;
												nodes_to_follow[1] = node_5;
												nodes_to_follow[2] = node_4;
												nodes_to_follow[3] = change_unit;
												current_node_task = node_follow;
												next_unit = MPU;
												unit_no = unit_no - 1;
												current_process = go_to_next_unit;
											end
											
										end

										STOP:
										begin
											current_unit = STOP;
										end
										
									endcase
								end
							endcase
							end
							
						endcase
					end
					
					go_to_next_unit:
					begin
						case(previous_unit)
							
							// if bot arrives from MPU to go_to_next_unit this implies path 16  is unavailable and from arriving from MPU implies it only wants to go to SSU
							
							MPU: // if bot arrives from MPU --------------------------------------------------------------------
							begin
								
								previous_unit = current_unit;
								 // if bot wants to go to SSU this shows path 16 is unavailble and path 3 and path 5 are available 
								sequence_no = 0;
								nodes_to_follow[1] = node_6;
								nodes_to_follow[2] = node_7;
								nodes_to_follow[3] = change_unit;
								current_node_task = node_follow;
								current_process = color_detection;
																							
							end
							
							SSU: // if bot arrives from SSU
							
							// if bot arrives from SSU to go_to_next_unit this implies either path 16 or path 7 or path 1 or path 9 is unavailable
						
							begin
								 previous_unit = current_unit;
								 case(next_unit)
									
									MPU: // if bot wants to go to MPU this shows path 16 is and path 7 and path 1 or path 9 is unavailable
									begin
										sequence_no = 0;
										nodes_to_follow[1] = node_5;
										nodes_to_follow[2] = node_4;
										nodes_to_follow[3] = change_unit;
										current_node_task = node_follow;
										current_process = color_detection;
									end
									
									PU: // if bot wants to go to PU this shows path 16 and path 7 is unavailable
									begin
										sequence_no = 0;
										nodes_to_follow[1] = 5;
										nodes_to_follow[2] = 4;
										nodes_to_follow[3] = change_unit;
										current_node_task = node_follow;
										next_unit = MPU;
										unit_no = unit_no - 1;
										current_process = go_to_next_unit;
									end
							
								endcase
							end
						endcase
					end
				endcase
			end
			
	// -----------------------------------------current unit is PU -----------------------------------------------------------------------------
			
			PU: 
			begin
			
				unit_no = unit_no + 1;
				next_unit = units_to_visit[unit_no];
				
				case(current_process)
				
					color_detection:
					begin
						case(previous_unit)
							
							MPU: // if bot arrives from MPU ------------------------------------------------------------------
							begin
							// if bot arrives from MPU for color detection this implies path 7 or path 5 is not available
							previous_unit = current_unit;
							case(detection_status)
								
								to_detect: // check for faults
								begin
									sequence_no = 0;
									nodes_to_follow[1] = node_10;
									nodes_to_follow[2] = node_11;
									nodes_to_follow[3] = change_unit;
									current_node_task = node_follow;
									next_unit = PU;
									unit_no = unit_no - 1;
									current_process = color_detection;
									detection_status = detecting;
									previous_unit = MPU;
								end
								
								detected: // faults detected go to SSU for remidies
								begin
									detection_status = to_detect;
									if( path[7])
									begin
										sequence_no = 0;
										nodes_to_follow[1] = node_10;
										nodes_to_follow[2] = node_9;
										nodes_to_follow[3] = change_unit;
										current_node_task = node_follow;
										current_process = color_detection;
									end
									
									else
									begin
										sequence_no = 0;
										nodes_to_follow[1] = node_1;
										nodes_to_follow[2] = node_2;
										nodes_to_follow[3] = change_unit;
										current_node_task = node_follow;
										next_unit = MPU;
										unit_no = unit_no - 1;
										current_process = go_to_next_unit;
									end								
								end
				
								not_detected: // no faults detected go to remaining units
								// as PU is detected last if path 1 and path 9 are availale therefore this implies bot has completed the run
								begin
									current_unit = STOP;
								end
							endcase
							end
							
							SSU: // if bot arrives from SSU -----------------------------------------------------------------
							begin
							// if bot arrives from SSU for color detection it shows it is the last unit to color detect
							// as PU can be first or last unit
							
							previous_unit = current_unit;
							case(detection_status)
								
								to_detect: // check for faults
								begin
									sequence_no = 0;
									nodes_to_follow[1] = node_11;
									nodes_to_follow[2] = node_10;
									nodes_to_follow[3] = change_unit;
									current_node_task = node_follow;
									next_unit = PU;
									unit_no = unit_no - 1;
									current_process = color_detection;
									detection_status = detecting;
									previous_unit = SSU;
								end
								
								detected: // faults detected go to SSU for remidies
								begin
									detection_status = to_detect;
									sequence_no = 0;
									nodes_to_follow[1] = node_9;
									nodes_to_follow[2] = change_unit;
									current_node_task = node_follow;
									current_process = color_detection;	
								end
				
								not_detected: // no faults detected go to remaining units
								begin
								// as PU is detected last if path 1 and path 9 are availale therefore this implies bot has completed the run
									current_unit = STOP;
								end
							endcase
							end
							
							START: // if bot arrives from start -----------------------------------------------------------
							begin
							// if bot arrives from start this implies path 1 is unavailable as MPU is the first preference
							previous_unit = current_unit;
								case(detection_status)
								
									to_detect: // check for faults
									begin
										sequence_no = 0;
										nodes_to_follow[1] = node_10;
										nodes_to_follow[2] = node_11;
										nodes_to_follow[3] = change_unit;
										current_node_task = node_follow;
										next_unit = PU;
										unit_no = unit_no - 1;
										current_process = color_detection;
										detection_status = detecting;
										previous_unit = START;
									end
								
									detected: // faults detected go to SSU for remidies
									begin
										detection_status = to_detect;
										sequence_no = 0;
										nodes_to_follow[1] = node_10;
										nodes_to_follow[1] = node_9;
										nodes_to_follow[2] = change_unit;
										current_node_task = node_follow;
										current_process = color_detection;	
									end
				
									not_detected: // no faults detected go to remaining units
									// as bot has arrived from start this shows PU is the first unit and therefore second unit is MPU
									begin
										unit_no = unit_no + 1;
										next_unit = units_to_visit[unit_no];
										detection_status = to_detect;
										sequence_no = 0;
										nodes_to_follow[1] = node_10;
										nodes_to_follow[1] = node_9;
										nodes_to_follow[2] = change_unit;
										current_node_task = node_follow;
										next_unit = SSU;
										unit_no = unit_no - 1;
										current_process = go_to_next_unit;
									end
								endcase
							end
							
						endcase
					end
					
					go_to_next_unit:
					begin
						case(previous_unit)
							
							MPU: // if bot arrives from MPU --------------------------------------------------------------------
							
							// if bot arrives from MPU to go_to_next_unit this implies either path 16  and path 3 or path 5 is unavailable
							
							begin
								
								previous_unit = current_unit;
								case(next_unit)
								
									SSU: // if bot wants to go to SSU  
									begin
										sequence_no = 0;
										nodes_to_follow[1] = node_10;
										nodes_to_follow[2] = node_9;
										nodes_to_follow[3] = change_unit;
										current_node_task = node_follow;
										current_process = color_detection;
									end
									
									W: // if bot wants to go to W
									begin
										sequence_no = 0;
										nodes_to_follow[1] = node_10;
										nodes_to_follow[2] = node_9;
										nodes_to_follow[3] = change_unit;
										current_node_task = node_follow;
										next_unit = SSU;
										unit_no = unit_no - 1;
										current_process = go_to_next_unit;
									end
							
								endcase									
							end
							
							SSU: // if bot arrives from SSU
							
							// if bot arrives from SSU to go_to_next_unit this implies either path 16 or path 7 or path 1 or path 9 is unavailable
							
							begin
								 previous_unit = current_unit;
								 case(next_unit)
									
									MPU: // if bot wants to go to MPU this shows path 16 is and path 7 and path 1 or path 9 is unavailable
									begin
										sequence_no = 0;
										nodes_to_follow[1] = node_11;
										nodes_to_follow[2] = node_1;
										nodes_to_follow[3] = node_2;
										nodes_to_follow[4] = change_unit;
										current_node_task = node_follow;
										current_process = color_detection;
									end
									
									PU: // if bot wants to go to PU this shows path 16 and path 7 is unavailable
									begin
										sequence_no = 0;
										nodes_to_follow[1] = node_11;
										nodes_to_follow[2] = node_1;
										nodes_to_follow[2] = node_2;
										nodes_to_follow[3] = change_unit;
										current_node_task = node_follow;
										next_unit = MPU;
										unit_no = unit_no - 1;
										current_process = go_to_next_unit;
									end
							
								endcase
							end
						endcase
					end
				endcase
			end
			
	// -----------------------------------------current unit is SSU -----------------------------------------------------------------------------
			
			SSU: 
			begin
				
				unit_no = unit_no + 1;
				next_unit = units_to_visit[unit_no];
				
				case(current_process)
					
					color_detection:
					begin
						
						case(previous_unit)
							
							PU: // if bot arrives from PU --------------------------------------------------------------------
							begin
								previous_unit = current_unit;
								case(detection_status)
								
								to_detect: // check for remedies
								begin
									sequence_no = 0;
									if(!path[14])
									begin
										nodes_to_follow[1] = node_8;
									end
									else
									begin
										nodes_to_follow[1] = node_7;
									end
									
									nodes_to_follow[2] = node_9;
									nodes_to_follow[3] = change_unit;
									current_node_task = node_follow;
									next_unit = SSU;
									unit_no = unit_no - 1;
									current_process = color_detection;
									detection_status = detecting;
									previous_unit = PU;
								end
								
								detected: // faults solved go to remainig units
								begin
									
									detection_status = to_detect;
									case(next_unit)
										PU: // if bot wants to go to PU
										begin
											if(path[7])
											begin	
												sequence_no = 0;
												nodes_to_follow[1] = node_10;
												nodes_to_follow[2] = change_unit;
												current_node_task = node_follow;
												current_process = color_detection;
											end
											
											else if(path[16]) 
											begin
												sequence_no = 0;
												nodes_to_follow[1] = node_8;
												nodes_to_follow[2] = node_3;
												nodes_to_follow[3] = change_unit;
												current_node_task = node_follow;
												next_unit = SSU;
												unit_no = unit_no - 1;
												current_process = go_to_next_unit;
											end
											
											else 
											begin 
												sequence_no = 0;
												nodes_to_follow[1] = node_7;
												nodes_to_follow[2] = node_6;
												nodes_to_follow[3] = change_unit;
												current_node_task = node_follow;
												next_unit = W;
												unit_no = unit_no - 1;
												current_process = go_to_next_unit;
											end
										end
										
										W: // if bot wants to go to W
										begin
											
											if(path[5] )
											begin	
												sequence_no = 0;
												nodes_to_follow[1] = node_7;
												nodes_to_follow[2] = node_6;
												nodes_to_follow[3] = change_unit;
												current_node_task = node_follow;
												current_process = color_detection;
											end
											
											else if(path[16]) 
											begin
												sequence_no = 0;
												nodes_to_follow[1] = node_8;
												nodes_to_follow[2] = node_3;
												nodes_to_follow[3] = change_unit;
												current_node_task = node_follow;
												next_unit = SSU;
												unit_no = unit_no - 1;
												current_process = go_to_next_unit;
											end
											
											else 
											begin 
												sequence_no = 0;
												nodes_to_follow[1] = node_10;
												nodes_to_follow[2] = change_unit;
												current_node_task = node_follow;
												next_unit = PU;
												unit_no = unit_no - 1;
												current_process = go_to_next_unit;
											end
										end
										
										MPU: // if bot wants to go to MPU
										begin
											if(path[16])
											begin
												sequence_no = 0;
												nodes_to_follow[1] = node_8;
												nodes_to_follow[2] = node_3;
												nodes_to_follow[3] = change_unit;
												current_node_task = node_follow;
												current_process = color_detection;
											end
											else if (path[5])
											begin
												sequence_no = 0;
												nodes_to_follow[1] = node_10;
												nodes_to_follow[2] = change_unit;
												current_node_task = node_follow;
												next_unit = PU;
												unit_no = unit_no - 1;
												current_process = go_to_next_unit;
											end
											else
											begin
												sequence_no = 0;
												nodes_to_follow[1] = node_7;
												nodes_to_follow[2] = node_6;
												nodes_to_follow[3] = change_unit;
												current_node_task = node_follow;
												next_unit = W;
												unit_no = unit_no - 1;
												current_process = go_to_next_unit;
											end
										end
										
										STOP:
										begin
											current_unit = STOP;
										end
										
									endcase
								end
								endcase
							end
							
							MPU: // if bot arrives from MPU ----------------------------------------------------------------
							begin
								previous_unit = current_unit;
								case(detection_status)
								
								to_detect: // check for remedies

								begin
									sequence_no = 0;
									if(!path[13])
									begin
										nodes_to_follow[1] = node_7;
									end
									else
									begin
										nodes_to_follow[1] = node_9;
									end
									
									nodes_to_follow[2] = node_8;
									nodes_to_follow[3] = change_unit;
									current_node_task = node_follow;
									next_unit = SSU;
									unit_no = unit_no - 1;
									current_process = color_detection;
									detection_status = detecting;
									previous_unit = MPU;
								end
								
								detected: // faults solved go to remainig units
								begin
					
									detection_status = to_detect;
									case(next_unit)
										PU: // if bot wants to go to PU
										begin
											if(path[7])
											begin	
												sequence_no = 0;
												nodes_to_follow[1] = node_9;
												nodes_to_follow[2] = node_10;
												nodes_to_follow[3] = change_unit;
												current_node_task = node_follow;
												current_process = color_detection;
											end
											
											else if(path[16]) 
											begin
												sequence_no = 0;
												nodes_to_follow[1] = node_9;
												nodes_to_follow[2] = change_unit;
												current_node_task = node_follow;
												next_unit = MPU;
												unit_no = unit_no - 1;
												current_process = go_to_next_unit;
											end
											
											else 
											begin 
												sequence_no = 0;
												nodes_to_follow[1] = node_7;
												nodes_to_follow[2] = node_6;
												nodes_to_follow[3] = change_unit;
												current_node_task = node_follow;
												next_unit = W;
												unit_no = unit_no - 1;
												current_process = go_to_next_unit;
											end
										end
										
										W: // if bot wants to go to W
										begin
											
											if(path[5])
											begin	
												sequence_no = 0;
												nodes_to_follow[1] = node_7;
												nodes_to_follow[2] = node_6;
												nodes_to_follow[3] = change_unit;
												current_node_task = node_follow;
												current_process = color_detection;
											end
											
											else if(path[16]) 
											begin
												sequence_no = 0;
												nodes_to_follow[1] = node_3;
												nodes_to_follow[2] = change_unit;
												current_node_task = node_follow;
												next_unit = MPU;
												unit_no = unit_no - 1;
												current_process = go_to_next_unit;
											end
											
											else 
											begin 
												sequence_no = 0;
												nodes_to_follow[1] = node_9;
												nodes_to_follow[2] = node_10;
												nodes_to_follow[3] = change_unit;
												current_node_task = node_follow;
												next_unit = PU;
												unit_no = unit_no - 1;
												current_process = go_to_next_unit;
											end
										end
										
										MPU:
										begin
											if(path[16])
											begin
												sequence_no = 0;
												nodes_to_follow[1] = node_3;
												nodes_to_follow[2] = change_unit;
												current_node_task = node_follow;
												current_process = color_detection;
											end
											else if (path[3])
											begin
												sequence_no = 0;
												nodes_to_follow[1] = node_9;
												nodes_to_follow[2] = node_10;
												nodes_to_follow[3] = change_unit;
												current_node_task = node_follow;
												next_unit = PU;
												unit_no = unit_no - 1;
												current_process = go_to_next_unit;
											end
											else
											begin
												sequence_no = 0;
												nodes_to_follow[1] = node_7;
												nodes_to_follow[2] = node_6;
												nodes_to_follow[3] = change_unit;
												current_node_task = node_follow;
												next_unit = W;
												unit_no = unit_no - 1;
												current_process = go_to_next_unit;
											end
										end
										
										STOP:
										begin
											current_unit = STOP;
										end
										
									endcase
								end
								endcase
							end
							
							W: // if bot arrives from W  -----------------------------------------------------------------
							begin
								previous_unit = current_unit;
								case(detection_status)
								
								to_detect: // check for remedies

								begin
									sequence_no = 0;
									if(!path[6])
									begin
										nodes_to_follow[1] = node_9;
									end
									else
									begin
										nodes_to_follow[1] = node_8;
									end

									nodes_to_follow[2] = node_7;
									nodes_to_follow[3] = change_unit;
									current_node_task = node_follow;
									next_unit = SSU;
									unit_no = unit_no - 1;
									current_process = color_detection;
									detection_status = detecting;
									previous_unit = W;
								end
								
								detected: // faults solved go to remainig units
								begin
									
									detection_status = to_detect;
									case(next_unit)
										PU: // if bot wants to go to PU
										begin
											if(path[7])
											begin	
												sequence_no = 0;
												nodes_to_follow[1] = node_9;
												nodes_to_follow[2] = node_10;
												nodes_to_follow[3] = change_unit;
												current_node_task = node_follow;
												current_process = color_detection;
											end
											
											else if(path[16]) 
											begin
												sequence_no = 0;
												nodes_to_follow[1] = node_8;
												nodes_to_follow[2] = node_3;
												nodes_to_follow[3] = change_unit;
												current_node_task = node_follow;
												next_unit = MPU;
												unit_no = unit_no - 1;
												current_process = go_to_next_unit;
											end
											
											else 
											begin 
												sequence_no = 0;
												nodes_to_follow[1] = node_6;
												nodes_to_follow[2] = change_unit;
												current_node_task = node_follow;
												next_unit = W;
												unit_no = unit_no - 1;
												current_process = go_to_next_unit;
											end
										end
										
										W: // if bot wants to go to W
										begin
											
											if(path[5])
											begin	
												sequence_no = 0;
												nodes_to_follow[1] = node_6;
												nodes_to_follow[2] = change_unit;
												current_node_task = node_follow;
												current_process = color_detection;
											end
											
											else if(path[16]) 
											begin
												sequence_no = 0;
												nodes_to_follow[1] = node_8;
												nodes_to_follow[2] = node_3;
												nodes_to_follow[3] = change_unit;
												current_node_task = node_follow;
												next_unit = MPU;
												unit_no = unit_no - 1;
												current_process = go_to_next_unit;
											end
											
											else 
											begin 
												sequence_no = 0;
												nodes_to_follow[1] = node_9;
												nodes_to_follow[2] = node_10;
												nodes_to_follow[3] = change_unit;
												current_node_task = node_follow;
												next_unit = PU;
												unit_no = unit_no - 1;
												current_process = go_to_next_unit;
											end
										end
										
										MPU:
										begin
											if(path[16])
											begin
												sequence_no = 0;
												nodes_to_follow[1] = node_8;
												nodes_to_follow[2] = node_3;
												nodes_to_follow[3] = change_unit;
												current_node_task = node_follow;
												current_process = color_detection;
											end
											else if (path[3])
											begin
												sequence_no = 0;
												nodes_to_follow[1] = node_9;
												nodes_to_follow[2] = node_10;
												nodes_to_follow[3] = change_unit;
												current_node_task = node_follow;
												next_unit = PU;
												unit_no = unit_no - 1;
												current_process = go_to_next_unit;
											end
											else
											begin
												sequence_no = 0;
												nodes_to_follow[1] = node_6;
												nodes_to_follow[2] = change_unit;
												current_node_task = node_follow;
												next_unit = W;
												unit_no = unit_no - 1;
												current_process = go_to_next_unit;
											end
										end
										
										STOP:
										begin
											current_unit = STOP;
										end
		
									endcase
								end
								endcase
							end
							
						endcase
					end
					
					go_to_next_unit: 
					
					begin
						case(previous_unit)
							
							PU: // if bot arrives from PU -----------------------------------------------------------------------
							
							// if bot arrives PU to go_to_next_unit this implies that path 1 or path 9 or path 3 is anavailable 
							
							begin
								previous_unit = current_unit;
								case(next_unit)
									MPU: // if bot wants to go to MPU this shows path 1 or path 9 is unavailable
									begin
										if(path[16])
										begin
											sequence_no = 0;
											nodes_to_follow[1] = node_8;
											nodes_to_follow[2] = node_3;
											nodes_to_follow[3] = change_unit;
											current_node_task = node_follow;
											current_process = color_detection;
										end
		
										else
										begin
											sequence_no = 0;
											nodes_to_follow[1] = node_7;
											nodes_to_follow[2] = node_6;
											nodes_to_follow[3] = change_unit;
											current_node_task = node_follow;
											next_unit = W;
											unit_no = unit_no - 1;
											current_process = go_to_next_unit;
										end
									end
									
									W: // if bot wants to go to W this shows path 1 or path 9 or path 3 is unavailable
									begin
										
										if(path[5])
										begin	
											sequence_no = 0;
											nodes_to_follow[1] = node_7;
											nodes_to_follow[2] = node_6;
											nodes_to_follow[3] = change_unit;
											current_node_task = node_follow;
											current_process = color_detection;
										end
										
										else  
										begin
											sequence_no = 0;
											nodes_to_follow[1] = node_8;
											nodes_to_follow[2] = node_3;
											nodes_to_follow[3] = change_unit;
											current_node_task = node_follow;
											next_unit = MPU;
											unit_no = unit_no - 1;
											current_process = go_to_next_unit;
										end
									end
								endcase
							end
							
							MPU: // if bot arrives from MPU --------------------------------------------------------------------
							
							//if bot arrives from MPU to go_to_next_unit this implies path 1 or path 9 or path 3 is unavailable 
							
							begin
								previous_unit = current_unit;
								case(next_unit)
									
									PU: // if bot wants to go to PU this shows path 1 or path 9 is unavailable
									begin
											
										sequence_no = 0;
										nodes_to_follow[1] = node_9;
										nodes_to_follow[2] = node_10;
										nodes_to_follow[3] = change_unit;
										current_node_task = node_follow;
										current_process = color_detection;
									end
										
									W: // if bot wants to go to W this shows path 3 is unuavailable
									begin
										sequence_no = 0;
										nodes_to_follow[1] = node_7;
										nodes_to_follow[2] = node_6;
										nodes_to_follow[3] = change_unit;
										current_node_task = node_follow;
										current_process = color_detection;
									end
								endcase
							end
							W: // if bot arrives from W ------------------------------------------------------------------------
							
							// if bot arrives from W to go_to_next_unit this implies path 3 is unavailable or it wants to go to PU 
							
							begin
								previous_unit = current_unit;
								case(next_unit)
									PU: // if bot wants to go to PU
									begin
										if(path[7])
										begin	
											sequence_no = 0;
											nodes_to_follow[1] = node_9;
											nodes_to_follow[2] = node_10;
											nodes_to_follow[3] = change_unit;
											current_node_task = node_follow;
											current_process = color_detection;
										end
										
										else if(path[16]) 
										begin
											sequence_no = 0;
											nodes_to_follow[1] = node_8;
											nodes_to_follow[2] = node_3;
											nodes_to_follow[3] = change_unit;
											current_node_task = node_follow;
											next_unit = MPU;
											unit_no = unit_no - 1;
											current_process = go_to_next_unit;
										end
										
										else 
										begin 
											sequence_no = 0;
											nodes_to_follow[1] = node_6;
											nodes_to_follow[2] = change_unit;
											current_node_task = node_follow;
											next_unit = W;
											unit_no = unit_no - 1;
											current_process = go_to_next_unit;
										end
									end
									
									MPU: //if bot wants to go to MPU this shows path 3 is unavailable 
									begin
										if(path[16])
										begin
											sequence_no = 0;
											nodes_to_follow[1] = node_8;
											nodes_to_follow[2] = node_3;
											nodes_to_follow[3] = change_unit;
											current_node_task = node_follow;
											current_process = color_detection;
										end
										else 
										begin
											sequence_no = 0;
											nodes_to_follow[1] = node_9;
											nodes_to_follow[2] = node_10;
											nodes_to_follow[3] = change_unit;
											current_node_task = node_follow;
											next_unit = PU;
											unit_no = unit_no - 1;
											current_process = go_to_next_unit;
										end
										
									end
								endcase	
							end
						endcase
					end
				endcase
			end
			
	//--------------------------------------------------STOP-------------------------------------------------------------
	
			STOP:
			begin
				r_speed_a1_a = 0;
				r_speed_b1_a = 0;
				r_speed_a1_b = 0;
				r_speed_b1_b = 0;
			end
		endcase
	end

	//-------------------------------------------------------------------------------------------------------------------------------			
	
	node_follow:
	begin
		

		case(current_node) 
		
			wait_for_node:  // this case is when trvelling on path or arch between two nodes -----------------------------------
			begin
				case(action_to_take)
					
					follow_line:
					begin
						line_follow();
						if( adc_data == 3'b111) current_node =  next_node;
					end
					
					turn_R:
					begin
						turn_right();
						if (adc_data != 3'b111 &  adc_data != 3'b000) action_to_take = follow_line;
					end
					
					turn_R_arc:
					begin
						turn_right_arc();
						if (adc_data != 3'b111 &  adc_data != 3'b000) action_to_take = follow_line;
					end
					
					turn_L:
					begin
						turn_left();
						if (adc_data != 3'b111 &  adc_data != 3'b000) action_to_take = follow_line;
					end

					turn_L_arc:
					begin
						turn_left_arc();
						if (adc_data != 3'b111 &  adc_data != 3'b000) action_to_take = follow_line;
					end

							
					turn_A:
					begin
						turn_around();
						if ( adc_data == 3'b010) action_to_take = follow_line;
					end
					
					go_st:
					begin
						go_straight();
						if (adc_data != 3'b111 &  adc_data != 3'b000) action_to_take = follow_line;
					end
				endcase
			end
			
			// current position of bot is node '1' joining paths 1, 9 and 0 (start) --------------------------------------------------------------------------------
			node_1:
			begin
				sequence_no = sequence_no + 1;
				next_node = nodes_to_follow[sequence_no];
			
				case(previous_node) 
			
					node_0: // if the bot has arrived from start position
					begin
						previous_node = current_node;
						case(next_node)
				
							node_2:
							begin
								action_to_take = turn_L;
								current_node = wait_for_node;
							end
					
							node_11:
							begin
								action_to_take = turn_R;
								current_node = wait_for_node;
							end
							
							
						endcase
					end
			
					node_2: // if bot has arrived from node no. 2 
					begin
						previous_node = current_node;
						action_to_take = go_st;
						current_node = wait_for_node;
					end
				
					node_11: // if the bot has arrived from node no. 2
					begin
						previous_node = current_node;
						action_to_take = go_st;
						current_node = wait_for_node;
					end
				
				endcase
			end
		
//------------------------- Main Processing Unit (MPU) -------------------------------------------------------------------- 
		
			node_2: //current position of bot is node '2' joining paths 1, 2 and 10 -------------------------------------------------------------------------
			begin
				sequence_no = sequence_no + 1;
				next_node = nodes_to_follow[sequence_no];
			
				case(previous_node)
				
					node_1: // if bot arrived from node 1
					begin
						previous_node = current_node;
						case(next_node)
					
							node_3: // wants to got to node 3
							begin
								if(path[2])
								begin
									action_to_take = turn_L;
									sequence_no = sequence_no - 1;
									next_node = node_4;
									current_node = wait_for_node;
								end
								else
								begin
									action_to_take = turn_R;
									current_node = wait_for_node;
								end
							end
						
						
							node_4:// wants to go to node 4
							begin
								if(path[2])
								begin
									action_to_take = turn_L;
									current_node = wait_for_node;
								end
								else
								begin
									action_to_take = turn_R;
									sequence_no = sequence_no - 1;
									next_node = node_3;
									current_node = wait_for_node;
								end
							end
						
							change_unit: //   
							begin
								previous_node = node_1;
								current_node_task = nodes_to_decide;
								current_unit = next_unit;
							end
						
						endcase
					end
				
					node_3: // if bot arrived from node 3
					begin
						previous_node = current_node;
						case(next_node)
						
							node_3: // wants to got to node 3 and bot arrived from node 3 this shows it  came after detectin
										// therefore no need to follow arc clockwise
							begin
								action_to_take = turn_A;
								current_node = wait_for_node;
							end
						
							node_4: // wants to go to node 4
							begin
								if(path[2])
								begin
									action_to_take = turn_R_arc;
									current_node = wait_for_node;
								end
								
								else
								begin
									action_to_take = turn_A;
									sequence_no = sequence_no - 1;
									next_node = node_3;
									current_node = wait_for_node;
								end		
							end
							
							node_1: // wants to go to node 1
							begin
								action_to_take = turn_L;
								current_node = wait_for_node;
							end
							
							change_unit: 
							begin
								previous_node = node_3;
								current_node_task = nodes_to_decide;
								current_unit = next_unit;
							end
						endcase
					end
				
					node_4: // if bot arrived from 4
					begin
						previous_node = current_node;
						case(next_node)
						
							node_4:// wants to got to node 4 and bot arrived from node 4 this shows it  came after detectin
										// therefore no need to follow arc clockwise
							begin
								action_to_take = turn_A;
								current_node = wait_for_node;
							end
						
							node_3: // wants to go to node 3
							begin
								if(path[10])
								begin
									action_to_take = turn_L_arc;
									current_node = wait_for_node;
								end
								else
								begin
									action_to_take = turn_A;
									sequence_no = sequence_no - 1;
									next_node = node_4;
									current_node = wait_for_node;
								end
							end
							
							node_1: // wants to go to node 1
							begin
								action_to_take = turn_R;
								current_node = wait_for_node;
							end
							
							change_unit: 
							begin
								previous_node = node_4;
								current_node_task = nodes_to_decide;
								current_unit = next_unit;
							end
							
						endcase
					end
	
				endcase
			
			end
		
			node_3: // current position of bot is node '3' joining paths 10, 11 and 16 i.e bridge --------------------------------------------------------
			begin
			
				// case : if bot arrived from node 2 and wants to go to 2 is not considered here because 
				// from MPU after detection it will never go to PU
			
				sequence_no = sequence_no + 1;
				next_node = nodes_to_follow[sequence_no];
				
				case(previous_node)
				
					node_2: // if bot arrived from node 2 
					begin
						previous_node = current_node;
						case(next_node)
							
							node_8: // wants to go to node 8
							begin
								action_to_take = turn_R;
								current_node = wait_for_node;
							end
							
							node_4: // wants to go to node 4
							begin
								if(path[11])
								begin
									action_to_take = turn_L_arc;
									current_node = wait_for_node;
								end
								else
								begin
									action_to_take = turn_A;
									sequence_no = sequence_no - 1;
									next_node = node_2;
									current_node = wait_for_node;
								end
							end
							
							change_unit: 
							begin
								previous_node = node_2;
								current_node_task = nodes_to_decide;
								current_unit = next_unit;
							end
							
						endcase
					end
					
					node_4: // if bot arrived from node 4
					begin
						previous_node = current_node;
						case(next_node)
						
							node_4:// wants to got to node 4 and bot arrived from node 4 this shows it  came after detectin
										// therefore no need to follow arc clockwise
							begin
								action_to_take = turn_A;
								current_node = wait_for_node;
							end
							
							node_8: // wants to go to node 8
							begin
								action_to_take = turn_L;
								current_node = wait_for_node;
							end
							
							node_2: // wants to go to node 2
							begin
								if(path[10])
								begin
									action_to_take = turn_R_arc;
									current_node = wait_for_node;
								end
								
								else
								begin
									action_to_take = turn_A;
									sequence_no = sequence_no - 1;
									next_node = node_4;
									current_node = wait_for_node;
								end	
							end
							
							change_unit: 
							begin
								previous_node = node_4;
								current_node_task = nodes_to_decide;
								current_unit = next_unit;
							end
							
						endcase
					end
					
					node_8: // if bot arrived from node 8
					begin
						previous_node = current_node;
						case(next_node)
					
							node_2: // wants to got to node 2
							begin
								if(path[10])
								begin
									action_to_take = turn_L;
									current_node = wait_for_node;
								end
								else
								begin
									action_to_take = turn_R;
									sequence_no = sequence_no - 1;
									next_node = node_4;
									current_node = wait_for_node;
								end
							end
						
							node_4:// wants to go to node 4
							begin
								if(path[10])
								begin
									action_to_take = turn_L;
									sequence_no = sequence_no - 1;
									next_node = node_2;
									current_node = wait_for_node;
								end
								else
								begin
									action_to_take = turn_R;
									current_node = wait_for_node;
								end
							end
							
							change_unit: 
							begin
								previous_node = node_8;
								current_node_task = nodes_to_decide;
								current_unit = next_unit;
							end
						
						endcase
					end
				endcase
			end
			
			node_4: // current position of bot is node '4' joing paths 2, 11 and 3 --------------------------------------------------------------------
			begin
				// case : if bot arrived from node 2 and wants to go to 2 is not considered here because 
				// from MPU after detection it will never go to PU
				// also if bot arrived from node 3 and wants to go to 3 is not considered here because 
				// from MPU after detection it will never go to W if it arrives from W to MPU
				
				sequence_no = sequence_no + 1;
				next_node = nodes_to_follow[sequence_no];
				
				case(previous_node)
				
					node_2: // if bot arrived from node 2
					begin
						previous_node = current_node;
						case(next_node)
							
							node_5: // wants to go to node 8
							begin
								action_to_take = turn_L;
								current_node = wait_for_node;
							end
							
							node_3: // wants to go to node 3
							begin
								if(path[11])
								begin
									action_to_take = turn_R_arc;
									current_node = wait_for_node;
								end
								else
								begin
									action_to_take = turn_A;
									next_node = node_2;
									sequence_no = sequence_no - 1;
									current_node = wait_for_node;
								end
							end
							
							change_unit: 
							begin
								previous_node = node_2;
								current_node_task = nodes_to_decide;
								current_unit = next_unit;
							end
							
						endcase
					end
					
					node_3: // if bot arrived from node 3
					begin
						previous_node = current_node;
						case(next_node)
							
							node_5: // wants to go to node 5
							begin
								action_to_take = turn_R;
								current_node = wait_for_node;
							end
							
							node_2: // wants to go to node 2
							begin
								if(path[2])
								begin
									action_to_take = turn_L_arc;
									current_node = wait_for_node;
								end
								else
								begin
									action_to_take = turn_A;
									next_node = node_3;
									sequence_no = sequence_no - 1;
									current_node = wait_for_node;
								end
							end
							
							change_unit: 
							begin
								previous_node = node_3;
								current_node_task = nodes_to_decide;
								current_unit = next_unit;
							end
							
						endcase
					end
					
					node_5: // if bot arrived from node 5
					begin
						previous_node = current_node;
						case(next_node)
					
							node_2: // wants to got to node 2
							begin
								if(path[11])
								begin
									action_to_take = turn_L;
									sequence_no = sequence_no - 1;
									next_node = node_3;
									current_node = wait_for_node;
								end
								else
								begin
									action_to_take = turn_R;
									current_node = wait_for_node;
								end
							end
						
							node_3:// wants to go to node 3
							begin
								if(path[11])
								begin
									action_to_take = turn_L;
									current_node = wait_for_node;
								end
								else
								begin
									action_to_take = turn_R;
									sequence_no = sequence_no - 1;
									next_node = node_2;
									current_node = wait_for_node;
								end
							end
							
							change_unit: 
							begin
								previous_node = node_5;
								current_node_task = nodes_to_decide;
								current_unit = next_unit;
							end
						
						endcase
					end
				endcase
			end

//------------------------ Warehouse (W) ----------------------------------------------------------------------------------
			
			node_5: // current position of bot is node '5' joing paths 3, 4 and 12 --------------------------------------------------------------------
			begin
				sequence_no = sequence_no + 1;
				next_node = nodes_to_follow[sequence_no];
				
				case(previous_node)
					
					node_4: // if bot arrived from node 4
					begin
						// as bot arrived from node 4 is shows that it is to travel to node 6
						previous_node = current_node; 
						
						case(next_node)
							
							node_6:
							begin
								if (path[4])
								begin 
									action_to_take = turn_L;
									current_node = wait_for_node;
								end
						
								else
								begin
									action_to_take = turn_R;
									current_node = wait_for_node;
								end
							end
							
							change_unit: 
							begin
								previous_node = node_4;
								current_node_task = nodes_to_decide;
								current_unit = next_unit;
							end
						
						endcase		
					end
					
					node_6: // if bot arrived from node 6
					begin
						previous_node = current_node;
						case(next_node)
						
							node_6: //want to go to node 6
							begin
								if(!path[4] | !path[12])
								begin
									action_to_take = turn_A;
									current_node = wait_for_node;
								end
								
								else 
								begin
									action_to_take = turn_R_arc;
									current_node = wait_for_node;
								end
							end
							
							node_4: // want to go to node 4
							begin
								if(!path[12])
								begin
									action_to_take = turn_R;
									current_node = wait_for_node;
								end
								else
								begin
									action_to_take = turn_L;
									current_node = wait_for_node;
								end
							end
							
							change_unit: 
							begin
								previous_node = node_6;
								current_node_task = nodes_to_decide;
								current_unit = next_unit;
							end
							
						endcase
					end
				endcase
			end
			
			node_6: // current position of bot is node '6' joing paths 4, 5 and 12 --------------------------------------------------------------------
			begin
				sequence_no = sequence_no + 1;
				next_node = nodes_to_follow[sequence_no];
				
				case(previous_node)
					
					node_5: // if bot arrived from node 5
					begin
						previous_node = current_node;
						case(next_node)
						
							node_5: // want to go to node 5 
							begin
								if(!path[4] | !path[12])
								begin
									action_to_take = turn_A;
									current_node = wait_for_node;
								end
								
								else 
								begin
									action_to_take = turn_R_arc;
									current_node = wait_for_node;
								end
							end
							
							node_7: // want to go to node 7
							begin
								if(!path[4])
								begin
									action_to_take = turn_R;
									current_node = wait_for_node;
								end
								else
								begin
									action_to_take = turn_L;
									current_node = wait_for_node;
								end
							end
							
							change_unit: 
							begin
								previous_node = node_5;
								current_node_task = nodes_to_decide;
								current_unit = next_unit;
							end
							
						endcase
					end
					
					node_7: // if bot arrived from node 7
					begin
						// as bot arrived from node 7 is shows that it is to travel to node 5
						previous_node = current_node; 
						
						case(next_node)
						
							node_5:
							begin
								if (path[12])
								begin 
								action_to_take = turn_L;
								current_node = wait_for_node;
								end
						
								else
								begin
									action_to_take = turn_R;
									current_node = wait_for_node;
								end
							end
							
							change_unit: 
							begin
								previous_node = node_7;
								current_node_task = nodes_to_decide;
								current_unit = next_unit;
							end
							
						endcase
					end
				endcase
			end
			
//--------------------------------- Safety Service Unit (SSU) -------------------------------------------------------------------		
			
		
			
			node_7: //current position of bot is node '7' joining paths 5, 6 and 13 -------------------------------------------------------------------------
			begin
				sequence_no = sequence_no + 1;
				next_node = nodes_to_follow[sequence_no];
			
				case(previous_node)
				
					node_6: // if bot arrived from node 6
					begin
						previous_node = current_node;
						case(next_node)
					
							node_8: // wants to got to node 8
							begin
								if(path[6])
								begin
									action_to_take = turn_L;
									sequence_no = sequence_no - 1;
									next_node = node_9;
									current_node = wait_for_node;
								end
								else
								begin
									action_to_take = turn_R;
									current_node = wait_for_node;
								end
							end
						
						
							node_9:// wants to go to node 9
							begin
								if(path[6])
								begin
									action_to_take = turn_L;
									current_node = wait_for_node;
								end
								else
								begin
									action_to_take = turn_R;
									sequence_no = sequence_no - 1;
									next_node = node_8;
									current_node = wait_for_node;
								end
							end
							
							change_unit: 
							begin
								previous_node = node_6;
								current_node_task = nodes_to_decide;
								current_unit = next_unit;
							end
						
						endcase
					end
				
					node_8: // if bot arrived from node 8
					begin
						previous_node = current_node;
						case(next_node)
						
							node_8: // wants to go to node_8
							begin
								action_to_take = turn_A;
								current_node = wait_for_node;
							end
							node_9: // wants to go to node 9
							begin
								if(path[6])
								begin
									action_to_take = turn_R_arc;
									current_node = wait_for_node;
								end
								
								else
								begin
									action_to_take = turn_A;
									sequence_no = sequence_no - 1;
									next_node = node_8;
									current_node = wait_for_node;
								end		
							end
							
							node_6: // wants to go to node 6
							begin
								action_to_take = turn_L;
								current_node = wait_for_node;
							end
							
							change_unit: 
							begin
								previous_node = node_8;
								current_node_task = nodes_to_decide;
								current_unit = next_unit;
							end
							
						endcase
					end
				
					node_9: // if bot arrived from 9
					begin
						previous_node = current_node;
						case(next_node)
						
							node_8: // wants to go to node 8
							begin
								if(path[13])
								begin
									action_to_take = turn_L_arc;
									current_node = wait_for_node;
								end
								else
								begin
									action_to_take  = turn_A;
									sequence_no = sequence_no - 1;
									next_node = node_9;
									current_node = wait_for_node;
								end
							end
							
							node_6: // wants to go to node 6
							begin
								action_to_take = turn_R;
								current_node = wait_for_node;
							end
							
							change_unit: 
							begin
								previous_node = node_9;
								current_node_task = nodes_to_decide;
								current_unit = next_unit;
							end
							
						endcase
					end
					
					
				
				endcase
			
			end
		
			node_8: // current position of bot is node '8' joining paths 13, 14 and 16 i.e bridge --------------------------------------------------------
			begin
				sequence_no = sequence_no + 1;
				next_node = nodes_to_follow[sequence_no];
				
				case(previous_node)
				
					node_7: // if bot arrived from node 7
					begin
						previous_node = current_node;
						case(next_node)
							
							node_7: // wants to go to node 7
							begin
								action_to_take = turn_A;
								current_node = wait_for_node;
							end
							
							node_3: // wants to go to node 3
							begin
								action_to_take = turn_R;
								current_node = wait_for_node;
							end
							
							node_9: // wants to go to node 9
							begin
								if(path[14])
								begin
									action_to_take = turn_L_arc;
									current_node = wait_for_node;
								end
								else
								begin
									action_to_take  = turn_A;
									sequence_no = sequence_no - 1;
									next_node = node_7;
									current_node = wait_for_node;
								end
							end
							
							change_unit: 
							begin
								previous_node = node_7;
								current_node_task = nodes_to_decide;
								current_unit = next_unit;
							end
							
						endcase
					end
					
					node_9: // if bot arrived from node 9
					begin
						previous_node = current_node;
						case(next_node)
						
							node_9: // wants to go to node 9
							begin
								action_to_take = turn_A;
								current_node = wait_for_node;
							end
							
							node_3: // wants to go to node 3
							begin
								action_to_take = turn_L;
								current_node = wait_for_node;
							end
							
							node_7: // wants to go to node 7
							begin
								if(path[13])
								begin
									action_to_take = turn_R_arc;
									current_node = wait_for_node;
								end
								
								else
								begin
									action_to_take = turn_A;
									sequence_no = sequence_no - 1;
									next_node = node_9;
									current_node = wait_for_node;
								end
							end
							
							change_unit: 
							begin
								previous_node = node_9;
								current_node_task = nodes_to_decide;
								current_unit = next_unit;
							end
							
						endcase
					end
					
					node_3: // if bot arrived from node 3
					begin
						previous_node = current_node;
						case(next_node)
					
							node_7: // wants to got to node 7
							begin
								if(path[13])
								begin
									action_to_take = turn_L;
									current_node = wait_for_node;
								end
								else
								begin
									action_to_take = turn_R;
									sequence_no = sequence_no - 1;
									next_node = node_9;
									current_node = wait_for_node;
								end
							end
						
							node_9:// wants to go to node 9
							begin
								if(path[13])
								begin
									action_to_take = turn_L;
									sequence_no = sequence_no - 1;
									next_node = node_7;
									current_node = wait_for_node;
								end
								else
								begin
									action_to_take = turn_R;
									current_node = wait_for_node;
								end
							end
							
							change_unit: 
							begin
								previous_node = node_3;
								current_node_task = nodes_to_decide;
								current_unit = next_unit;
							end
							
						endcase
					end
				endcase
			end
			
			node_9: // current position of bot is node '9' joing paths 6, 14 and 7 --------------------------------------------------------------------
			begin
				sequence_no = sequence_no + 1;
				next_node = nodes_to_follow[sequence_no];
				
				case(previous_node)
				
					node_7: // if bot arrived from node 7
					begin
						previous_node = current_node;
						case(next_node)
							
							node_7: // wants to go to node 7
							begin
								action_to_take = turn_A;
								current_node = wait_for_node;
							end
							
							node_10: // wants to go to node 10
							begin
								action_to_take = turn_L;
								current_node = wait_for_node;
							end
							
							node_8: // wants to go to node 8
							begin
								if(path[14])
								begin
									action_to_take = turn_R_arc;
									current_node = wait_for_node;
								end
								else
								begin
									action_to_take = turn_A;
									next_node = node_7;
									sequence_no = sequence_no - 1;
									current_node = wait_for_node; 
								end
							end
							
							change_unit: 
							begin
								previous_node = node_7;
								current_node_task = nodes_to_decide;
								current_unit = next_unit;
							end
							
						endcase
					end
					
					node_8: // if bot arrived from node 8
					begin
						previous_node = current_node;
						case(next_node)
						
							node_8: // wants to go to node 8
							begin
								action_to_take = turn_A;
								current_node = wait_for_node;
							end
							
							node_10: // wants to go to node 10
							begin
								action_to_take = turn_R;
								current_node = wait_for_node;
							end
							
							node_7: // wants to go to node 7
							begin
								if(path[6])
								begin
									action_to_take = turn_L_arc;
									current_node = wait_for_node;
								end
								else
								begin
									action_to_take = turn_A;
									next_node = node_8;
									sequence_no = sequence_no - 1;
									current_node = wait_for_node; 
								end
							end
							
							change_unit: 
							begin
								previous_node = node_8;
								current_node_task = nodes_to_decide;
								current_unit = next_unit;
							end
							
						endcase
					end
					
					node_10: // if bot arrived from node 10
					begin
						previous_node = current_node;
						case(next_node)
					
							node_7: // wants to got to node 7
							begin
								if(path[14])
								begin
									action_to_take = turn_L;
									sequence_no = sequence_no - 1;
									next_node = node_8;
									current_node = wait_for_node;
								end
								else
								begin
									action_to_take = turn_R;
									current_node = wait_for_node;
								end
							end
						
						
							node_8:// wants to go to node 8
							begin
								if(path[14])
								begin
									action_to_take = turn_L;
									current_node = wait_for_node;
								end
								else
								begin
									action_to_take = turn_R;
									sequence_no = sequence_no - 1;
									next_node = node_7;
									current_node = wait_for_node;
								end
							end
							
							change_unit: 
							begin
								previous_node = node_10;
								current_node_task = nodes_to_decide;
								current_unit = next_unit;
							end
							
						endcase
					end
				endcase
			end
			
//----------------------------------------------- Packing Unit (PU) -----------------------------------------------------------------------			
			
			node_10: // current position of bot is node '10' joing paths 7, 8 and 15 --------------------------------------------------------------------
			begin
				sequence_no = sequence_no + 1;
				next_node = nodes_to_follow[sequence_no];
				
				case(previous_node)
					
					node_9: // if bot arrived from node 9
					begin
						// as bot arrived from node 9 is shows that it is to travel to node 11
						previous_node = current_node; 
						case(next_node)
							node_11:
							begin
								if (path[8])
								begin 
								action_to_take = turn_L;
								current_node = wait_for_node;
								end
						
								else
								begin
								action_to_take = turn_R;
								current_node = wait_for_node;
								end
							end
							
							change_unit: 
							begin
								previous_node = node_9;
								current_node_task = nodes_to_decide;
								current_unit = next_unit;
							end
							
						endcase
					end
					
					node_11: // if bot arrived from node 11
					begin
						previous_node = current_node;
						case(next_node)
						
							node_11: //want to go to node 11
							begin
								if(!path[8] | !path[15])
								begin
									action_to_take = turn_A;
									current_node = wait_for_node;
								end
								
								else 
								begin
									action_to_take = turn_R_arc;
									current_node = wait_for_node;
								end
							end
							
							node_9: // want to go to node 9
							begin
								if(!path[15])
								begin
									action_to_take = turn_R;
									current_node = wait_for_node;
								end
								else
								begin
									action_to_take = turn_L;
									current_node = wait_for_node;
								end
							end
							
							change_unit: 
							begin
								previous_node = node_11;
								current_node_task = nodes_to_decide;
								current_unit = next_unit;
							end
							
						endcase
					end
				endcase
			end
			
			node_11: // current position of bot is node '11' joing paths 8, 9 and 15 --------------------------------------------------------------------
			begin
				sequence_no = sequence_no + 1;
				next_node = nodes_to_follow[sequence_no];
				
				case(previous_node)
					
					node_10: // if bot arrived from node 10
					begin
						previous_node = current_node;
						case(next_node)
						
							node_10: // want to go to node 10
							begin
								if(!path[8] | !path[15])
								begin
									action_to_take = turn_A;
									current_node = wait_for_node;
								end
								
								else 
								begin
									action_to_take = turn_R_arc;
									current_node = wait_for_node;
								end
							end
							
							node_1: // want to go to node 1
							begin
								if(!path[8])
								begin
									action_to_take = turn_R;
									current_node = wait_for_node;
								end
								else
								begin
									action_to_take = turn_L;
									current_node = wait_for_node;
								end
							end
							
							change_unit: 
							begin
								previous_node = node_10;
								current_node_task = nodes_to_decide;
								current_unit = next_unit;
							end
							
						endcase
					end
					
					node_1: // if bot arrived from node 1
					begin
						// as bot arrived from node 1 is shows that it is to travel to node 10
						previous_node = current_node; 
						case(next_node)
							
							node_10:
							begin
								if (path[15])
								begin 
									action_to_take = turn_L;
									current_node = wait_for_node;
								end
						
								else
								begin
									action_to_take = turn_R;
									current_node = wait_for_node;
								end
							end
							
							change_unit: 
							begin
								previous_node = node_1;
								current_node_task = nodes_to_decide;
								current_unit = next_unit;
							end
							
						endcase
						
					end
					

				endcase
			end
		endcase	
	end
	endcase
end

//-------------------------------------------------------------------------------------------------------------------------------			
	
//---------------------------------------------------------------------------------------------------------------------	
	

	
	/*
	 70-70 for both the motors results in staight
	*/
	
	//assigning output
	assign speed_a1_a =  r_speed_a1_a ; // left_motor front
	assign speed_a1_b =  r_speed_a1_b ;
	assign speed_b1_a =  r_speed_b1_a ;  // right_motor front
	assign speed_b1_b =  r_speed_b1_b ;
		
	assign start_detecting = r_start_detecting;
	assign Unit_at = current_unit;
	
	assign o_current_node = previous_node;
	assign o_current_unit = action_to_take;
	
endmodule
	
	
