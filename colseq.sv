/* 
Module: colseq
Author: Eddie Sherban
Date: January 22, 2023

In this module, the flip flop constantly counts up, cycling through the columns 
and will keep counting as long as the button is not pressed (the button being kpr)
*/

//Martin's bout to pull your nuts

module colseq ( output logic [3:0] kpc, 					// column output
					 input logic clk, input logic reset_n,
					 
					 input logic [3:0] kpr);					// row input
	
logic [1:0] count;

always_comb begin
			
	case (count)
		0 : kpc = 'b0111; //first column
		1 : kpc = 'b1011; //second column
		2 : kpc = 'b1101; //third column
		3 : kpc = 'b1110; //fourth column
		default : kpc = 'b0111; //default state
	endcase
end

//if reset_n is pressed, initialize machine state
always_ff @(posedge clk, negedge reset_n) begin
	if (~reset_n)
		count <= 0;
	else if (kpr == 'hF)
		count <= count + 1;
end

endmodule