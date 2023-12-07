module for_loop(
input clk,
//output [13:0]d,
output [13:0]A,
output [13:0]B,
output [13:0]C,
output [13:0]D,
output [13:0]E,
output [13:0]F,
output [13:0]G,
output [13:0]H,
output [13:0]I,
output [13:0]J,
output [13:0]K,
output [13:0]L,
output [13:0]M,

output l_1,
output l_2,
output l_3,
output l_4
);

/*reg [3:0] graph[0:13][0:13];
initial
	begin
		
		for(i = 0;i < 13;i=i+1)
		begin
			for(j = 0;j < 13;j =j+1)
			begin
				if((i==2 && j==3)|| (i==3 && j==2)||(i==4 && j==5)||(i==5 && j==4)||(i==6 && j==9)||(i==7 && j==11)||(i==9 && j==10)||(i==10 && j==9) ||(i==9 && j==6)||(i==11 && j==7)||(i==11 && j==12)||(i==12 && j==11))
				begin
					graph[i][j]=1;
										r_l_1 = 1; 
										r_l_2 = 0;
										r_l_3 = 0;
										r_l_4 = 1;
				end
				else if((i==0 && j==2)||(i==1 && j==4)||(i==2 && j==0)||(i==2 && j==8)||(i==4 && j==1)||(i==8 && j==2)||(i==10 && j==11)||(i==11 && j==10))
				begin
					graph[i][j]=2;
				end
				else if((i==0 && j==1)||(i==1 && j==0)||(i==4 && j==10)||(i==8 && j==9)||(i==9 && j==8)||(i==10 && j==4))
				begin
					graph[i][j]=3;
				end
				else if((i==1 && j==12)||(i==12 && j==1))
				begin
					graph[i][j]=4;
				end
				else
				begin
					graph[i][j]=22;
				end
			end
		end
		//array = 4'b0000;  // -----------------referance
 		//array1 = 4'b0000;  //-----------------refereace 
	end*/
//******************************Node Parameter******************
	parameter n_0 = 4'b0000;
	parameter n_1 = 4'b0001;
	parameter n_2 = 4'b0010;
	parameter n_3 = 4'b0011;
	parameter n_4 = 4'b0100;
	parameter n_5 = 4'b0101;
	parameter n_6 = 4'b0110;
	parameter n_7 = 4'b0111;
	parameter n_8 = 4'b1000;
	parameter n_9 = 4'b1001;
	parameter n_10 = 4'b1010;
	parameter n_11= 4'b1011;
	parameter n_12 = 4'b1100;
	
	reg[12:0]row;
	reg[12:0]column;
	reg[2:0]g;
	
	task graph();
	begin
		case(row)
		n_0:
		begin
			case(column)
			n_0:
			begin
				g=0;
			end
			n_1:
			begin
				g=3;
			end
			n_2:
			begin
				g=2;
			end
			n_3:
			begin
				g=0;
			end
			n_4:
			begin
				g=0;
			end
			n_5:
			begin
				g=0;
			end
			n_6:
			begin
				g=0;
			end
			n_7:
			begin
				g=0;
			end
			n_8:
			begin
				g=0;
			end
			n_9:
			begin
				g=0;
			end
			n_10:
			begin
				g=0;
			end
			n_11:
			begin
				g=0;
			end
			n_12:
			begin
				g=0;
			end
			endcase
		end
		
		n_1:
		begin
			case(column)
			n_0:
			begin
				g=3;
			end
			n_1:
			begin
				g=0;
			end
			n_2:
			begin
				g=0;
			end
			n_3:
			begin
				g=0;
			end
			n_4:
			begin
				g=2;
			end
			n_5:
			begin
				g=0;
			end
			n_6:
			begin
				g=0;
			end
			n_7:
			begin
				g=0;
			end
			n_8:
			begin
				g=0;
			end
			n_9:
			begin
				g=0;
			end
			n_10:
			begin
				g=0;
			end
			n_11:
			begin
				g=0;
			end
			n_12:
			begin
				g=4;
			end
			endcase
		end
		
		n_2:
		begin
			case(column)
			n_0:
			begin
				g=2;
			end
			n_1:
			begin
				g=0;
			end
			n_2:
			begin
				g=0;
			end
			n_3:
			begin
				g=1;
			end
			n_4:
			begin
				g=0;
			end
			n_5:
			begin
				g=0;
			end
			n_6:
			begin
				g=0;
			end
			n_7:
			begin
				g=0;
			end
			n_8:
			begin
				g=2;
			end
			n_9:
			begin
				g=0;
			end
			n_10:
			begin
				g=0;
			end
			n_11:
			begin
				g=0;
			end
			n_12:
			begin
				g=0;
			end
			endcase
		end
		
		n_3:
		begin
			case(column)
			n_0:
			begin
				g=0;
			end
			n_1:
			begin
				g=0;
			end
			n_2:
			begin
				g=1;
			end
			n_3:
			begin
				g=0;
			end
			n_4:
			begin
				g=0;
			end
			n_5:
			begin
				g=0;
			end
			n_6:
			begin
				g=0;
			end
			n_7:
			begin
				g=0;
			end
			n_8:
			begin
				g=0;
			end
			n_9:
			begin
				g=0;
			end
			n_10:
			begin
				g=0;
			end
			n_11:
			begin
				g=0;
			end
			n_12:
			begin
				g=0;
			end
			endcase
		end
		
		n_4:
		begin
			case(column)
			n_0:
			begin
				g=0;
			end
			n_1:
			begin
				g=2;
			end
			n_2:
			begin
				g=0;
			end
			n_3:
			begin
				g=0;
			end
			n_4:
			begin
				g=0;
			end
			n_5:
			begin
				g=1;
			end
			n_6:
			begin
				g=0;
			end
			n_7:
			begin
				g=0;
			end
			n_8:
			begin
				g=0;
			end
			n_9:
			begin
				g=0;
			end
			n_10:
			begin
				g=3;
			end
			n_11:
			begin
				g=0;
			end
			n_12:
			begin
				g=0;
			end
			endcase
		end
		
		n_5:
		begin
			case(column)
			n_0:
			begin
				g=0;
			end
			n_1:
			begin
				g=0;
			end
			n_2:
			begin
				g=0;
			end
			n_3:
			begin
				g=0;
			end
			n_4:
			begin
				g=1;
			end
			n_5:
			begin
				g=0;
			end
			n_6:
			begin
				g=0;
			end
			n_7:
			begin
				g=0;
			end
			n_8:
			begin
				g=0;
			end
			n_9:
			begin
				g=0;
			end
			n_10:
			begin
				g=0;
			end
			n_11:
			begin
				g=0;
			end
			n_12:
			begin
				g=0;
			end
			endcase
		end
		
		n_6:
		begin
			case(column)
			n_0:
			begin
				g=0;
			end
			n_1:
			begin
				g=0;
			end
			n_2:
			begin
				g=0;
			end
			n_3:
			begin
				g=0;
			end
			n_4:
			begin
				g=0;
			end
			n_5:
			begin
				g=0;
			end
			n_6:
			begin
				g=0;
			end
			n_7:
			begin
				g=0;
			end
			n_8:
			begin
				g=0;
			end
			n_9:
			begin
				g=1;
			end
			n_10:
			begin
				g=0;
			end
			n_11:
			begin
				g=0;
			end
			n_12:
			begin
				g=0;
			end
			endcase
		end
		
		n_7:
		begin
			case(column)
			n_0:
			begin
				g=0;
			end
			n_1:
			begin
				g=0;
			end
			n_2:
			begin
				g=0;
			end
			n_3:
			begin
				g=0;
			end
			n_4:
			begin
				g=0;
			end
			n_5:
			begin
				g=0;
			end
			n_6:
			begin
				g=0;
			end
			n_7:
			begin
				g=0;
			end
			n_8:
			begin
				g=0;
			end
			n_9:
			begin
				g=0;
			end
			n_10:
			begin
				g=0;
			end
			n_11:
			begin
				g=1;
			end
			n_12:
			begin
				g=0;
			end
			endcase
		end
		
		n_8:
		begin
			case(column)
			n_0:
			begin
				g=0;
			end
			n_1:
			begin
				g=0;
			end
			n_2:
			begin
				g=2;
			end
			n_3:
			begin
				g=0;
			end
			n_4:
			begin
				g=0;
			end
			n_5:
			begin
				g=0;
			end
			n_6:
			begin
				g=0;
			end
			n_7:
			begin
				g=0;
			end
			n_8:
			begin
				g=0;
			end
			n_9:
			begin
				g=3;
			end
			n_10:
			begin
				g=0;
			end
			n_11:
			begin
				g=0;
			end
			n_12:
			begin
				g=0;
			end
			endcase
		end
		
		n_9:
		begin
			case(column)
			n_0:
			begin
				g=0;
			end
			n_1:
			begin
				g=0;
			end
			n_2:
			begin
				g=0;
			end
			n_3:
			begin
				g=0;
			end
			n_4:
			begin
				g=0;
			end
			n_5:
			begin
				g=0;
			end
			n_6:
			begin
				g=1;
			end
			n_7:
			begin
				g=0;
			end
			n_8:
			begin
				g=3;
			end
			n_9:
			begin
				g=0;
			end
			n_10:
			begin
				g=1;
			end
			n_11:
			begin
				g=0;
			end
			n_12:
			begin
				g=0;
			end
			endcase
		end
		
		n_10:
		begin
			case(column)
			n_0:
			begin
				g=0;
			end
			n_1:
			begin
				g=0;
			end
			n_2:
			begin
				g=0;
			end
			n_3:
			begin
				g=0;
			end
			n_4:
			begin
				g=3;
			end
			n_5:
			begin
				g=0;
			end
			n_6:
			begin
				g=0;
			end
			n_7:
			begin
				g=0;
			end
			n_8:
			begin
				g=0;
			end
			n_9:
			begin
				g=1;
			end
			n_10:
			begin
				g=0;
			end
			n_11:
			begin
				g=2;
			end
			n_12:
			begin
				g=0;
			end
			endcase
		end
		
		n_11:
		begin
			case(column)
			n_0:
			begin
				g=0;
			end
			n_1:
			begin
				g=0;
			end
			n_2:
			begin
				g=0;
			end
			n_3:
			begin
				g=0;
			end
			n_4:
			begin
				g=0;
			end
			n_5:
			begin
				g=0;
			end
			n_6:
			begin
				g=0;
			end
			n_7:
			begin
				g=1;
			end
			n_8:
			begin
				g=0;
			end
			n_9:
			begin
				g=0;
			end
			n_10:
			begin
				g=2;
			end
			n_11:
			begin
				g=0;
			end
			n_12:
			begin
				g=1;
			end
			endcase
		end
		
		n_12:
		begin
			case(column)
			n_0:
			begin
				g=0;
			end
			n_1:
			begin
				g=4;
			end
			n_2:
			begin
				g=0;
			end
			n_3:
			begin
				g=0;
			end
			n_4:
			begin
				g=0;
			end
			n_5:
			begin
				g=0;
			end
			n_6:
			begin
				g=0;
			end
			n_7:
			begin
				g=0;
			end
			n_8:
			begin
				g=0;
			end
			n_9:
			begin
				g=0;
			end
			n_10:
			begin
				g=0;
			end
			n_11:
			begin
				g=1;
			end
			n_12:
			begin
				g=0;
			end
			endcase
		end
		endcase
		
	end 
	endtask
	
	//parameter n = 37;
	//parameter s = 33;
	//parameter e = 3;
	
	//******************************-----------------MY CODE start
	/*
	To DO
	1. make all distance from starting ==inf
	
	*/
	reg [13:0] i;
	reg [13:0] j;
	reg [13:0] distance_from_start[0:13]; 
	reg [13:0] visited[0:13];
	reg [13:0] previous_node[0:13];
	reg [13:0] path[0:13];
	reg [13:0] path_final[0:13];
	
	reg [13:0] start_node = 10;
	reg [13:0] end_node = 2;
	reg [13:0] small_dist ;
	reg [13:0] array_l = 13; // Array Length
	reg [13:0] min_i ; // Array Length
	reg [13:0] lis ; // for path
	//reg [13:0] ref ; // for path
	reg [13:0] i_i;
	reg [13:0] S_Start = 0;
	reg [13:0] m_i;  // minimum index
	reg [13:0] check;
	reg [13:0] a;
	reg [13:0] c;
	reg [13:0] tag;
	
	reg r_l_1 ; 
	reg r_l_2 ;
	reg r_l_3 ;
	reg r_l_4 ;
	//******************************------------------MY CODE ENDES
	always @(posedge clk)
	begin // *** start
	//--------------------- Array value decleration
			if (S_Start==0)
				begin
					for(i_i=0;i_i<13;i_i=i_i+1)
					begin
						distance_from_start[i_i]=99;
						distance_from_start[start_node]=0;
						visited[i_i]=0;
						previous_node[i_i]=0;
						path[i_i]=0;
						path_final[i_i]=0;
					end
				end
				S_Start=1;
		//---------------------------DJ start
		for(m_i=0; m_i<13; m_i=m_i+1)
			begin //00
				for(check=0; check<13; check=check+1)
					begin //++
						small_dist=99;
						for(a=0; a<13; a=a+1)
							begin //@@
								if((visited[a]==0) && (distance_from_start[a]<small_dist))
										begin //_if
										small_dist=distance_from_start[a];
										min_i = a;
										end   //_if
							end   //@@
							row = min_i;
							for (c=0; c<13; c=c+1)
							begin//XX
							column =c;
							graph();
							tag=g;
								if((tag)!=0 && (visited[c]==0) &&(small_dist+tag<distance_from_start[c]) )
									begin //*-*
										tag =small_dist+tag;
										distance_from_start[c] = tag;
										previous_node[c] = min_i;
									end	//*-*
							end//XX
							
					end   //++
			end   //00
			visited[min_i] = 1;
	end   //*** end
	assign A = distance_from_start[0];
	assign B = distance_from_start[1];
	assign C = distance_from_start[2];
	assign D = distance_from_start[3];
	assign E = distance_from_start[4];
	assign F = distance_from_start[5];
	assign G = distance_from_start[6];
	assign H = distance_from_start[7];
	assign I = distance_from_start[8];
	assign J = distance_from_start[9];
	assign K = distance_from_start[10];
	assign L = distance_from_start[11];
	assign M = distance_from_start[12];
	
	assign l_1 = r_l_1;
	assign l_2 = r_l_2;
	assign l_3 = r_l_3;
	assign l_4 = r_l_4;
	
endmodule
