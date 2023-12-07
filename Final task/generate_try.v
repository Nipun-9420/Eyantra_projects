module generate_design #(parameter N = 4) (input a, b, output [N * (N + 1) / 2 - 1 : 0] o);

genvar i, j;
generate for(i = 0; i < N; i = i + 1) begin: GEN_LOOP
	// Width of q on each iteration depends on genvar i
	(* keep = 1*) reg [i:0] q;

	if(i % 2 == 0) begin: GEN_TRUE
		always@* q[i:0] = {i+1{a}};
	end
	else begin : GEN_FALSE
		always@* q[i:0] = {i+1{b}};
	end
end
endgenerate

generate for(j = 0; j < N; j = j + 1) begin : GEN_LOOP2

	assign o[j + j * (j + 1) / 2 : 0 + j * (j + 1) / 2] = GEN_LOOP[j].q[j:0];
end
endgenerate
endmodule
