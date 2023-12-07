/********************************************************************************************
Copyright 2019 - Maven Silicon Softech Pvt Ltd. 
 
All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.

It is not to be shared with or used by any third parties who have not enrolled for our paid training 

courses or received any written authorization from Maven Silicon.


Webpage     :      www.maven-silicon.com

Filename    :	   mux4_1.v   

Description :      4:1 Mux

Author Name :      Susmita Nayak

Version     :      1.0
*********************************************************************************************/
module mux4_1(a_in,
	      sel_in,
	      y_out);
									
   //Ports declaration
   input [3:0] a_in;
   input [1:0] sel_in;
   output y_out;
			
   //Internal wires
   wire w1,w2;
			
   //Instances of 2:Muxes
   mux2_1 M1(.a(a_in[2]),.b(a_in[3]),.sel(sel_in[0]),.y(w1));
   mux2_1 M2(.a(a_in[0]),.b(a_in[1]),.sel(sel_in[0]),.y(w2));
   mux2_1 M3(.a(w2),.b(w1),.sel(sel_in[1]),.y(y_out));

endmodule
  
