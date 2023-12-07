module sm_bot(    //  always double check bits whether no of bits assigned to variables are enough
	input clk,   //Clock
	
	input [2:0] adc_data,  // line sensor reading 
	input color_detected,  // color detection status
	
	//input [258:0] path,      //Dijktra's algorithm path
	//input path_decided,      // check whether path is calculated or not
	
	output [6:0] speed_a1_a , // speed of right motor 
	output [6:0] speed_a1_b , // speed of right motor
	output [6:0] speed_b1_a , // speed of left motor
	output [6:0] speed_b1_b , // speed of left motor
	
	
	output elctro,             // elctro magnet value
	output start_elctro,       //electro magnet detection value
	output elctro_R,           // electro magnet status
	
	output start_detecting,    //color detection value      
	output [2:0] Unit_at,			// * review code to remove unnecessary test cases
	
	/*output [6:0]s,           // start node output
	output [6:0]e,    */       //End node Output 
	                         
	output start_algo        // Start algorithm status
	
);

	// varialbles for speed
	reg [6:0] r_speed_a1_a ; // speed of right motor 
	reg [6:0] r_speed_a1_b ; // speed of right motor
	reg [6:0] r_speed_b1_a ; // speed of left motor
	reg [6:0] r_speed_b1_b ; // speed of left motor
	
	reg r_start_detecting ; // to signal uart controller to consider color detection valid
	 
	
	// for node_tasks 1 bit reg
	reg [1:0]current_node_task ;
	
	// for units 3 bits regs
	reg [2:0] current_unit ;  // to indicate current node 
//	reg [2:0] next_unit ;  // to indicate next node				
//	reg [2:0] previous_unit ; // to indicate previous unit	
//	
//	// for current process to detect color or not to detect
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
	reg [3:0] nodes_to_follow [0:36]	; // 4 bit array of 5 regs yo hold nodes to follow	
	
	// counters
	reg [3:0] sequence_no ;	// for nodes 
	reg [3:0] unit_no ; // for units 	
	
	// defining node_tasks to be carried out
	parameter nodes_to_decide = 2'b00;
	parameter algorithm_calculation =2'b01;
	parameter node_follow = 2'b10;
	
	//start node and end node to decide
/*	reg [6:0] r_s;
	reg [6:0] r_e;*/
	// defining states to use in the state macine logic
	parameter wait_for_node = 38;
	parameter node_A = 0;
	parameter node_B = 1;
	parameter node_C = 2;
	parameter node_D = 3;
	parameter node_E = 4; 
	parameter node_F = 5;
	parameter node_G = 6;
	parameter node_H = 7;
	parameter node_I = 8;
	parameter node_J = 9;
	parameter node_K = 10;
	parameter node_L = 11;
	parameter node_M = 12;
	parameter node_N = 13;
	parameter node_O = 14;
	parameter node_P = 15;
	parameter node_Q = 16; 
	parameter node_R = 17;
	parameter node_S = 18;
	parameter node_T = 19;
	parameter node_U = 20;
	parameter node_V = 21;
	parameter node_W = 22;
	parameter node_X = 23;
	parameter node_Y = 24;
	parameter node_Z = 25;
	parameter node_AA = 26;
	parameter node_AB = 27;
	parameter node_AC = 28; 
	parameter node_AD = 29;
	parameter node_AE = 30;
	parameter node_AF = 31;
	parameter node_AG = 32;
	parameter node_AH = 33;
	parameter node_AI = 34;
	parameter node_AJ = 35;
	parameter node_AK = 36;
	parameter node_IMG = 37;
	parameter change_unit = 39; //********
	
	
	
	// defining states to use in the state machine logic
	parameter START = 3'b000;
	parameter W = 3'b001;
	parameter PP = 3'b010;
	parameter VG = 3'b011;
	parameter NG = 3'b100;
	parameter MT = 3'b101;
	parameter STOP = 3'b110; 
	
	// defining processes to be done at different units
	parameter	color_detection = 1'b0;
	parameter	go_to_next_unit = 1'b1;
	 
	 
	 //For algirithm
	 reg[2:0]path_to_decide;
	//algorithm
	parameter   go_to_position   = 3'b000;
	parameter   round_path       = 3'b001;
	parameter   supply_pick_path = 3'b010;
	parameter   st               = 3'b011;
	parameter   supply_drop_path = 3'b100;
	
	
	// defining color detections status
	parameter	to_detect = 2'b00;
	parameter	detecting= 2'b01;
	parameter	detected = 2'b10;
	parameter	not_detected = 2'b11;
	
	
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
		//sequence_no = 0;
		unit_no = 0;
		
		// initializing color detecting signal
		r_start_detecting = 0;
		
		// initializing detection_status
		detection_status = not_detected;
		
		//algorithm path sending
		 path_to_decide = go_to_position;
	end
	
	
// defining tasks for line following and turning ---------------------------------------------------------------------------------------
 	task line_follow ();  // this is used to follow line
	begin
		// adac_data is 3 bit bus and the bits represent the sensors itself. '1' means line detected '0' otherwise
		case (adc_data)
							// MSB is left_sensor and LSB is right_sensor
			
			3'b001 :
			begin
				r_speed_a1_a = 0; //96 60 2 80
				r_speed_b1_a = 0; //15 15 5
				r_speed_a1_b = 85;
				r_speed_b1_b = 50;
			end
			
			3'b011 :
			begin
				r_speed_a1_a = 0; //90 50 3 70
				r_speed_b1_a = 0; //70 30 10
				r_speed_a1_b = 85;
				r_speed_b1_b = 55;
			end
			
			3'b010 :
			begin	
				r_speed_a1_a = 0; //85 30 50
				r_speed_b1_a = 0; //91 30 60
				r_speed_a1_b = 80;
				r_speed_b1_b = 77;
			end
			
			3'b110 :
			begin
				r_speed_a1_a = 0; //50 30 10
				r_speed_b1_a = 0; //91 50 3 70
				r_speed_a1_b = 40;
				r_speed_b1_b = 80;
			end
			
			3'b100 :
			begin
				r_speed_a1_a = 0; //15 15 5
				r_speed_b1_a = 0; //90 60 2 80
				r_speed_a1_b = 40;
				r_speed_b1_b = 80;
			end
			
			3'b111 : // node condition 
			begin
				r_speed_a1_a = 0; //35 35 0
				r_speed_b1_a = 0; //35 35 0
				r_speed_a1_b = 80;
				r_speed_b1_b = 77;
			end
			
			3'b000 : // node condition 
			begin
				r_speed_a1_a = 0; //35 35 0
				r_speed_b1_a = 0; //35 35 0
				r_speed_a1_b = 85;
				r_speed_b1_b = 50;
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
		r_speed_a1_a = 0;
		r_speed_b1_a = 0;
		r_speed_a1_b = 40;
		r_speed_b1_b = 80; 
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
	
	task turn_left_arc (); // to turn left arc * need to modify
		begin
		r_speed_a1_a = 0;
		r_speed_b1_a = 0;
		r_speed_a1_b = 85;
		r_speed_b1_b = 50; 
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
	
	task turn_around (); 
		begin
		r_speed_a1_b = 65;
		r_speed_b1_a = 65;
		r_speed_a1_a = 0;
		r_speed_b1_b = 0; 
		end
	endtask
	
	
	//**********************Algorithm Variables*******************
	reg [3:0] graph[0:36][0:36];

	
	//****-----------------MY CODE start
	/*
	To DO
	
	
	1. make all distance from starting ==inf
	
	*/
	reg [6:0] distance_from_start[0:37]; 		
	reg [6:0] visited[0:37];
	reg [6:0] previous[0:37];
	reg [6:0] path[0:37];
	reg [6:0] path_final[0:37];
	
	reg [6:0] start_node ;
	reg [6:0] end_node;
	reg [6:0] small_dist = 99;
	reg [6:0] array_l = 37; // Array Length
	reg [6:0] min_i ; // Array Length
	
	reg [6:0] i_i;
	reg [6:0] S_Start = 0;
	
	
	//************************************
	//reg [3:0] sequence_no ;	// for nodes 
	//reg [3:0] unit_no ; // for units 	
	
	reg [6:0] a;
	reg [6:0] fun;
	reg [6:0] h=0;
	reg [6:0] l=0;
	reg [6:0] c;
	reg [30:0] count;
	reg [6:0] f=36;
	reg [13:0] res =0;
	
	//****************algorithm parameter
	reg [6:0] work_to_do ;
	parameter check_l            = 7'b0000001;
	parameter current_loop_check = 7'b0000010;
	parameter two_loop_check     = 7'b0000011;
	parameter make_path_1        = 7'b0000100;
	parameter make_path_2        = 7'b0000101;
	parameter make_path_invers1   = 7'b0000110;
	parameter make_path_invers2   = 7'b0001000;
	parameter make                = 7'b0000111;
	
	
	always @(posedge clk)
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
				
				//previous_unit = START;
				
				units_to_visit[0] = PP;
				units_to_visit[1] = VG;
				units_to_visit[2] = NG;
				units_to_visit[3] = MT;
				units_to_visit[4] = STOP;
									
				
		   	current_node_task = nodes_to_decide; 
				current_unit = units_to_visit[0];
				current_process = color_detection; 
				detection_status = to_detect;
				
			end
			
			PP:
			begin
				case(path_to_decide)
					 go_to_position:
					 begin
						start_node=33;
						end_node = 3;
						current_node_task = algorithm_calculation; 
						work_to_do = check_l;
					 end
				endcase
				
			end
			endcase
	end
	
	algorithm_calculation:
	begin
		if (S_Start==0)
			begin
					for(i_i=0;i_i<37;i_i=i_i+1)
					begin
						distance_from_start[i_i]=99;
						distance_from_start[start_node]=0;
						path[i_i]=37;
						path_final[i_i]=37;
						previous[i_i]=0;
						visited[i_i]=0;
						work_to_do = check_l;
						small_dist=99;
						
					end
					S_Start=1;
			end
				
            graph[0][1]=1;graph[0][8]=3;graph[0][2]=2;graph[1][0]=1;graph[2][0]=2;
				graph[2][4]=2;graph[2][3]=3;graph[3][2]=3;graph[3][6]=2;graph[3][17]=4;
				graph[4][2]=2;graph[4][5]=1;graph[4][11]=2;graph[5][4]=1;graph[6][3]=2;
				graph[6][14]=3;graph[6][7]=1;graph[7][6]=1;graph[8][0]=3;graph[8][33]=4;
				graph[8][10]=2;graph[9][10]=1;graph[10][9]=1;graph[10][8]=2;graph[10][11]=1;
				graph[11][10]=1;graph[11][4]=2;graph[11][12]=3;graph[11][18]=1;graph[12][11]=3;
				graph[12][13]=1;graph[12][14]=1;graph[12][23]=2;graph[13][12]=1;
            graph[14][12]=1;graph[14][6]=3;graph[14][15]=2;graph[15][14]=2;graph[15][16]=1;
				graph[15][17]=1;graph[16][15]=1;graph[17][15]=1;graph[17][3]=4;graph[17][26]=2;
				graph[18][11]=1;graph[18][19]=1;graph[18][21]=1;graph[19][18]=1;graph[20][21]=1;
				graph[21][20]=1;graph[21][22]=1;graph[21][18]=1;graph[21][28]=1;graph[22][21]=1;
				graph[23][12]=2;graph[23][24]=1;graph[23][34]=3;graph[24][23]=1;graph[25][26]=1;
				graph[26][17]=2;graph[26][35]=4;graph[26][25]=1;graph[27][28]=1;graph[28][27]=1;
				graph[28][29]=1;
				graph[28][21]=1;graph[28][31]=1;
            graph[29][28]=1;graph[30][31]=1;graph[31][30]=1;graph[31][28]=1;graph[31][32]=1;
				graph[31][33]=1;graph[32][31]=1;graph[33][31]=1;graph[33][8]=4;graph[33][34]=3;
				graph[34][33]=3;graph[34][23]=3;graph[34][35]=2;graph[35][34]=2;graph[35][26]=4;
				graph[35][36]=1;graph[36][35]=1;

		 
		 case(work_to_do)
			check_l:
				begin//--------check
						small_dist=99;
						for(a=0; a<37; a=a+1)
							begin //@@
							
								if((visited[a]==0) && (distance_from_start[a]<small_dist))
										begin //_if
										small_dist=distance_from_start[a];
										min_i = a;
										work_to_do = current_loop_check;
										end   //_if
							end   //@@
				end//----------check
				
				
				current_loop_check:
				begin//--------current_loop_check
						for (c=0; c<37; c=c+1)
							begin//XX
								if((graph[min_i][c])!=0 && (visited[c]==0) &&(small_dist+graph[min_i][c]<distance_from_start[c]) )
									begin //-
										distance_from_start[c] =small_dist+graph[min_i][c];
										previous[c] = min_i;
									
									end	//-
							end//XX
						work_to_do = two_loop_check;
				end//----------current_loop_check
				
				
				
				two_loop_check:
				begin//--------two_loop_check
				      small_dist=99;
						visited[min_i] = 1;
						//work_to_do = make_path_1;
						if(count==37)
							begin
								fun =6;
						      work_to_do = make_path_1;
							end
						 else 
							begin
								fun =12;
								count = count+1;
								work_to_do = check_l;
							end
				end//----------two_loop_check
				
				make_path_1:
				begin//make_patj_1
					   if (end_node!= start_node)
						begin
							path[h]=end_node;
							end_node = previous[end_node];
							h=h+1;
						end
						work_to_do = make_path_2;
				end //make_patj_1
				
				make_path_2:
				begin//--------two_loop_check
				      
						if(res==37)
							begin
								//fun =6;
						      work_to_do = make_path_invers1;
							end
						 else 
							begin
								//fun =12;
								res = res+1;
								work_to_do = make_path_1;
							end
				end//----------two_loop_check
				
				
			
			make_path_invers1:	
				begin
					if(path[f]<path_final[l])
					begin
						path_final[l] = path[f];
						l=l+1;
					end
					
				   else if(path[f] == 37)
					begin
						path_final[f] = path[f];
					end
					work_to_do = make_path_invers2;
				end	
			
		
	        make_path_invers2:
				begin//--------two_loop_check
				     if(f == 0)
							begin
								//fun =6;
						      work_to_do = make;
							end
						 else 
							begin
								//fun =12;
								f = f-1;
								work_to_do = make_path_invers1;
							end
				end//----------two_loop_check
					
			make:
			begin
				small_dist=99;
				/*r_speed_a1_a = 68;
				r_speed_b1_a = 0;
				r_speed_a1_b = 0;
				r_speed_b1_b = 30; */
			   current_node_task = node_follow; 
				sequence_no =1 ;
				current_node = path_final[0];
				previous_node = start_node;
				//next_node = path_final[0];
				//fun=13;
			end
		 endcase
		 
		 
		end

	//-------------------------------------------------------------------------------------------------------------------------------			
	
	
	
	node_follow:
	begin
		
		/*
		r_speed_a1_a = 68;
		r_speed_a1_b = 30;
		r_speed_b1_a = 0;
		r_speed_b1_b = 0;*/ 

		case(current_node) 
		
			wait_for_node:  // this case is when trvelling on path or arch between two nodes -----------------------------------
			begin
				case(action_to_take)
					
					follow_line:
					begin
						//line_follow();
						//if( adc_data == 3'b111) current_node =  next_node;
					end
					
					turn_R:
					begin
						turn_right();
						//if (adc_data != 3'b111 &  adc_data != 3'b000) action_to_take = follow_line;
					end
					
					turn_R_arc:
					begin
						turn_right_arc();
						//if (adc_data != 3'b111 &  adc_data != 3'b000) action_to_take = follow_line;
					end
					
					turn_L:
					begin
						turn_left();
						//if (adc_data != 3'b111 &  adc_data != 3'b000) action_to_take = follow_line;
					end

					turn_L_arc:
					begin
						turn_left_arc();
						//if (adc_data != 3'b111 &  adc_data != 3'b000) action_to_take = follow_line;
					end

							
					turn_A:
					begin
						turn_around();
						//if ( adc_data == 3'b010) action_to_take = follow_line;
					end
					
					go_st:
					begin
						go_straight();
						//if (adc_data != 3'b111 &  adc_data != 3'b000) action_to_take = follow_line;
					end
				endcase
			end
			
		
		
			// current position of bot is node '1' joining paths 1, 9 and 0 (start) --------------------------------------------------------------------------------
			node_A:
			begin
				sequence_no = sequence_no + 1;
				next_node = path_final[sequence_no];
			
				case(previous_node) 
			
					node_I: // if the bot has arrived from start position
					begin
						previous_node = current_node;
						case(next_node)
				
							node_C:
							begin
								action_to_take = go_st;
								current_node = wait_for_node;
							end
					
							node_B:
							begin
								action_to_take = turn_R;
								current_node = wait_for_node;
							end
							
							
						endcase
					end
			
					node_C: // if bot has arrived from node no. 2 
					begin
						previous_node = current_node;
						case(next_node)
				
							node_I:
							begin
								action_to_take = go_st;
								current_node = wait_for_node;
							end
					
							node_B :
							begin
								action_to_take = turn_R;
								current_node = wait_for_node;
							end		
						endcase
			      end
					
					node_B: // if bot has arrived from node no. 2 
					begin
						previous_node = current_node;
						case(next_node)
				
							node_I:
							begin
								action_to_take = turn_R_arc;
								current_node = wait_for_node;
							end
					
							node_C :
							begin
								action_to_take = turn_L_arc;
								current_node = wait_for_node;
							end
						endcase
			      end
					
					
				endcase
			  end
				
				//*********************node C conditions*********************************************************************************
			  node_C:
			  begin
				sequence_no = sequence_no + 1;
				next_node = path_final[sequence_no];
			
				case(previous_node) 
			
					node_A: // if the bot has arrived from start position
					begin
						previous_node = current_node;
						case(next_node)
				
							node_D:
							begin
								action_to_take = go_st;
								current_node = wait_for_node;
							end
					
							node_E:
							begin
								action_to_take = turn_L;
								current_node = wait_for_node;
							end
							
							
						endcase
					end
			
					node_D: // if bot has arrived from node no. 2 
					begin
						previous_node = current_node;
						case(next_node)
				
							node_A:
							begin
								action_to_take = go_st;
								current_node = wait_for_node;
							end
					
							node_E :
							begin
								action_to_take = turn_R;
								current_node = wait_for_node;
							end
						endcase
						end
						
					node_E: // if bot has arrived from node no. 2 
					begin
						previous_node = current_node;
						case(next_node)
				
							node_D:
							begin
								action_to_take = turn_L;
								current_node = wait_for_node;
							end
					
							node_A :
							begin
								action_to_take = turn_R;
								current_node = wait_for_node;
							end
					endcase
					end
				endcase
				end
				
				
				//**********************Node D********************************************************************************************
           node_D:
			  begin
				sequence_no = sequence_no + 1;
				next_node = path_final[sequence_no];
			
				case(previous_node) 
			
					node_C: // if the bot has arrived from start position
					begin
						previous_node = current_node;
						case(next_node)
				
							node_R:
							begin
								action_to_take = go_st;
								current_node = wait_for_node;
							end
					
							node_G:
							begin
								action_to_take = turn_L;
								current_node = wait_for_node;
							end
							
							node_IMG:
							begin
								r_speed_a1_a = 0; //35 35 0
								r_speed_b1_a = 0; //35 35 0
								r_speed_a1_b = 0;
								r_speed_b1_b = 0;
							end
							
						endcase
					end
			
					node_R: // if bot has arrived from node no. 2 
					begin
						previous_node = current_node;
						case(next_node)
				
							node_C:
							begin
								action_to_take = go_st;
								current_node = wait_for_node;
							end
					
							node_G :
							begin
								action_to_take = turn_R;
								current_node = wait_for_node;
							end
						endcase
						end
						
					node_G: // if bot has arrived from node no. 2 
					begin
						previous_node = current_node;
						case(next_node)
				
							node_L:
							begin
								action_to_take = turn_L;
								current_node = wait_for_node;
							end
					
							node_R :
							begin
								action_to_take = turn_R;
								current_node = wait_for_node;
							end
					endcase
					end
				endcase
			end
				
				//***********************NODE I***************************************************************************************************
			  node_I:
			  begin
				sequence_no = sequence_no + 1;
				next_node = path_final[2];
			
				case(previous_node) 
			
					node_AH: // if the bot has arrived from start position
					begin
						previous_node = current_node;
						case(next_node)
				
							node_A:
							begin
								action_to_take = go_st;
								current_node = wait_for_node;
							end
					
							node_K:
							begin
								action_to_take = turn_L;
								current_node = wait_for_node;
							end
							
							
						endcase
					end
			
					node_A: // if bot has arrived from node no. 2 
					begin
						previous_node = current_node;
						case(next_node)
				
							node_AH:
							begin
								action_to_take = go_st;
								current_node = wait_for_node;
							end
					
							node_K :
							begin
								action_to_take = turn_R;
								current_node = wait_for_node;
							end
						endcase
						end
						
					node_K: // if bot has arrived from node no. 2 
					begin
						previous_node = current_node;
						case(next_node)
				
							node_A:
							begin
								action_to_take = turn_L;
								current_node = wait_for_node;
							end
					
							node_AH :
							begin
								action_to_take = turn_R;
								current_node = wait_for_node;
							end
					endcase
					end
					
					
					
					
					
					
					
				endcase
			end
				
				
		endcase
		end
	endcase
	end
		//assigning output
	assign speed_a1_a = previous_node; // left_motor front
	assign speed_a1_b = current_node;
	assign speed_b1_a = next_node;  // right_motor front
	assign speed_b1_b = action_to_take;
	

endmodule
