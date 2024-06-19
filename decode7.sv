module decode2 ( input logic [1:0] num,
	output logic [7:0] leds) ;

always_comb
	case (idnum)
	0 : leds = 8'b1100 0000; //display 0
	1 : leds = 8'b1111 1001; //display 1
	2 : leds = 8'b1010 0100; //display 2
	3 : leds = 8'b1011 0000; //display 3
	4 : leds = 8'b1001 1001; //display 4
	5 : leds = 8'b1001 0010;
	6 : leds = 8'b1000 0010;
	7 : leds = 8'b1111 1000;
	8 : leds = 8'b1000 0000;
	9 : leds = 8'b1001 0000;
	10 : leds = 8'b1000 1000;
	11 : leds = 8'b1000 0011;
	12 : leds = 8'b1100 0110;
	13 : leds = 8'b1010 0001;
	14 : leds = 8'b1000 0110;
	15 : leds = 8'b1000 1110;
	
	endcase
endmodule
