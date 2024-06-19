/* 
Module: kpdecode
Author: Eddie Sherban
Date: January 22, 2023

This module outputs the desired hex number based on the row
and column that were input from the button.
*/

module kpdecode ( input logic [3:0] kpc,
						input logic [3:0] kpr,
						output logic kphit,
						output logic [3:0] num) ;
always_comb begin
	if (kpr == 4'b1111)
		kphit = 0;
	else
		kphit = 1;
	
	if (kpc == 4'b0111 && kpr == 4'b0111) begin       //first column first row
		num = 4'h1; //1
	end
	else if (kpc == 4'b1011 && kpr == 4'b0111) begin	//second row first column
		num = 4'h2; //2
	end
	else if (kpc == 4'b1101 && kpr == 4'b0111) begin	//third row first column
		num = 4'h3; //3
	end
	else if (kpc == 4'b1110 && kpr == 4'b0111) begin	//fourth row first column
		num = 4'hA; //STOP
	end
	else if (kpc == 4'b0111 && kpr == 4'b1011) begin	//first row seond column
		num = 4'h4; //4
	end
	else if (kpc == 4'b1011 && kpr == 4'b1011) begin	//second row second column
		num = 4'h5; //5
	end
	else if (kpc == 4'b1101 && kpr == 4'b1011) begin	//third row second column
		num = 4'h6; //6
	end
	else if (kpc == 4'b1110 && kpr == 4'b1011) begin	//fourth row second column
		num = 4'hB; //GO
	end
	else if (kpc == 4'b0111 && kpr == 4'b1101) begin	//first row third column
		num = 4'h7; //7
	end
	else if (kpc == 4'b1011 && kpr == 4'b1101) begin	//second row third column
		num = 4'h8; //8
	end
	else if (kpc == 4'b1101 && kpr == 4'b1101) begin	//third row third column
		num = 4'h9; //9
	end
	else if (kpc == 4'b1110 && kpr == 4'b1101) begin	//fourth row third column
		num = 4'hC; //LOCK
	end
	else if (kpc == 4'b0111 && kpr == 4'b1110) begin	//first row fourth column
		num = 4'hD; //ENT
	end
	else if (kpc == 4'b1011 && kpr == 4'b1110) begin	//second row fourth column
		num = 4'h0; //0
	end
	else if (kpc == 4'b1101 && kpr == 4'b1110) begin	//third row fourth column
		num = 4'hE; //ESC
	end
	else if (kpc == 4'b1110 && kpr == 4'b1110) begin	//fourth row fourth column
		num = 4'hF; //PWR
	end
	else num = 0;
end
	

endmodule