/********************************************************************************************
Copyright 2019 - Maven Silicon Softech Pvt Ltd. 
 
All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.

It is not to be shared with or used by any third parties who have not enrolled for our paid training 

courses or received any written authorization from Maven Silicon.


Webpage     :      www.maven-silicon.com

Filename    :	   dff.v   

Description :      Delay Flip-flop

Author Name :      Susmita Nayak

Version     :      1.0
*********************************************************************************************/
module dff (input din_0,din_1,sel_in,rst,clk,
	    output reg q_out);
							
   //Internal reg variable
   reg d;
		
   //Logic for selecting the data signal
   always @(*)
      begin
         case(sel_in)
	    0      : d = din_0;
	    1      : d = din_1;
	    default: d = 1'b0;
	 endcase
      end

   //Logic for delaying the data by 1 cycle
   always @(posedge clk)
      begin
         if(rst)       
	    q_out <= 1'b0;    
	 else
	    q_out <= d;         
      end 

endmodule
	

            
             
