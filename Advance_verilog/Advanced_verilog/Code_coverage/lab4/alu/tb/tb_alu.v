/********************************************************************************************
Copyright 2019 - Maven Silicon Softech Pvt Ltd. 
 
All Rights Reserved.

This source code is an unpublished work belongs to Maven Silicon Softech Pvt Ltd.

It is not to be shared with or used by any third parties who have not enrolled for our paid training 

courses or received any written authorization from Maven Silicon.


Webpage     :      www.maven-silicon.com

Filename    :	   tb_alu.v   

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

module tb_alu;

   //Global variables declaration for driving stimulus
   reg  [4:0]alu_sel_in;
   reg  alu_carry_in;
   reg  [7:0]alu_a_in,alu_b_in;
   wire [7:0]alu_y_out;

   //Variable declaration for loop iteration
   integer k;

   /* Array Declaration
   vmem1 for giving inputs A_IN & B_IN
   vmem2 for checking the output */
   reg [1:8]vmem1[1:2];
   reg [1:8]vmem2[1:16];

   parameter delay = 5;

   //ALU Instantiation
   alu alu1 (alu_sel_in,alu_carry_in,alu_a_in,alu_b_in,alu_y_out);

   //Task for checking Arithmetic Unit	 
   task arith;
   input [4:0] sel;
   input carry;
      begin
         alu_sel_in   = sel;
	 alu_carry_in = carry;
	 $readmemb ("data_in.vec",vmem1);
	 $readmemb ("data_exp.vec",vmem2);
	 alu_a_in = vmem1[1];
	 alu_b_in = vmem1[2];
	 #delay;
	 case({alu_sel_in[1:0],alu_carry_in})
	    3'b000 : 
                      begin
 	                 if(alu_y_out !== vmem2[1])
      		  	    begin
		     	       $fdisplay(k,"Error in Arithmetic Unit");
		     	       $fdisplay(k,"when sel=%b carry=%b",alu_sel_in,alu_carry_in);
		     	       $stop;
                            end
		         $fdisplay(k,"Arithmetic Unit is Perfect");
		         $fdisplay(k,"when sel=%b carry=%b \n",alu_sel_in,alu_carry_in);
                      end

 	    3'b001 : 
		      begin
	       		  if(alu_y_out !== vmem2[2])
	          	     begin
		     	        $fdisplay(k,"Error in Arithmetic Unit");
		     	        $fdisplay(k,"when sel=%b carry=%b",alu_sel_in,alu_carry_in);
		     	        $stop;
			     end
		          $fdisplay(k,"Arithmetic Unit is Perfect");
		          $fdisplay(k,"when sel=%b carry=%b \n",alu_sel_in,alu_carry_in);
	              end

	    3'b010 : 
		      begin
	                 if(alu_y_out !== vmem2[3])
	                    begin
		               $fdisplay(k,"Error in Arithmetic Unit");
		               $fdisplay(k,"when sel=%b carry=%b",alu_sel_in,alu_carry_in);
		               $stop;
	                    end
		         $fdisplay(k,"Arithmetic Unit is Perfect");
		         $fdisplay(k,"when sel=%b carry=%b \n",alu_sel_in,alu_carry_in);
	              end

	    3'b011 :
 	              begin
	                 if(alu_y_out !== vmem2[4])
	                    begin
		               $fdisplay(k,"Error in Arithmetic Unit");
		               $fdisplay(k,"when sel=%b carry=%b",alu_sel_in,alu_carry_in);
		               $stop;
		            end
		         $fdisplay(k,"Arithmetic Unit is Perfect");
		         $fdisplay(k,"when sel=%b carry=%b \n",alu_sel_in,alu_carry_in);
		      end 
																			 
	    3'b100 : 
		      begin
	 		 if(alu_y_out !== vmem2[5])
	    		    begin
	       		       $fdisplay(k,"Error in Arithmetic Unit");
	                       $fdisplay(k,"when sel=%b carry=%b",alu_sel_in,alu_carry_in);
	                       $stop;
	                    end
	                 $fdisplay(k,"Arithmetic Unit is Perfect");
	                 $fdisplay(k,"when sel=%b carry=%b \n",alu_sel_in,alu_carry_in);
	              end 

	    3'b101 :
		      begin
	     		 if(alu_y_out !== vmem2[6])
	       		    begin
	          	       $fdisplay(k,"Error in Arithmetic Unit");
	          	       $fdisplay(k,"when sel=%b carry=%b",alu_sel_in,alu_carry_in);
	          	       $stop;
	                    end
	          	 $fdisplay(k,"Arithmetic Unit is Perfect");
	          	 $fdisplay(k,"when sel=%b carry=%b \n",alu_sel_in,alu_carry_in);
	              end

	    3'b110 :
		      begin
	       		 if(alu_y_out !== vmem2[7])
	          	    begin
	             	       $fdisplay(k,"Error in Arithmetic Unit");
	                       $fdisplay(k,"when sel=%b carry=%b",alu_sel_in,alu_carry_in);
	                       $stop;
	                    end
	                 $fdisplay(k,"Arithmetic Unit is Perfect");
	                 $fdisplay(k,"when sel=%b carry=%b \n",alu_sel_in,alu_carry_in);
	              end

	    3'b111 :
		      begin
	                 if(alu_y_out !== vmem2[8])
		            begin
		               $fdisplay(k,"Error in Arithmetic Unit");
	                       $fdisplay(k,"when sel=%b carry=%b",alu_sel_in,alu_carry_in);
	                       $stop;
	                    end
		         $fdisplay(k,"Arithmetic Unit is Perfect");
		         $fdisplay(k,"when sel=%b carry=%b \n",alu_sel_in,alu_carry_in);
	              end 
	    default : $fdisplay(k,"This input is not permitted");
	endcase               
      end
   endtask

   //Task for checking Logic Unit
   task logic;
   input [4:0] sel;
      begin
	 alu_sel_in   = sel;
	 alu_carry_in = 1'b0;
	 $readmemb ("data_in.vec",vmem1);
	 $readmemb ("data_exp.vec",vmem2);
	 alu_a_in = vmem1[1];
	 alu_b_in = vmem1[2];
	 #delay;
	    case(alu_sel_in[1:0])
	       2'b00 :  
			begin
		  	   if(alu_y_out !== vmem2[9])
		     	      begin
				 $fdisplay(k,"Error in Logic Unit");
				 $fdisplay(k,"when sel=%b ",alu_sel_in);
				 $stop;
		     	      end
			   $fdisplay(k,"Logic Unit is Perfect");
			   $fdisplay(k,"when sel=%b  \n",alu_sel_in);
		        end
	       2'b01 : 
			begin
	          	   if(alu_y_out !== vmem2[10])
		     	      begin
				 $fdisplay(k,"Error in Logic Unit");
				 $fdisplay(k,"when sel=%b ",alu_sel_in);
				 $stop;
		    	      end
			   $fdisplay(k,"Logic Unit is Perfect");
			   $fdisplay(k,"when sel=%b  \n",alu_sel_in);
		        end
 	       2'b10 :
                        begin
		           if(alu_y_out !== vmem2[11])
		              begin
  				 $fdisplay(k,"Error in Logic Unit");
				 $fdisplay(k,"when sel=%b ",alu_sel_in);
				 $stop;
		     	      end
			   $fdisplay(k,"Logic Unit is Perfect");
			   $fdisplay(k,"when sel=%b  \n",alu_sel_in);
		        end
	       2'b11 :
                        begin
		           if(alu_y_out !== vmem2[12])
		              begin
				 $fdisplay(k,"Error in Logic Unit");
				 $fdisplay(k,"when sel=%b ",alu_sel_in);
				 $stop;
		              end
			   $fdisplay(k,"Logic Unit is Perfect");
			   $fdisplay(k,"when sel=%b  \n",alu_sel_in);
		        end
	       default: $fdisplay(k,"This Input is not Permitted");
	    endcase
         end 
   endtask

   //Task for checking Shift Unit
   task shift;
   input [4:0] sel;
      begin
	 alu_sel_in   = sel;
 	 alu_carry_in = 1'b0;
	 $readmemb ("data_in.vec",vmem1);
	 $readmemb ("data_exp.vec",vmem2);
	 alu_a_in = vmem1[1];
	 alu_b_in = vmem1[2];
 	 #delay;
	 case(alu_sel_in[4:3])
	    2'b00    : 
			begin
	                   if(alu_y_out !== vmem2[13])
		  	      begin
		     	         $fdisplay(k,"Error in Shift Unit");
		                 $fdisplay(k,"when sel=%b ",alu_sel_in);
		                 $stop;
	 	              end
		           $fdisplay(k,"Shift Unit is Perfect");
		           $fdisplay(k,"when sel=%b  \n",alu_sel_in);
		        end
	    2'b01    : 
                        begin
	                   if(alu_y_out !== vmem2[14])
		              begin
		                 $fdisplay(k,"Error in Shift Unit");
		                 $fdisplay(k,"when sel=%b ",alu_sel_in);
		                 $stop;
                              end
		           $fdisplay(k,"Shift Unit is Perfect");
		           $fdisplay(k,"when sel=%b  \n",alu_sel_in);
                        end
	    2'b10    : 
                        begin
	                   if(alu_y_out !== vmem2[15])
		              begin
		     		 $fdisplay(k,"Error in Shift Unit");
		     		$fdisplay(k,"when sel=%b ",alu_sel_in);
		     		$stop;
                  	      end
		           $fdisplay(k,"Shift Unit is Perfect");
		           $fdisplay(k,"when sel=%b  \n",alu_sel_in);
                        end
	    2'b11    :
                        begin
	       		   if(alu_y_out !== vmem2[16])
		  	      begin
		     		 $fdisplay(k,"Error in Shift Unit");
		     		 $fdisplay(k,"when sel=%b ",alu_sel_in);
		     		 $stop;
		  	      end
		           $fdisplay(k,"Shift Unit is Perfect");
		     	   $fdisplay(k,"when sel=%b  \n",alu_sel_in);
 		        end 
	    default  :  $fdisplay(k,"This input is not permitted");
         endcase
      end 
   endtask



   //Process that generates the stimulus for different operations of the ALU
   initial
      begin
	 k = $fopen ("result.out"); 
	 //Arithmetic Unit
 	 arith(5'b0,1'b0);
	 arith(5'd0,1'b1);
	 arith(5'd1,1'b0);
	 arith(5'd1,1'b1);
	 arith(5'd2,1'b0);
	 arith(5'd2,1'b1);
	 arith(5'd3,1'b0);
	 arith(5'd3,1'b1);

	 //Logic Unit
	 logic(5'd4);
	 logic(5'd5);
	 logic(5'd6);
	 logic(5'd7);

	 //Shift Unit
	 shift(5'd0);
 	 shift(5'd8);
	 shift(5'd16);
	 shift(5'd24);

	 $fclose (k);
	 $stop;
      end 

endmodule                                              








