/********************************************************************************************
Copyright 2019 - Maven Silicon Softech Pvt Ltd. 

All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.

It is not to be shared with or used by any third parties who have not enrolled for our paid training 

courses or received any written authorization from Maven Silicon.


Webpage     :      www.maven-silicon.com

Filename    :	   coincol.v   

Description :      FSM for coin collector

Author Name :      Susmita Nayak

Version     :      1.0
*********************************************************************************************/

//Finite State Machine - Moore type
module coincol (clock,reset,coin_in,done_out,lsb7seg_out,msb7seg_out);

   //Ports declaration
   input clock,reset;
   input [1:0]coin_in;   
   output done_out;
   output reg [6:0]lsb7seg_out;
   output reg [6:0]msb7seg_out;

   //Coin denominations
   /************************
   coin=2'b00 => 25 paise
   coin=2'b01 => 50 paise
   coin=2'b10 => 1  Rupee
   coin=2'b11 => No Coin
   ************************/

   //Internal variables declaration
   reg [2:0]prestate,nextstate;


   //Binary encoded states 
   parameter STATE00  = 3'b000,
  	     STATE25  = 3'b001,
	     STATE50  = 3'b010,
	     STATE75  = 3'b011,
	     STATE100 = 3'b100;


   //Present state logic
   always @(posedge clock)
      begin
         if(reset)
	    prestate <= STATE00;
	 else
	    prestate <= nextstate;
      end

   //Next state decoder logic
   always @(*)
      begin
	case(prestate)
	   STATE00 : 
	 	       begin
	   	          if(coin_in == 2'b00)
	                     nextstate = STATE25;
	                  else if(coin_in == 2'b01)
	       		     nextstate = STATE50;
	   	          else if(coin_in == 2'b10)
	                     nextstate = STATE100;
	                  else
	                     nextstate = STATE00;
	               end
	   STATE25 :
	 	       begin
	    	          if(coin_in == 2'b00)
	       		     nextstate = STATE50;
	                  else if(coin_in == 2'b01)
 	                     nextstate = STATE75;
	                  else if(coin_in == 2'b10)
	                     nextstate = STATE100;
	                  else
	                     nextstate = STATE25;
	               end 
	   STATE50 :
	               begin
	   	          if(coin_in == 2'b00)
	       		     nextstate = STATE75;
	   	          else if(coin_in == 2'b01 || coin_in == 2'b10)                              
	      		     nextstate = STATE100;
	   	          else
	       		     nextstate = STATE50;
	               end
	   STATE75 :
	 	       begin
	                  if(coin_in == 2'b00 || coin_in == 2'b01 || coin_in == 2'b10)                              
	                     nextstate = STATE100;
	                  else
	                     nextstate = STATE75;
	               end 
	   default :   nextstate = STATE00;
      endcase
   end

   //Output logic
   assign done_out = (prestate == STATE100) ? 1'b1 : 1'b0;

   /************************************************

   SEVEN SEGMENT LED DISPLAY

       a
      ---    
   f |   | b
      ---  <-- g
   e |   | c
      ---
      d  

   Each LED segment is active low.
   Both lsb7seg and msb7seg are assigned
   in the order "gfedcba"

   ************************************************/

   always @(prestate)
      begin
         case(prestate)
            STATE25  : 
	                begin
	          	   lsb7seg_out = 7'b0100100;
	          	   msb7seg_out = 7'b0010100;
	                end
	    STATE50  : 
	       	        begin
	          	   lsb7seg_out = 7'b0100010;
	          	   msb7seg_out = 7'b1000000;
	                end
	    STATE75  : 
	       	        begin
	          	   lsb7seg_out = 7'b1111000;
	          	   msb7seg_out = 7'b0010010;
	       	       end
	    STATE100 : 
	       	        begin
	                   lsb7seg_out = 7'b0001001;
	                   msb7seg_out = 7'b0001000;
	                end
	    default  : 
	        	begin
	          	   lsb7seg_out = 7'b1000000;
	          	   msb7seg_out = 7'b1000000;
	       		end
	 endcase
      end           



endmodule





