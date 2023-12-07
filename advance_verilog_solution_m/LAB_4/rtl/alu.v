/********************************************************************************************
Copyright 2019 - Maven Silicon Softech Pvt Ltd. 
 
All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.

It is not to be shared with or used by any third parties who have not enrolled for our paid training 

courses or received any written authorization from Maven Silicon.


Webpage     :      www.maven-silicon.com

Filename    :	   alu.v   

Description :      Function table of Arithmetic Logic Unit (ALU)
	 ____________________________________________________________________________________
	 
	 S4 S3 S2 S1 S0 Cin  Operation           Function               Implementation Block
	 ____________________________________________________________________________________
	 0  0  0  0  0   0   Y <= A              Transfer A             Arithmetic Unit
	 0  0  0  0  0   1   Y <= A+1            Increment A            Arithmetic Unit
	 0  0  0  0  1   0   Y <= A+B            Addition               Arithmetic Unit
	 0  0  0  0  1   1   Y <= A+B+1          Add with carry         Arithmetic Unit
	 0  0  0  1  0   0   Y <= A+Bbar         A plus 1's complement
	                                         of B                   Arithmetic Unit
	 0  0  0  1  0   1   Y <= A+Bbar+1       Subtraction            Arithmetic Unit                                         
	 0  0  0  1  1   0   Y <= A-1            Decrement A            Arithmetic Unit
	 0  0  0  1  1   1   Y <= A              Transfer A             Arithmetic Unit
	 
	 0  0  1  0  0   0   Y <= A and B        AND                    Logic Unit
	 0  0  1  0  1   0   Y <= A or B         OR                     Logic Unit
	 0  0  1  1  0   0   Y <= A xor B        XOR                    Logic Unit
	 0  0  1  1  1   0   Y <= A bar          complement A           Logic Unit
	 
	 0  0  0  0  0   0   Y <= A              Transfer A             Shifter Unit
	 0  1  0  0  0   0   Y <= shl A          shift left A           Shifter Unit        
	 1  0  0  0  0   0   Y <= shr A          shift right A          Shifter Unit 
	 1  1  0  0  0   0   Y <= 0              Transfer 0's           Shifter Unit
	 ____________________________________________________________________________________



Author Name :      Susmita Nayak

Version     :      1.0
*********************************************************************************************/
 

module alu (alu_sel_in,alu_carry_in,alu_a_in,alu_b_in,alu_y_out);

   //Port declarations
   input  [4:0] alu_sel_in;
   input  alu_carry_in;
   input  [7:0] alu_a_in,alu_b_in;
   output [7:0] alu_y_out;

   //Internal variable declaration
   reg [7:0] alu_y_out;
   reg [7:0] logic_unit,arith_unit,alu_noshift;

   always@(*)
      begin

         //Logic Unit
         case(alu_sel_in[1:0])
	    2'b00   : logic_unit = alu_a_in & alu_b_in; 
	    2'b01   : logic_unit = alu_a_in | alu_b_in;
	    2'b10   : logic_unit = alu_a_in ^ alu_b_in;
	    2'b11   : logic_unit = ~alu_a_in;
	    default : logic_unit = 8'bx;
	 endcase

	//Arithmetic Unit
	case ({alu_sel_in[1:0],alu_carry_in})
	    3'b000   : arith_unit = alu_a_in;
	    3'b001   : arith_unit = alu_a_in + 1;
	    3'b010   : arith_unit = alu_a_in + alu_b_in;
	    3'b011   : arith_unit = alu_a_in + alu_b_in + 1;                                                
	    3'b100   : arith_unit = alu_a_in + (~alu_b_in);
	    3'b101   : arith_unit = alu_a_in - alu_b_in;
	    3'b110   : arith_unit = alu_a_in - 1;
	    3'b111   : arith_unit = alu_a_in;                                 
	    default  : arith_unit = 8'bx;
	 endcase

 	 //Multiplex between Logic & Arithmetic Units
	 if(alu_sel_in[2])
	    alu_noshift = logic_unit;
	 else
	    alu_noshift = arith_unit;

	 //Shift Operations
	 case (alu_sel_in[4:3])
	    2'b00   : alu_y_out = alu_noshift;
	    2'b01   : alu_y_out = alu_noshift << 1;
	    2'b10   : alu_y_out = alu_noshift >> 1;
	    2'b11   : alu_y_out = 8'b0;
	    default : alu_y_out = 8'bx;
      endcase
   end

endmodule                             








