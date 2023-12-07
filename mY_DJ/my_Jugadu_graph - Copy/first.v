module for_loop(
input clk,
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
output [13:0]N,
output [13:0]O,
output [13:0]P,
output [13:0]Q,
output [13:0]R,
output [13:0]S,
output [13:0]T,
output [13:0]U,
output [13:0]V,
output [13:0]W,
output [13:0]X,
output [13:0]Y,
output [13:0]Z,
output [13:0]AA,
output [13:0]AB,
output [13:0]AC,
output [13:0]AD,
output [13:0]AE,
output [13:0]AF,
output [13:0]AG,
output [13:0]AH,
output [13:0]AI,
output [13:0]AJ,
output [13:0]AK
);

reg [3:0] graph[0:36][0:36];

	
	//****-----------------MY CODE start
	/*
	To DO
	1. make all distance from starting ==inf
	
	*/
	reg [13:0] distance_from_start[0:37]; 		
	reg [13:0] visited[0:37];
	reg [13:0] previous_node[0:37];
	reg [13:0] path[0:37];
	reg [13:0] path_final[0:37];
	
	reg [13:0] start_node = 33;
	reg [13:0] end_node = 36;
	reg [13:0] small_dist = 99;
	reg [13:0] array_l = 37; // Array Length
	reg [13:0] min_i ; // Array Length
	reg [13:0] lis=0 ; // for path
	reg [13:0] ref ; // for path
	reg [13:0] i_i;
	reg [13:0] S_Start = 0;
	reg [13:0] m_i;  // minimum index
	reg [13:0] check;
	reg [13:0] a;
	reg [13:0] h=0;
	reg [13:0] l=0;
	reg [13:0] c;
	reg [4:0] d_1 =1;
	reg [13:0] tag;
	reg [30:0] count ;
	reg [13:0] fun ;
	reg [13:0] f=36;
	reg [13:0] fin;
	
	reg [13:0] res =0;
	//reg [13:0] lis =0;
	
	//--*
	reg [6:0] work_to_do ;
	parameter check_l            = 7'b0000001;
	parameter current_loop_check = 7'b0000010;
	parameter two_loop_check     = 7'b0000011;
	parameter make_path_1        = 7'b0000100;
	parameter make_path_2        = 7'b0000101;
	parameter make_path_invers1   = 7'b0000110;
	parameter make_path_invers2   = 7'b0001000;
	parameter make_Stop          = 7'b0000111;
	//--*-
	
	
	
	//****------------------MY CODE ENDES
	always @(posedge clk)
	begin // * start
	//--------------------- Array value decleration
			if (S_Start==0)
			begin
					for(i_i=0;i_i<37;i_i=i_i+1)
					begin
						distance_from_start[i_i]=99;
						distance_from_start[start_node]=0;
						path[i_i]=37;
						path_final[i_i]=37;
						previous_node[i_i]=0;
						visited[i_i]=0;
						work_to_do = check_l;
						small_dist=99;
						
					end
			end
				S_Start=1;
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
										previous_node[c] = min_i;
									
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
							end_node = previous_node[end_node];
							h=h+1;
						end
						work_to_do = make_path_2;
				end //make_patj_1
				
				make_path_2:
				begin//--------two_loop_check
				      
						if(res==37)
							begin
								fun =6;
						      work_to_do = make_path_invers1;
							end
						 else 
							begin
								fun =12;
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
				     if(f< 0)
							begin
								fun =6;
						      work_to_do = make_Stop;
							end
						 else 
							begin
								fun =12;
								f = f-1;
								work_to_do = make_path_invers1;
							end
				end//----------two_loop_check
					
			make_Stop:
			begin
				fun=13;
			end
		 endcase
		 
		 
	
	end   //* end
	
	/*
	assign p[258:252] =  path_final[0];
	assign p[251:245] =  path_final[1];
	assign p[244:238] =  path_final[2];
	assign p[237:231] =  path_final[3];
	assign p[230:224]=   path_final[4];
	assign p[223:217] =  path_final[5];
	assign p[216:210] =  path_final[6];
	*/
	assign A =  path_final[0];
	assign B =  path_final[1];
	assign C =  path_final[2];
	assign D =  path_final[3];
	assign E =  path_final[4];
	assign F =  path_final[5];
	assign G =  path_final[6];
	assign H =  path_final[7];
	assign I =  path_final[8];
	assign J =  path_final[9];
	assign K =  path_final[10];
	assign L =  path_final[11];
	assign M =  path_final[12];
	assign N =  path_final[13];
	assign O =  path_final[14];
	assign P =  path_final[15];
	assign Q =  path_final[16];
	assign R =  path_final[17];
	assign S =  path_final[18];
	assign T =  path_final[19];
	assign U =  path_final[20];
	assign V =  path_final[21];
	assign W =  path_final[22];
	assign X =  path_final[23];
	assign Y =  path_final[24];
	assign Z =  path_final[25];
	assign AA = path_final[26];
	assign AB = path_final[27];
	assign AC = path_final[28];
	assign AD = path_final[29];
	assign AE = path_final[30];
	assign AF = path_final[31];
	assign AG = path_final[22];
	assign AH = path_final[33];
	assign AI = path_final[34];
	assign AJ = path_final[35];
	assign AK = path_final[36];
	
	
	
endmodule

