/********************************************************************************************
Copyright 2019 - Maven Silicon Softech Pvt Ltd. 
 
All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.

It is not to be shared with or used by any third parties who have not enrolled for our paid training 

courses or received any written authorization from Maven Silicon.


Webpage     :      www.maven-silicon.com

Filename    :	   mux4_1_tb.v   

Description :      4:1 Mux Testbench

Author Name :      Susmita Nayak

Version     :      1.0
*********************************************************************************************/
module mux4_1_tb();
			
   //Global variables declared for driving the DUT
   reg [3:0] a;
   reg [1:0] sel;
   wire y;
			
   //Internal variables used for iteration purpose 
   integer i,j;
			
   //Step1 : Instantiate the Design using instantion by name method
	           
			
   /*Step2 : Write initial block for stimulus generation
             Initialise inputs
             Use nested 'for' loops for generating stimulus for "a" & "sel" 
             respectively at an interval of 10ns */
				
   //Step3 : Use $finish task to terminate the simulation at 1000ns
			
   //Process to monitor the changes in the outputs
   initial 
      $monitor("Input a=%b,sel=%b,Output y=%b",a,sel,y);


endmodule

