module for_loop(
input clk,
output [7:0]d
);

reg [3:0] graph[0:36][0:36];

initial
	begin
		
		for(i = 0;i < 37;i=i+7'd1)
		begin
			for(j = 0;j < 37;j =j+7'd1)
			begin
				if((i==0 && j==1)|| (i==1 && j==0)||(i==4 && j==5)||(i==5 && j==4)||(i==7 && j==7)||(i==7 && j==7)||(i==9 && j==10)||(i==10 && j==11)||(i==11 && j==10)||(i==11 && j==18)||(i==12 && j==13)||(i==12 && j==13)||(i==12 && j==14)||(i==13 && j==12)||(i==14 && j==12)||(i==15 && j==17)||(i==15 && j==17)||(i==17 && j==15)||(i==17 && j==15)||(i==18 && j==11)||(i==18 && j==19)||(i==18 && j==21)||(i==19 && j==18)||(i==20 && j==21)||(i==21 && j==18)||(i==21 && j==20)||(i==21 && j==22)||(i==21 && j==28)||(i==22 && j==21)||(i==23 && j==24)||(i==24 && j==23)||(i==25 && j==27)||(i==27 && j==25)||(i==27 && j==28)||(i==28 && j==21)||(i==28 && j==27)||(i==28 && j==29)||(i==28 && j==31)||(i==29 && j==28)||(i==30 && j==31)||(i==31 && j==28)||(i==31 && j==30)||(i==31 && j==32)||(i==31 && j==33)||(i==32 && j==31)||(i==33 && j==31)||(i==35 && j==37)||(i==37 && j==35))
				begin
					graph[i][j]=3'b0001;
				end
				else if((i==0 && j==2)||(i==2 && j==4)||(i==3 && j==7)||(i==4 && j==2)||(i==4 && j==11)||(i==7 && j==3)||(i==8 && j==10)||(i==10 && j==8)||(i==11 && j==4)||(i==12 && j==23)||(i==14 && j==15)||(i==15 && j==14)||(i==17 && j==27)||(i==23 && j==12)||(i==27 && j==17)||(i==34 && j==35)||(i==35 && j==34))
				begin
					graph[i][j]=3'b0010;
				end
				else if((i==0 && j==8)||(i==2 && j==3)||(i==3 && j==2)||(i==7 && j==14)||(i==8 && j==0)||(i==11 && j==12)||(i==12 && j==11)||(i==14 && j==7)||(i==23 && j==34)||(i==33 && j==34)||(i==34 && j==23)||(i==34 && j==33))
				begin
					graph[i][j]=3'b0011;
				end
				else if((i==3 && j==17)||(i==8 && j==33)||(i==17 && j==3)||(i==27 && j==35)||(i==33 && j==8)||(i==35 && j==27))
				begin
					graph[i][j]=3'b0100;
				end
				else
				begin
					graph[i][j]=3'b0000;
				end
			end
		end
		array = 4'b0000;
		array1 = 4'b0000;
	end

	
	
	//parameter n = 37;
	//parameter s = 33;
	//parameter e = 3;
	reg [7:0] cost[0:37][0:37];
	reg [7:0] distance [37:0];
	reg [7:0] pred [37:0];
	reg [7:0] visited[37:0];
	reg [7:0] count;
	reg [7:0] i;
	reg [7:0] j;
	reg [7:0] nextnode;
	reg [7:0] k;
	reg [7:0] n = 7'd37;
	reg [7:0] s = 7'd33;
	reg [7:0] e = 7'd3;
	
	reg [7:0] min;
	reg [7:0] r_d;
	reg [7:0] c;
	
	reg [7:0] path[37:0];
	reg [7:0] e_path[37:0];
	reg [7:0] f_path[37:0];
	
	parameter step_1=4'b0000,
				 step_2=4'b0001,
				 step_3=4'b0010,
				 step_4=4'b0011,
				 step_5=4'b0100,
				 step_6=4'b0101,
				 step_7=4'b0110,
				 step_8=4'b0111,
				 step_9=4'b1000,
				 step_10=4'b1001;
				 
	reg [3:0]array;
	reg [3:0]array1;
	
	always @(posedge clk)
	begin
		case(array)
		step_1:
		begin
		for(i=0;i<37;i = i+7'd1)
		begin
			for(j=0;j<37;j= j+7'd1)
			begin
				if(graph[i][j]==0)
				begin
					cost[i][j]=100;
				end
				else
				begin
					cost[i][j]=graph[i][j];
				end
			end
		end
		array = 4'b0001;
		end
		
		
		step_2:
		begin
		for(i = 0 ;i < 37; i = i+7'd1)
		begin
			distance[i] = cost[s][i];
			pred[i] = s;
			visited[i] = 0;
			path[i]=37;
		   e_path[i]=37;
			f_path[i]=37;
		end
		array = 4'b0010;
		end
		
		step_3:
		begin
		distance[s] = 0;
		visited[s] = 1;
		count = 1;
		array = 4'b0011;
	   end
		//while(count < n-1)
		
		step_4:
		begin
		for(j=0; j<37; j=j+7'd1)
		begin
		if(count < n-1)
		begin
			case(array1)
			step_1:
			begin
				min = 100;
				array1 = 4'b0001;
			end
			
			step_2:
			begin
			//nextnode gives the node at minimum distance
			for(i=0;i<37;i = i+7'd1)
			begin
				if(distance[i] < min && !visited[i])
				begin
					min=distance[i];
					nextnode=i;
				end
			end
			array1 = 4'b0010;
			end
			
			step_3:
			begin
			//check if a better path exists through nextnode
			visited[nextnode] = 1;
			array1 = 4'b0011;
			end
			
			step_4:
			begin
			for(i=0;i< 37 ;i = i+ 7'd1)
			begin
			if(visited[i] == 0)
			begin
			if(min + cost[nextnode][i] < distance[i])
			begin
				distance[i] = min + cost[nextnode][i];
				pred[i] = nextnode;
			end
			end
			end
			array1 = 4'b0100;
			end
			
			step_5:
			begin
			count = count + 7'd1;
			array1 = 4'b0000;
			end
			endcase
		end

		else
		begin
			c=c+7'd1;
		end
	   end
		array = 4'b0100;
		end
		
		step_5:
		begin
		i=7'd0;
		array = 4'b0101;
		end
		
		step_6:
		begin
		//while (e != s)
		for(j=0;j<37;j=j+7'd1)
		begin
		if(e != s)
		begin
			path[i] = e;
			e = pred[e];
			i=i+7'd1;
		end
		else
		begin
			c=c+7'd1;
		end
		end
		array = 4'b0110;
		end
		
		
		step_7:
		begin
		j = 7'd0;
		array = 4'b0111;
		end
		
		
		step_8:
		begin
		for(i=37 ; i>0; i=i-7'd1)
		begin
			if(path[i]<e_path[j])
			begin
				e_path[j]=path[i];
				j=j+7'd1;
			end
		end
		array = 4'b1000;
		end
		
		
		step_9:
		begin
		e_path[37] = path[0];
		j=0;
		array = 4'b1001;
		end
		
		step_10:
		begin
		for(i=0;i<37;i=i+7'd1)
		begin
		 if(e_path[i] < f_path[i])
		 begin
			f_path[j]=e_path[i];
			j= j+1;
		 end
		end
		r_d= visited[3];
		end
	endcase
		

	end
	
	assign d = r_d;
	
endmodule
