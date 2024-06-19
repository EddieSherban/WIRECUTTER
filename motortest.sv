/* 
Module: motortest
Author: Eddie Sherban
Date: March 31, 2023

This module just tests the stepper motor to make sure that it's turning properly
Note: set for 3200 steps/revolution
length of 1: 100 steps
*/

module motortest
	#(parameter FCLK = 50000000, // clock frequency in Hz
	  parameter menuselect = 0,
	  parameter inputlength = 1,
	  parameter feedwire = 2,
	  parameter cutwire = 3,
	  parameter jobfinished = 4,
	  parameter firstdigit = 1,
	  parameter seconddigit = 0,
	  parameter leglengthpulses = 6400, // 1922 pulses for the leg length
	  parameter stepsperhole = 244,     //second digit is input first hence substate = 0
	  parameter freqcontrol = 800,
	  parameter bendsteps = 2100,
	  parameter cutsteps = 2750) 

	 (	output logic stepsignal,		// output stepsignal to motor that feeds the wire
		output logic stepsignal_2,		// output stepsignal to motor that bends the wire
		output logic stepsignal_3,		// output stepsignal to motor that cuts the wire
		output logic dir,					// control direction of bend
		output logic dir_2,				// control direction of cut
		output logic [4:0] num_0, 		// first 7-segment display
		output logic [4:0] num_1, 		// second 7-segment display
		output logic [4:0] num_2, 		// third 7-segment display
		output logic [4:0] num_3, 		// fourth 7-segment display
		input logic reset_n, clk, onOff, delay,
		input logic [3:0] key);    // desired length (input from keypad)
	
	/* initial values; count is zero, state is in menuselect and pulsecounter is zero */
	int count = 0;
	int delay_count = 0;
	int state = menuselect;
	int length_substate = seconddigit; //initialize length substate as 0
	int feeder_substate = 0;
	logic [31:0] pulsecounter = 32'b0;
	logic [3:0] store_MSD = 0; //store most significant digit
	logic [3:0] store_LSD = 0; //store least significant digit
	int calculated_holes;
	
	always_ff @ (posedge clk, negedge reset_n) begin
		
		if(~reset_n) begin
			count <= 0;				  				//reset count
			pulsecounter <= 32'b0; 				//reset pulsecounter on reset
			state <= menuselect;	  				//reset state to beginning
			length_substate <= seconddigit;
			store_MSD <= 0;
			store_LSD <= 0;
			dir <= 1;
			dir_2 <= 1;
			calculated_holes <= 0;
			length_substate <= 0;
			feeder_substate <= 0;
			num_0 <= 1;
			num_1 <= 1;
			num_2 <= 1;
			num_3 <= 1;
			
			
		end
		else begin
		
			/* do this when selecting menu item */
			if(state == menuselect) begin
			
				if (key == 13 && onOff == 1 && delay == 0) begin // ENT key on keypad is 13
					state <= inputlength;
					length_substate <= seconddigit;
					
					num_0 <= 21; //21 is NOTHING
					num_1 <= 15; //16 is underscore
					num_2 <= 21; //NOTHING
					num_3 <= 21; //NOTHING

					// <= 1;
				end
				else begin
					// <= 0;
					num_0 <= 4'h1; //1
					num_1 <= 4'h1;	//1
					num_2 <= 4'h1; //1
					num_3 <= 18;	//H
				end
			end
			
			
			/* do this to tell user to input the length */ 
			else if(state == inputlength) begin		
					if(length_substate == seconddigit) begin
						if(key < 10 && onOff == 1 && delay == 0) begin
							store_MSD <= key;
							num_1 <= key;
						end
						else if(key == 14 && onOff == 1 && delay == 0) begin //key 14 is ESC
							length_substate <= firstdigit;
							num_0 <= 15; //15 is underscore
						end else
							store_MSD <= store_MSD;
					end
					if(length_substate == firstdigit) begin
						if(key <= 9 && onOff == 1 && delay == 0) begin
							store_LSD <= key;
							num_0 <= key;
						end
						else if(key == 15 && onOff == 1 && delay == 0) begin //key 15 is PWR
							calculated_holes <= (10*store_MSD + store_LSD)*stepsperhole; //calculated length
							state <= feedwire;
							length_substate <= seconddigit;
							num_0 <= 4'hE;	//E
							num_1 <= 18; 	//H
							num_2 <= 4'hE;	//E
							num_3 <= 18;	//H
							
						end
						else store_LSD <= store_LSD;
					end
			end
			
			/* do this if we want to feed wire */
			else if(state == feedwire) begin
				if(calculated_holes < 5*stepsperhole) begin
					calculated_holes <= 5*stepsperhole;
				end
				else calculated_holes <= calculated_holes; //calculated length
			/************************************wireleg 1******************************************/
				if(feeder_substate == 0) begin
					//// <= 0;
					/* This part creates the waveform that precisely controls motor rotation */
					if (pulsecounter < 1000) begin //pulsecounter of 6400 is a full revolution, pulsecounter < 126 would give 126 steps.
						if(count <= FCLK) begin
							count <= count + (2*freqcontrol); //ex. freqcontrolHz output means freqcontrol out of 3200 steps, count + (2*freqcontrol) means freqcontrol pulses per second
						end			
					
						else if(count >= FCLK) begin
							stepsignal <= ~stepsignal;
							count <= count - FCLK;
							pulsecounter <= pulsecounter + 1;
						end
					end
					else if(pulsecounter >= 1000) begin //if pulsecounter is greater than number of pulses we want, assign the stepsignal to low voltage
						stepsignal <= 0;
						feeder_substate <= 1;
						dir <= 1;
						pulsecounter <= 0;
					end
						/* end of waveform control */
				end
			/************************************end wireleg 1******************************************/
			/************************************bend 1******************************************/
				else if(feeder_substate == 1) begin
					/* This part creates the waveform that precisely controls motor rotation */
					if (pulsecounter < bendsteps) begin //pulsecounter of 6400 is a full revolution, pulsecounter < 126 would give 126 steps.
						if(count <= FCLK) begin
							count <= count + (2*freqcontrol); //ex. freqcontrolHz output means freqcontrol out of 3200 steps, count + (2*freqcontrol) means freqcontrol pulses per second
						end			
					
						else if(count >= FCLK) begin
							stepsignal_2 <= ~stepsignal_2;
							count <= count - FCLK;
							pulsecounter <= pulsecounter + 1;
						end
					end
					else if(pulsecounter >= bendsteps) begin //if pulsecounter is greater than number of pulses we want, assign the stepsignal to low voltage
						stepsignal <= 0;
						feeder_substate <= 2;
						dir <= 0;
						pulsecounter <= 0;
					end
						/* end of waveform control */
				end
			/************************************end bend 1******************************************/
			/************************************unbend 1******************************************/
				else if(feeder_substate == 2) begin
					/* This part creates the waveform that precisely controls motor rotation */
					if (pulsecounter < bendsteps) begin //pulsecounter of 6400 is a full revolution, pulsecounter < 126 would give 126 steps.
						if(count <= FCLK) begin
							count <= count + (2*freqcontrol); //ex. freqcontrolHz output means freqcontrol out of 3200 steps, count + (2*freqcontrol) means freqcontrol pulses per second
						end			
					
						else if(count >= FCLK) begin
							stepsignal_2 <= ~stepsignal_2;
							count <= count - FCLK;
							pulsecounter <= pulsecounter + 1;
						end
					end
					else if(pulsecounter >= bendsteps) begin //if pulsecounter is greater than number of pulses we want, assign the stepsignal to low voltage
						stepsignal <= 0;
						feeder_substate <= 3;
						dir <= 1;
						pulsecounter <= 0;
					end
						/* end of waveform control */
				end
			/************************************end unbend 1******************************************/			
			/************************************wire length******************************************/
				else if(feeder_substate == 3) begin
					/* This part creates the waveform that precisely controls motor rotation */
					if (pulsecounter < calculated_holes) begin //pulsecounter of 6400 is a full revolution, pulsecounter < 126 would give 126 steps.
						if(count <= FCLK) begin
							count <= count + (2*freqcontrol); //ex. freqcontrolHz output means freqcontrol out of 3200 steps, count + (2*freqcontrol) means freqcontrol pulses per second
						end			
					
						else if(count >= FCLK) begin
							stepsignal <= ~stepsignal;
							count <= count - FCLK;
							pulsecounter <= pulsecounter + 1;
						end
					end
					else if(pulsecounter >= calculated_holes) begin //if pulsecounter is greater than number of pulses we want, assign the stepsignal to low voltage
						stepsignal <= 0;
						feeder_substate <= 4;
						pulsecounter <= 0;
					end
						/* end of waveform control */
				end
			/************************************end wire length******************************************/
			/************************************bend 2******************************************/
				else if(feeder_substate == 4) begin
					/* This part creates the waveform that precisely controls motor rotation */
					if (pulsecounter < bendsteps) begin //pulsecounter of 6400 is a full revolution, pulsecounter < 126 would give 126 steps.
						if(count <= FCLK) begin
							count <= count + (2*freqcontrol); //ex. freqcontrolHz output means freqcontrol out of 3200 steps, count + (2*freqcontrol) means freqcontrol pulses per second
						end			
					
						else if(count >= FCLK) begin
							stepsignal_2 <= ~stepsignal_2;
							count <= count - FCLK;
							pulsecounter <= pulsecounter + 1;
						end
					end
					else if(pulsecounter >= bendsteps) begin //if pulsecounter is greater than number of pulses we want, assign the stepsignal to low voltage
						stepsignal <= 0;
						feeder_substate <= 5;
						dir <= 0;
						pulsecounter <= 0;
					end
						/* end of waveform control */
				end
			/************************************end bend 1******************************************/
			/************************************unbend 2******************************************/
				else if(feeder_substate == 5) begin
					/* This part creates the waveform that precisely controls motor rotation */
					if (pulsecounter < bendsteps) begin //pulsecounter of 6400 is a full revolution, pulsecounter < 126 would give 126 steps.
						if(count <= FCLK) begin
							count <= count + (2*freqcontrol); //ex. freqcontrolHz output means freqcontrol out of 3200 steps, count + (2*freqcontrol) means freqcontrol pulses per second
						end			
					
						else if(count >= FCLK) begin
							stepsignal_2 <= ~stepsignal_2;
							count <= count - FCLK;
							pulsecounter <= pulsecounter + 1;
						end
					end
					else if(pulsecounter >= bendsteps) begin //if pulsecounter is greater than number of pulses we want, assign the stepsignal to low voltage
						stepsignal <= 0;
						feeder_substate <= 6;
						dir <= 1;
						pulsecounter <= 0;
					end
						/* end of waveform control */
				end
			/************************************end unbend 1******************************************/	
			/************************************wireleg 2******************************************/
				else if(feeder_substate == 6) begin
					/* This part creates the waveform that precisely controls motor rotation */
					if (pulsecounter < 1000) begin //pulsecounter of 6400 steps is a full revolution, pulsecounter < 126 would give 126 steps.
						if(count <= FCLK) begin
							count <= count + (2*freqcontrol); //ex. freqcontrolHz output means freqcontrol out of 3200 steps, count + (2*freqcontrol) means freqcontrol pulses per second
						end			
					
						else if(count >= FCLK) begin
							stepsignal <= ~stepsignal;
							count <= count - FCLK;
							pulsecounter <= pulsecounter + 1;
						end
					end
					else if(pulsecounter >= 1000) begin //if pulsecounter is greater than number of pulses we want, assign the stepsignal to low voltage
						stepsignal <= 0;
						feeder_substate <= 0;
						dir <= 1;
						pulsecounter <= 0;
						state <= cutwire;
					end
						/* end of waveform control */
				end
			/************************************end wireleg 2******************************************/			
			end
			
			
			/* do this to cut the wire */
			else if(state == cutwire) begin
			/************************************cut******************************************/
				if(feeder_substate == 0) begin
					/* This part creates the waveform that precisely controls motor rotation */
					if (pulsecounter < cutsteps) begin //pulsecounter of 6400 is a full revolution, pulsecounter < 126 would give 126 steps.
						if(count <= FCLK) begin
							count <= count + (2*100); //ex. freqcontrolHz output means freqcontrol out of 3200 steps, count + (2*freqcontrol) means freqcontrol pulses per second
						end			
					
						else if(count >= FCLK) begin
							stepsignal_3 <= ~stepsignal_3;
							count <= count - FCLK;
							pulsecounter <= pulsecounter + 1;
						end
					end
					else if(pulsecounter >= cutsteps) begin //if pulsecounter is greater than number of pulses we want, assign the stepsignal to low voltage
						stepsignal <= 0;
						feeder_substate <= 1;
						dir_2 <= 0;
						pulsecounter <= 0;
					end
						/* end of waveform control */
				end
			/************************************end cut******************************************/
			/************************************uncut******************************************/
				else if(feeder_substate == 1) begin
					/* This part creates the waveform that precisely controls motor rotation */
					if (pulsecounter < cutsteps) begin //pulsecounter of 6400 is a full revolution, pulsecounter < 126 would give 126 steps.
						if(count <= FCLK) begin
							count <= count + (2*100); //ex. freqcontrolHz output means freqcontrol out of 3200 steps, count + (2*freqcontrol) means freqcontrol pulses per second
						end			
					
						else if(count >= FCLK) begin
							stepsignal_3 <= ~stepsignal_3;
							count <= count - FCLK;
							pulsecounter <= pulsecounter + 1;
						end
					end
					else if(pulsecounter >= cutsteps) begin //if pulsecounter is greater than number of pulses we want, assign the stepsignal to low voltage
						stepsignal <= 0;
						feeder_substate <= 0;
						dir_2 <= 1;
						pulsecounter <= 0;
						state <= menuselect;
					end
						/* end of waveform control */
				end
			end			
		end
		
	end
		

	
endmodule