/********************************************************************************************
Copyright 2019 - Maven Silicon Softech Pvt Ltd. 
 
All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.

It is not to be shared with or used by any third parties who have not enrolled for our paid training 

courses or received any written authorization from Maven Silicon.


Webpage:  www.maven-silicon.com

Filename:	bfm_arbiter.v   

Description:    This module checks the functionality of
                a Three - way Round-robin Arbiter through
                Bus Functional Model


Author Name:      Susmita Nayak

Version: 1.0
*********************************************************************************************/


	module bfm_arbiter(input bfm_clk,
										 input [3:0]bfm_command,
										 output reg bfm_grant);

		//Signal Declaration
		reg reset,
		en_timeout,
		reqa,
		reqb,
		reqc,
		r_wb_proca,
		r_wb_procb,
		r_wb_procc;

		reg [11:0]addbus_proca,
							addbus_procb,
							addbus_procc;

		reg [7:0]datawritebus_proca,
						 datawritebus_procb,
						 datawritebus_procc;

		wire acka,
				 ackb,
				 ackc;

		wire r_wb_ram;
		wire clock;

		wire [11:0]addbus_ram;
		wire [7:0]datawritebus_ram;

		parameter THOLD = 1;


    //Requests from Processors
		parameter RA  = 3'b100,
							RB  = 3'b010,
							RC  = 3'b001,
							NR  = 3'b000,
							RAB = 3'b110,
							RBC = 3'b011,
							RCA = 3'b101;

		//BFM commands Declaration
		parameter NOREQ    = 4'B0001,
							REQFA    = 4'B0010,
							REQFB    = 4'B0011,
							REQFC    = 4'B0100,                 
							ATCAB    = 4'B0101,
							ATCBC    = 4'B0110,
							ATCCA    = 4'B0111,
							SACC     = 4'B1000,
							/* SOLUTION to get FSM coverage 100% */
							REQFBA   = 4'B1001,
              REQFCB   = 4'B1010;

		// DUT Instantiation - port order-based
		arbiter	DUT1(	clock,     // system clock             
									reset,     // system reset
									en_timeout,// enables access time setting
									reqa,      // request from processor A
									reqb,      // request from processor B
									reqc,      // request from processor C
									r_wb_proca,         // read/write_n from processor A
									r_wb_procb,         // read/write_n from processor B
									r_wb_procc,         // read/write_n from processor C
									addbus_proca,       // address from processor A
									addbus_procb,       // address from processor B
									addbus_procc,       // address from processor C
									datawritebus_proca, // Data from processor A
									datawritebus_procb, // Data from processor B
									datawritebus_procc, // Data from processor C
									acka,        //acknowledge to processor A
									ackb,        //acknowledge to processor B
									ackc,        //acknowledge to processor C
									r_wb_ram,    // read/write_n to memory
									addbus_ram,  // Address to memory
									datawritebus_ram //Data to memory
								); 

		assign clock = bfm_clk;

		//Checking reset
		task syn_reset;
			begin
				@(negedge clock);
				reset = 1'b1;
				{datawritebus_proca,
				datawritebus_procb,
				datawritebus_procc} = $random;

				{addbus_proca,
				addbus_procb,
				addbus_procc} = $random;

				{r_wb_proca,    
				r_wb_procb,
				r_wb_procc} = $random;

				@(posedge clock);
				#(THOLD);

				if(addbus_ram !== 12'bz || 
					datawritebus_ram !== 8'bz ||
					r_wb_ram !== 1'bz)
					begin
						$display("Reset is not working\n");
						$display("Error at time %t", $time);
						$stop; 
					end
				$display("Reset is working\n");
				reset = 1'b0;
				{datawritebus_proca,
				datawritebus_procb,
				datawritebus_procc} = 24'bx;
				
				{addbus_proca,
				addbus_procb,
				addbus_procc} = 36'bx;

				{r_wb_proca,    
				r_wb_procb,
				r_wb_procc} = 3'bx; 
			end
		endtask

		//Checking requests
		task request;
			input [2:0] data;
			begin
				@(negedge clock);
				{reqa,reqb,reqc} = data;

				{datawritebus_proca,
				 datawritebus_procb,
				 datawritebus_procc} = $urandom;

				{addbus_proca,
				 addbus_procb,
				 addbus_procc} = $urandom;

				{r_wb_proca,    
				 r_wb_procb,
				 r_wb_procc}  = $urandom;

				@(posedge clock);
				#(THOLD);

				case(data)
					NR : begin
								if(addbus_ram !== 12'bz ||
								datawritebus_ram !== 8'bz ||
								r_wb_ram !== 1'bz)
									begin                 
										$display("Arbiter is not working when NR\n");
										$display("Error at time %t", $time);
										$stop; 
									end
							  $display("Arbiter is working when NR\n");
							end

					RA : begin
								if(addbus_ram !== addbus_proca ||
								datawritebus_ram !== datawritebus_proca ||
								r_wb_ram !== r_wb_proca)
									begin                 
										$display("Arbiter is not working when RA\n");
										$display("Error at time %t", $time);
										$stop; 
									end
								$display("Arbiter is working when RA\n");
							end

					RB : begin
								if(addbus_ram !== addbus_procb ||
								datawritebus_ram !== datawritebus_procb ||
								r_wb_ram !== r_wb_procb)
									begin                 
										$display("Arbiter is not working when RB\n");
										$display("Error at time %t", $time);
										$stop; 
									end
								$display("Arbiter is working when RB\n");
							end   

					RC : begin
								if(addbus_ram !== addbus_procc ||
								datawritebus_ram !== datawritebus_procc ||
								r_wb_ram !== r_wb_procc)
									begin                 
										$display("Arbiter is not working when RC\n");
										$display("Error at time %t", $time);
										$stop; 
									end
								$display("Arbiter is working when RC\n");
							end     
				endcase   
				
				{datawritebus_proca,
				datawritebus_procb,
				datawritebus_procc} = 24'bx;

				{addbus_proca,
				addbus_procb,
				addbus_procc} = 36'bx;

				{r_wb_proca,    
				r_wb_procb,
				r_wb_procc} = 3'bx;   
			end
		endtask

		//Setting Access Time 
		task set_acc;
			input [7:0] data;
			begin
				@(negedge clock);
				en_timeout = 1'b1;
				datawritebus_proca = data; 
				@(posedge clock);
				#(THOLD);
				en_timeout = 1'b0;
				datawritebus_proca = 8'bx;
			end
		endtask

		//Access Time Checking between Processors
		task any2req;
			input [2:0] data;
			input [5:0] acc_time;
			begin
				@(negedge clock);
				{reqa,reqb,reqc} = data;

				{datawritebus_proca,
				datawritebus_procb,
				datawritebus_procc} = $urandom;

				{addbus_proca,
				addbus_procb,
				addbus_procc} = $urandom;

				{r_wb_proca,    
				r_wb_procb,
				r_wb_procc} = $urandom;   

				repeat(acc_time+1)
				@(posedge clock);
				#(THOLD);

				case(data)
					RAB  : begin                
									if(addbus_ram !== addbus_procb ||
									datawritebus_ram !== datawritebus_procb ||
									r_wb_ram !== r_wb_procb)
										begin                 
											$display("Arbiter is not working when RAB \n");
											$display("Error at time %t", $time);
											$stop; 
										end
									$display("Arbiter is working when RAB\n");
								end

					RBC  : begin                
									if(addbus_ram !== addbus_procc ||
									datawritebus_ram !== datawritebus_procc ||
									r_wb_ram !== r_wb_procc)
										begin                 
											$display("Arbiter is not working when RBC \n");
											$display("Error at time %t", $time);
											$stop; 
										end
									$display("Arbiter is working when RBC\n");
								end

					RCA  : begin                
									if(addbus_ram !== addbus_proca ||
									datawritebus_ram !== datawritebus_proca ||
									r_wb_ram !== r_wb_proca)
										begin                 
											$display("Arbiter is not working when RCA \n");
											$display("Error at time %t", $time);
											$stop; 
										end
									$display("Arbiter is working when RCA\n");
								end
				endcase
			end
		endtask

		//Sampling and executing Commands
		always @(posedge clock)
			begin
			case(bfm_command)
			NOREQ    : begin
									bfm_grant = 1'b0;
									request(NR);
									bfm_grant = 1'b1;
								 end

			REQFA    : begin
									bfm_grant = 1'b0;
									request(RA);
									request(NR);
									bfm_grant = 1'b1;
								end

			REQFB    : begin
									bfm_grant = 1'b0;
									request(RB);
									request(NR);
									bfm_grant = 1'b1;
								end                  

			REQFC    : begin
									bfm_grant = 1'b0;
									request(RC);
									request(NR);
									bfm_grant = 1'b1;
								end

			SACC     : begin
									bfm_grant = 1'b0;
									set_acc(8'd25);                    
									bfm_grant = 1'b1;
								end 
						 
			ATCAB    : begin
									bfm_grant = 1'b0;
									request(RA);
									any2req(RAB,6'd25);
									bfm_grant = 1'b1;
								end 

			ATCBC    : begin
									bfm_grant = 1'b0;                    
									any2req(RBC,6'd25);
									bfm_grant = 1'b1;
								end 

			ATCCA    : begin
									bfm_grant = 1'b0;                    
									any2req(RCA,6'd25);
									bfm_grant = 1'b1;
								end 
									/* SOLUTION to get FSM coverage 100% */
			REQFBA		: begin                                  
										bfm_grant = 1'b0;
										request(RB);
										request(RA);
										bfm_grant = 1'b1;
									end
			REQFCB		: begin                                 
										bfm_grant = 1'b0;
										request(RC);
										request(RB);
										bfm_grant = 1'b1;
								  end


			endcase
			end

	endmodule




  
  
    
    

    
  
     
              
          
















	    
