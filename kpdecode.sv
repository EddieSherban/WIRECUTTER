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
	kphit = 0; //initialize kphit and num to 0
	num = 0;	  //only change when button is scanned
	
	if (kpc == 4'b0111 && kpr == 4'b0111) begin       //first row first column
		num = 4'h1; 
		kphit = 1;
	end
	else if (kpc == 4'b1011 && kpr == 4'b0111) begin	//second row first column
		num = 4'h2;
		kphit = 1;
	end
	else if (kpc == 4'b1101 && kpr == 4'b0111) begin	//third row first column
		num = 4'h3;
		kphit = 1;
	end
	else if (kpc == 4'b1110 && kpr == 4'b0111) begin	//fourth row first column
		num = 4'hA;
		kphit = 1;
	end
	else if (kpc == 4'b0111 && kpr == 4'b1011) begin	//first row seond column
		num = 4'h4;
		kphit = 1;
	end
	else if (kpc == 4'b1011 && kpr == 4'b1011) begin	//second row second column
		num = 4'h5;
		kphit = 1;
	end
	else if (kpc == 4'b1101 && kpr == 4'b1011) begin	//third row second column
		num = 4'h6;
		kphit = 1;
	end
	else if (kpc == 4'b1110 && kpr == 4'b1011) begin	//fourth row second column
		num = 4'hB;
		kphit = 1;
	end
	else if (kpc == 4'b0111 && kpr == 4'b1101) begin	//first row third column
		num = 4'h7;
		kphit = 1;
	end
	else if (kpc == 4'b1011 && kpr == 4'b1101) begin	//second row third column
		num = 4'h8;
		kphit = 1;
	end
	else if (kpc == 4'b1101 && kpr == 4'b1101) begin	//third row third column
		num = 4'h9;
		kphit = 1;
	end
	else if (kpc == 4'b1110 && kpr == 4'b1101) begin	//fourth row third column
		num = 4'hC;
		kphit = 1;
	end
	else if (kpc == 4'b0111 && kpr == 4'b1110) begin	//first row fourth column
		num = 4'hE;
		kphit = 1;
	end
	else if (kpc == 4'b1011 && kpr == 4'b1110) begin	//second row fourth column
		num = 4'h0;
		kphit = 1;
	end
	else if (kpc == 4'b1101 && kpr == 4'b1110) begin	//third row fourth column
		num = 4'hF;
		kphit = 1;
	end
	else if (kpc == 4'b1110 && kpr == 4'b1110) begin	//fourth row fourth column
		num = 4'hD;
		kphit = 1;
	end	
	
	else if (num == 0) begin	//if button is not pressed, don't display anything, only display when pressed
		kphit = 0;
	end
end
	

endmodule