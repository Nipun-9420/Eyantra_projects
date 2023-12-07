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
output [13:0]M
);

reg [3:0] graph[0:13][0:13];
	
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
	reg [13:0] small_dist = 99;
	reg [13:0] array_l = 13; // Array Length
	reg [13:0] min_i ; // Array Length
	reg [13:0] lis ; // for path
	reg [13:0] ref ; // for path
	reg [13:0] i_i;
	reg [13:0] S_Start = 0;
	reg [13:0] m_i;  // minimum index
	reg [13:0] check;
	reg [13:0] a;
	reg [13:0] c;
	reg [13:0] tag;
	//******************************------------------MY CODE ENDES
	//...........................................................................graph function start
	initial // to go straight speed should be as low as possible
		begin
			for(i = 0;i < 13;i=i+1)
			begin
				for(j = 0;j < 13;j =j+1)
				begin
					if((i==2 && j==3)|| (i==3 && j==2)||(i==4 && j==5)||(i==5 && j==4)||(i==6 && j==9)||(i==7 && j==11)||(i==9 && j==10)||(i==10 && j==9) ||(i==9 && j==6)||(i==11 && j==7)||(i==11 && j==12)||(i==12 && j==11))
					begin
						graph[i][j]=1;
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
						graph[i][j]=0;
					end
				end
			end
		end
	
	//...........................................................................graph function end
	
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
					//go_straight();
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
						for (c=0; c<13; c=c+1)
							begin//XX
								if((graph[min_i][c])!=0 && (visited[c]==0) &&(small_dist+graph[min_i][c]<distance_from_start[c]) )
									begin //*-*
										tag =small_dist+graph[min_i][c];
										distance_from_start[c] = tag;
										previous_node[c] = min_i;
									end	//*-*
							end//XX
					end   //++
			visited[min_i] = 1;
			end   //00

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
	assign M = graph[1][12];
endmodule
