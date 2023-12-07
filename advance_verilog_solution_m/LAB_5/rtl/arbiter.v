/********************************************************************************************
Copyright 2019 - Maven Silicon Softech Pvt Ltd. 
 
All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.

It is not to be shared with or used by any third parties who have not enrolled for our paid training 

courses or received any written authorization from Maven Silicon.


Webpage     :      www.maven-silicon.com

Filename    :	   arbiter.v   

Description :      This module defines a 3 way round-robbin arbiter

Author Name :      Susmita Nayak

Version     :      1.0
*********************************************************************************************/

module arbiter(input clock,     // system clock             
                     reset,     // system reset
                     en_timeout,// enables access time setting
                     reqa,      // request from processor A
                     reqb,      // request from processor B
                     reqc,      // request from processor C
                     r_wb_proca,         // read/write_n from processor A
                     r_wb_procb,         // read/write_n from processor B
                     r_wb_procc,         // read/write_n from processor C
               input [11:0]addbus_proca,	// address from processor A
                           addbus_procb,       // address from processor B
                           addbus_procc,       // address from processor C
               input [7:0]datawritebus_proca, // Data from processor A
                          datawritebus_procb, // Data from processor B
                          datawritebus_procc, // Data from processor C
               output reg acka,        //acknowledge to processor A
                          ackb,        //acknowledge to processor B
                          ackc,        //acknowledge to processor C
               output r_wb_ram,    // read/write_n to memory
               output [11:0]addbus_ram,  // Address to memory
               output [7:0]datawritebus_ram //Data to memory
              ); 

   //Internal variables declaration
   reg [7:0]timeoutclockperiods; //Stores access time
   reg  runtimer; // logical high enables timer
   reg	 timesup;  // controls access time
   reg [7:0]count; //Timer logic
   reg [3:0]currentstate,nextstate;

   //Enable signals for data and address buses
   reg  ena1,ena2,enb1,enb2,enc1,enc2;

   //PARAMETERS
   parameter IDLE = 4'd0,
   GRANT_A = 4'd1,
   GRANT_B = 4'd2,
   GRANT_C = 4'd6;


   //Address Buses
   assign addbus_ram = ena1 ? addbus_proca : 12'b z;
   assign addbus_ram = enb1 ? addbus_procb : 12'b z;
   assign addbus_ram = enc1 ? addbus_procc : 12'b z;

   //Data Buses
   assign datawritebus_ram = ena2 ? datawritebus_proca : 8'b z;
   assign datawritebus_ram = enb2 ? datawritebus_procb : 8'b z;
   assign datawritebus_ram = enc2 ? datawritebus_procc : 8'b z; 

   //Read/Write control signals
   assign r_wb_ram = ena2 ? r_wb_proca : 1'bz;
   assign r_wb_ram = enb2 ? r_wb_procb : 1'bz;
   assign r_wb_ram = enc2 ? r_wb_procc : 1'bz;

   //Setting Access time        
   always @(posedge clock)
      begin
         if(reset == 1)
            begin
               timeoutclockperiods <= 64;
               count <= 0;
            end
         else if (en_timeout==1)
            timeoutclockperiods <= datawritebus_proca;
         else if(runtimer == 0)
            count <= 0;
         else
            count <= count + 1;
      end

   //Times_up Logic
   always @(count)	
      begin
         if(count == timeoutclockperiods)
            timesup = 1;
         else
            timesup = 0;	  
      end 

   //Arbiter - State Machine
   //Sequential Logic	
   always @(posedge clock or posedge reset)	  	      
      begin
         if(reset)
            currentstate <= IDLE;
         else
            currentstate <= nextstate;
         end     

   //Next state decoder Logic
   always @(reqa or reqb or reqc or timesup or currentstate)
      begin
         acka = 0;
         ackb = 0;
         ackc = 0;	
         runtimer = 0;
         case(currentstate)
            IDLE: if(reqa == 1)
                     begin
		        acka=1;
		        nextstate=GRANT_A;
	             end
		  else if(reqb == 1)   
		     begin
		        ackb = 1;
		        nextstate = GRANT_B;
		     end
		  else if(reqc == 1)
		     begin
		        ackc = 1;
		        nextstate = GRANT_C;
		     end 	

            GRANT_A: if(reqa==1 && timesup==0)//processor A allowed continued access
                        begin
			   runtimer = 1;
			   acka = 1;
			   nextstate = GRANT_A;
			end
		     else if(reqb==1) 
			nextstate = GRANT_B;
   		     else if(reqc==1)
			nextstate = GRANT_C;     
		     else
			nextstate = IDLE; 

            GRANT_B: if((reqb == 1)&&(timesup == 0))//processor B allowed continued access
			begin
			   runtimer = 1;
			   ackb = 1;
			   nextstate = GRANT_B;
			end
		     else if(reqc == 1)
			nextstate = GRANT_C;
		     else if(reqa == 1)
			nextstate = GRANT_A;     
		     else
			nextstate = IDLE; 	      


            GRANT_C: if(reqc == 1 && timesup == 0)//processor c allowed continued access				
                        begin
			   runtimer = 1;
			   ackc = 1;
			   nextstate = GRANT_C;
			end
		     else if(reqa == 1)
			nextstate = GRANT_A;
		     else if(reqb == 1)
			nextstate = GRANT_B;     
		     else
			nextstate = IDLE; 

            default: nextstate = IDLE;
         endcase
      end

   //Output Logic	
   always@(posedge clock or posedge reset)	  	      
      begin
         if(reset)	       
	    begin
	       ena1 = 0;ena2 = 0;
               enb1 = 0;enb2 = 0;
               enc1 = 0;enc2 = 0; 
            end
         else
            begin
	       ena1 = 0;ena2 = 0;
               enb1 = 0;enb2 = 0;
               enc1 = 0;enc2 = 0; 
               case(nextstate)
                  GRANT_A:
                            begin
		     	       ena1=1;ena2=1;
                            end
		  GRANT_B:
                            begin
                               enb1=1;enb2=1;
                            end
                  GRANT_C:
                            begin 
                               enc1=1;enc2=1;
                            end
                  default:
                            begin
			       ena1=0;ena2=0;
			       enb1=0;enb2=0;
			       enc1=0;enc2=0; 	
		            end

               endcase
            end
      end     	      	      
endmodule		  	       	        


