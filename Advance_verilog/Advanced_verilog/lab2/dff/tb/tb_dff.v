/********************************************************************************************
Copyright 2019 - Maven Silicon Softech Pvt Ltd. 
 
All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.

It is not to be shared with or used by any third parties who have not enrolled for our paid training 

courses or received any written authorization from Maven Silicon.


Webpage     :      www.maven-silicon.com

Filename    :	   tb_dff.v   

Description :      DFF Testbench

Author Name :      Susmita Nayak

Version     :      1.0
*********************************************************************************************/
module tb_dff;

   //Global variables declared for driving the DUT
   reg d0,d1,sel,rst,clk;
   wire q;
		
   //Define setup and hold time
   //Define clock time-period
   parameter Thold  = 5,
	     Tsetup = 5,
	     CYCLE  = 100;

   //Step1 : Instantiate the dff design by order based

   //Step2 : Write clock generation logic with period of 100ns

   /*Step3 : Define the following tasks with self-checking features
             'sync_reset' for resetting the dff
             'load_d0' and 'load_d1' for loading input values */


   //Process to generate stimulus by calling the tasks & passing values
   initial
      begin         
	 sync_reset;
	 load_d0(1'b1);
	 sync_reset;
	 load_d1(1'b1);
	 load_d0(1'b0);
	 load_d1(1'b0);
	 sync_reset;   
	 #100 $finish;
      end       
			
		
			
endmodule
