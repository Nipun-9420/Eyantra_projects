/********************************************************************************************
Copyright 2019 - Maven Silicon Softech Pvt Ltd. 
 
All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.

It is not to be shared with or used by any third parties who have not enrolled for our paid training 

courses or received any written authorization from Maven Silicon.


Webpage:  www.maven-silicon.com

Filename:	 tb_userinterface.v   

Description:     This module provides Interface to the user for 
                 checking the functionality of Three Way Round  
                 Robin Arbiter Using commands

----------------------------------------------------------------------
  COMMAND                         DESCRIPTION
----------------------------------------------------------------------

  NOREQ                        checks idle state

  REQFA                        checks arbiter when
                               request from processor A only
                               Idle to Grant A
                              
  REQFB                        checks arbiter when
                               request from processor B only
                               Idle to Grant B
                             
  REQFC                        checks arbiter when
                               request from processor C only
                               Idle to Grant C
                             
  ATCAB                        checks access time control when
                               request from processors A and B
                                 
  ATCBC                        checks access time control when
                               request from processors B and C
                             
  ATCCA                        checks access time control when
                               request from processors C and A
          
  SACC                         checks access time setting
-------------------------------------------------------------------


Author Name:      Susmita Nayak

Version: 1.0
*********************************************************************************************/


	module tb_userinterface;

		//Signal Declaration
		reg bfm_clk;
		reg [3:0] bfm_command;

		wire bfm_grant;
		
		//BFM commands Declaration
		parameter NOREQ    = 4'B0001,
							REQFA    = 4'B0010,
							REQFB    = 4'B0011,
							REQFC    = 4'B0100,                 
							ATCAB    = 4'B0101,
							ATCBC    = 4'B0110,
							ATCCA    = 4'B0111,
							SACC     = 4'B1000;
							
		parameter CYCLE = 50;
		
		//BFM Instantiation
		bfm_arbiter BFM1 (bfm_clk,
											bfm_command,
											bfm_grant);
											
		//Clock Generation
		always 
			begin
				#(CYCLE/2);
				bfm_clk = 1'b0;
				#(CYCLE/2);
				bfm_clk = 1'b1;
			end
			
		//Applying Commands
		initial
			begin
				BFM1.syn_reset;
				
				bfm_command = NOREQ;
				@(posedge bfm_grant);
				
				bfm_command = REQFA;
				@(posedge bfm_grant);
				
				bfm_command = REQFB;
				@(posedge bfm_grant);
				
				bfm_command = REQFC;
				@(posedge bfm_grant);
				
				bfm_command = SACC;
				@(posedge bfm_grant);
				
				bfm_command = ATCAB;
				@(posedge bfm_grant);
				
				bfm_command = ATCBC;
				@(posedge bfm_grant);

				bfm_command = ATCCA;
				@(posedge bfm_grant);
				
				$display("\n ****** Simulation Complete ********** \n");
				$stop;
			end
		
	endmodule
	 
