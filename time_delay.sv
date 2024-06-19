module time_delay
	#(parameter delay_cycles = 50000000) //number of clock cycles to delay
	 (	output logic delay,		// output 0 to indicate no delay, 1 delay in process
		input logic reset_n, clk, keyhit);   
		
	int delay_count = delay_cycles;
		
	always_ff @(posedge clk, negedge reset_n) begin
	
		
		
		if(~reset_n) begin
			delay_count <= delay_cycles;
			delay <= 0; //no delay signal
		end
		else if(delay_count < delay_cycles) begin
			delay_count <= delay_count + 1;
			delay <= 1;
		end
		else if(keyhit) begin
			delay_count <= 0;
			delay <= 0;
		end
		else begin
			delay_count <= delay_cycles;
			delay <= 0;
		end
	end
		
endmodule 