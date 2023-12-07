/********************************************************************************************
Copyright 2019 - Maven Silicon Softech Pvt Ltd. 
 
All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.

It is not to be shared with or used by any third parties who have not enrolled for our paid training 

courses or received any written authorization from Maven Silicon.


Webpage     :      www.maven-silicon.com

Filename    :	   mux2_1.v   

Description :      2:1 Mux

Author Name :      Susmita Nayak

Version     :      1.0
*********************************************************************************************/

module mux2_1(input a,b,sel,
	      output y);
	 
   assign y = (~sel&a)|(sel&b);

endmodule 
	
	
	
	
