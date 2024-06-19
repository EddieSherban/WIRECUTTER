/* 
Module: key2length
Author: Eddie Sherban
Date: February 7, 2023

This module receives a 4 bit num input that corresponds to the different wire lengths so that the
pulses sent to the stepper motor match the desired length.
*/


module key2length
	(	input logic [3:0] num,		// number pressed on keypad
		output logic [31:0] key);	// desired length
		
	always_comb begin //Frequency in Hz
		case (num)
		0 : key = 0; // 0
		1 : key = 1; // 1
		2 : key = 2; // 2
		3 : key = 3; // 3
		4 : key = 4; // 4
		5 : key = 5; // 5
		6 : key = 6; // 6
		7 : key = 7; // 7
		8 : key = 8; // 8
		9 : key = 9; // 9
		10 : key = 10;// STOP
		11 : key = 11;// GO
		12 : key = 12;// LOCK
		13 : key = 13;// ENT
		14 : key = 14;// ESC
		15 : key = 15;// PWR
		endcase
	end
	
endmodule