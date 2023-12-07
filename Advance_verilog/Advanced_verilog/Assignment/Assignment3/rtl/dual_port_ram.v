/********************************************************************************************
Copyright 2019 - Maven Silicon Softech Pvt Ltd. 

All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.

It is not to be shared with or used by any third parties who have not enrolled for our paid training 

courses or received any written authorization from Maven Silicon.


Webpage     :      www.maven-silicon.com

Filename    :	   dual_port_ram.v   

Description :      16x8 dual-port ram

Author Name :      Susmita Nayak

Version     :      1.0
*********************************************************************************************/


module dual_port_ram #(parameter WIDTH=8,DEPTH=16,ADDR=5)
                      (input clock,resetn,
                       input [WIDTH-1:0]data_in,
                       input we_enb,re_enb,
                       input [ADDR-1:0]rd_addr,wr_addr,
                       output reg [WIDTH-1:0]data_out);

   //Internal memory declaration 
   reg [WIDTH-1:0]ram[DEPTH-1:0] ;

   //Memory read & write operation
   always@(posedge clock)
      begin
         if(~resetn)
            data_out <= 1;
         else if(we_enb)
            ram[wr_addr[3:0]] <= data_in;
         else if(re_enb)
            data_out <= ram[rd_addr[3:0]];
      end

endmodule 
