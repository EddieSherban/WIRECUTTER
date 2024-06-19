/* 
Module: key2length
Author: Eddie Sherban
Date: February 7, 2023

This module receives a 4 bit num input that corresponds to the different wire lengths so that the
pulses sent to the stepper motor match the desired length.
*/


module key2length
	(	input logic [3:0] num,		// number pressed on keypad
		output logic [31:0] length);	// desired length
		
	always_comb begin //Frequency in Hz
		case (num)
		0 : length = 1; // 1 hole on breadboard
		1 : length = 2; // 2 holes on breadboard
		2 : length = 3; // 3 etc.
		3 : length = 4; // 
		4 : length = 5; // 
		5 : length = 6; // 
		6 : length = 7; // 
		7 : length = 8; // 
		8 : length = 9; // 
		9 : length = 10; // 
		10 : length = 11;// 
		11 : length = 12;// 
		12 : length = 13;// 
		13 : length = 14;// 
		14 : length = 15;// 
		15 : length = 16;// 
		endcase
	end
	
endmodule