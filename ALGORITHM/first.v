module for_loop(
input clk,
output [7:0]d,
output [9:0]A,
output [9:0]B,
output [9:0]C,
output [9:0]D,
output [9:0]E,
output [9:0]F,
output [9:0]G,
output [9:0]H,
output [9:0]I,
output [9:0]J,
output [9:0]K,
output [9:0]L,
output [9:0]M
);

reg [3:0] graph[0:13][0:13];
initial
	begin
		
		for(i = 0;i < 13;i=i+7'd1)
		begin
			for(j = 0;j < 13;j =j+7'd1)
			begin
				if((i==2 && j==3)|| (i==3 && j==2)||(i==4 && j==5)||(i==5 && j==4)||(i==6 && j==9)||(i==7 && j==11)||(i==9 && j==10)||(i==10 && j==9) ||(i==9 && j==6)||(i==11 && j==7)||(i==11 && j==12)||(i==12 && j==11))
				begin
					graph[i][j]=3'b0001;
				end
				else if((i==0 && j==2)||(i==1 && j==4)||(i==2 && j==0)||(i==2 && j==8)||(i==4 && j==1)||(i==8 && j==2)||(i==10 && j==11)||(i==11 && j==10))
				begin
					graph[i][j]=3'b0010;
				end
				else if((i==0 && j==1)||(i==1 && j==0)||(i==4 && j==10)||(i==8 && j==9)||(i==9 && j==8)||(i==10 && j==4))
				begin
					graph[i][j]=3'b0011;
				end
				else if((i==1 && j==12)||(i==12 && j==1))
				begin
					graph[i][j]=3'b0100;
				end
				else
				begin
					graph[i][j]=3'b0000;
				end
			end
		end
		//array = 4'b0000;  // -----------------referance
 		//array1 = 4'b0000;  //-----------------refereace 
	end

	
	
	//parameter n = 37;
	//parameter s = 33;
	//parameter e = 3;
	
	//******************************-----------------MY CODE start
	/*
	To DO
	1. make all distance from starting ==inf
	
	*/
	reg [7:0] i;
	reg [7:0] j;
	reg [7:0] distance_from_start[13:0]; 
	reg [7:0] visited[13:0];
	reg [7:0] previous_node[13:0];
	reg [7:0] path[13:0];
	reg [7:0] path_final[13:0];
	
	reg [7:0] start_node = 10;
	reg [7:0] end_node = 2;
	reg [7:0] small_dist = 99;
	reg [7:0] array_l = 13; // Array Length
	reg [7:0] min_i = 0; // Array Length
	reg [7:0] lis = 0; // for path
	//reg [7:0] ref = 0; // for path
	reg [7:0] i_i;
	reg [7:0] S_Start = 0;
	reg [7:0] m_i;  // minimum index
	reg [7:0] check;
	reg [7:0] a;
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
		//---------------------------DJ start
		for(m_i=0;m_i<array_l;m_i=m_i+1)
			begin //  ##############
				for(check=0 ; check<array_l ; check=check+1)
					begin  // -*-*-*-*-*-*-*-*-*-*-*--**-*-*
					small_dist = 99;
					for(a=0 ; a<array_l ; a=a+1)
						begin // $
							if((visited[a] == 0) && ( distance_from_start[a]<small_dist))
								begin// if
									small_dist=distance_from_start[a];
									min_i = a;
								end // if
						end   // $
					end   // -*-*-*-*-*-*-*-*-*-*-*--**-*-*
			
			end   //  ##############
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
	
endmodule
