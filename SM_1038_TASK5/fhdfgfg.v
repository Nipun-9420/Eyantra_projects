module control_bot(
	input clk,
	input [2:0] adc_data,
	input [251:0]path,
	output [6:0] speed_a1_a , // speed of right motor 
	output [6:0] speed_b1_a , // speed of right motor
	output [6:0] speed_a1_b , // speed of left motor
	output [6:0] speed_b1_b,  // speed of left motor
	

	
	//*******************LED Output**********************
	output l_1,
	output l_2,
	output l_3,
	output l_4,
	
	output [6:0]s;
	output [6:0]e;
	//**************Electromagnet Output******************
	output elctro,
	output elctro_start,
	output elctro_d,
	//**************Color output
	output start_detecting
	
	//*****************************************
);

//*****************LED For nodes***************
	reg r_l_1 = 0; 
	reg r_l_2 = 0;
	reg r_l_3 = 0;
	reg r_l_4 = 0;
	
	assign l_1 = r_l_1;
	assign l_2 = r_l_2;
	assign l_3 = r_l_3;
	assign l_4 = r_l_4;	
	
	
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
	
	
	//********************assign start node conditions*******************
	reg path_status;
	parameter path_sending=1'b0;
	parameter path_get = 1'b1;
	//************************path_Decleration**********************
	reg [2:0]path_decide;
	parameter take_node_value=2'b000;
	parameter path_1=2'b001;
	parameter path_2=2'b010;
	parameter path_3=2'b011;
	parameter stop=2'b100;
	//*********************Node_to_follow*************
	reg [6:0]node_to_follow[0:36];
	
	//***************variables for start node and end node******************
	reg [6:0]r_s;  //***********dumy start variable
	reg [6:0]r_e;
	
	
	
	always @ (posedge clk)
	begin
		case(path_staus)
			path_sending:
			begin
				case(path_decide)
					take_node_value:
					begin
						node_to_follow[0]=path[0:6];
						node_to_follow[1]=path[7:13];
						node_to_follow[2]=path[14:20];
						node_to_follow[3]=path[21:27];
						node_to_follow[4]=path[21:27];
						node_to_follow[5]=path[28:34];
						node_to_follow[6]=path[35:41];
						node_to_follow[7]=path[42:47];
						node_to_follow[8]=path[48:55];
						node_to_follow[9]=path[56:62];
						node_to_follow[10]=path[63:69];
						node_to_follow[11]=path[70:76];
						node_to_follow[12]=path[77:83];
						node_to_follow[13]=path[84:90];
						node_to_follow[14]=path[91:97];
						node_to_follow[15=path[98:104];
						node_to_follow[16]=path[105:111];
						node_to_follow[17]=path[112:117];
						node_to_follow[18]=path[118:125];
						node_to_follow[19]=path[126:132];
						node_to_follow[20]=path[133:139];
						node_to_follow[21]=path[140:146];
						node_to_follow[22]=path[147:153];
						node_to_follow[23]=path[154:160];
						node_to_follow[24]=path[161:167];
						node_to_follow[25]=path[168:174];
						node_to_follow[26]=path[175:181];
						node_to_follow[27]=path[182:187];
						node_to_follow[28]=path[188:195];
						node_to_follow[29]=path[196:202];
						node_to_follow[30]=path[203:209];
						node_to_follow[31]=path[210:216];
						node_to_follow[32]=path[217:223];
						node_to_follow[33]=path[224:230];
						node_to_follow[34]=path[231:237];
						node_to_follow[35]=path[238:244];
						node_to_follow[36]=path[245:251];
						
						path_staus = path_get;
						end
						
				path_1:
				begin
						r_s=33;
						r_e=3;
						path_staus = path_sending;
						path_decide = start;
				end
				
				path_2:
				begin
						r_s=3;
						r_e=6;
						path_staus = path_sending;
						path_decide = start;
				end
				
				endcase
			end
		endcase
	end
	