/* 
Module: motortest
Author: Eddie Sherban
Date: March 31, 2023

This module just tests the stepper motor to make sure that it's turning properly
Note: set for 3200 steps/revolution
length of 1: 100 steps
*/

module motortest
	#(parameter FCLK = 50000000, 
	  parameter waiting = 1,
	  parameter cuttingwire = 2) 	// clock frequency in Hz
	 (	output logic stepsignal,		// output stepsignal
		input logic reset_n, clk, onOff,
		input logic [31:0] length);    // desired length (input from keypad)
	
	int count = 0;
	int state = waiting;
	int pulsecounter = 0;
	
	always_ff @ (posedge clk, negedge reset_n) begin
		
		if(~reset_n) begin
			count <= 0;
		end
		else begin
			if(onOff == 1 && state == waiting) begin
				state <= cuttingwire;
			end
			else state <= waiting;
			
			if(state == cuttingwire)
				if(count <= FCLK) begin
					count <= count + (2*length*126); //ex. 500Hz output means 500 out of 3200 steps, count + (2*500) means 500 pulses per second
				end			
			
				if(count >= FCLK) begin
					stepsignal <= ~stepsignal;
					count <= count - FCLK;
					pulsecounter++;
				end
				
				if(pulsecounter/2 >= length*126) begin //if number of pulses is equal to or greater than length, change states
					state <= waiting;
				end
		end
		
	end
		

	
endmodule