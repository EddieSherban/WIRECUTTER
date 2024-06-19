module decode2 ( input logic [1:0] digit,
	output logic [3:0] ct) ;

always_comb
	case (digit)
	0 : ct = 4'b0001;
	1 : ct = 4'h2;
	2 : ct = 4'b0100;
	3 : ct = 4'8; //1000
	endcase
endmodule
