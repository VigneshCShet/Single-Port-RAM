module tb;
  import ram_pkg ::*;
	logic clk;
	logic reset;
	
	event trig, trig_2;

	ram_if rif(clk, reset);
	
	RAM rm(
          .clk(clk), // Clk input
          .reset(reset), //Reset input active low
          .address(rif.address), // Address Input
          .data_in(rif.data_in), // Data in 
          .write_enb(rif.write_en), // Write Enable
          .read_enb(rif.read_en),  // Read Enable
          .data_out(rif.data_out)   // Data out
          );
	
	initial clk = 0;
	always #20 clk = ~clk;
	
	initial begin
	  @(posedge clk);
		reset = 0;
		
		
		@(posedge clk);
		reset = 1;
		$display("Reset Deasserted at time %0t", $time);
		
		repeat(3) @(posedge clk);
		reset = 0;
		
		repeat(4)@(posedge clk);
		reset = 1;
		$display("Reset Deasserted at time %0t", $time);
		
		wait(trig);
		repeat(3) @(posedge clk);
		reset = 0;
		
		repeat(4)@(posedge clk);
		reset = 1;
		$display("Reset Deasserted at time %0t", $time);
		
		wait(trig_2);
		repeat(3) @(posedge clk);
		reset = 0;
		
		repeat(4)@(posedge clk);
		reset = 1;
		$display("Reset Deasserted at time %0t", $time);
		
	end
	
	test t_ram     = new(rif.drv, rif.mon, rif.scr);
	read_write_test t_r_w  = new(rif.drv, rif.mon, rif.scr);
	write_read_test t_w_r = new(rif.drv, rif.mon, rif.scr);
	
	
	initial begin
		
	  $display("\n \n \nRunning Read Followed by write \n \n");
	  t_r_w.run();
	  
	  $display("\n \n \nRunning Write Followed by Read \n \n");
		
	  fork
	    t_w_r.run();
	    ->trig;
	  join
	  
	  $display("\n \n \nRunning Regressions\n \n");

	  fork
	    t_ram.run();
	    ->trig_2;
	  join
	  	  
		$finish;
	end
endmodule
