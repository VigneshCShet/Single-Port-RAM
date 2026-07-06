module tb;
  import ram_pkg ::*;
	logic clk;
	logic reset;
	
	event trig, trig_2;
	
	//integer pass_log;
	//integer fail_log;
	
	ram_if rif(clk, reset);
	
	/*ram rm(
	  .clk(clk), 
		.reset(reset), 
		.data_in(rif.data_in), .address(rif.address), .write_en(rif.write_en), .read_en(rif.read_en), 
		.data_out(rif.data_out)
	);*/
	
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
	//transaction_read tx_r;
	
	
	initial begin
	
	  //pass_log = $fopen("pass_log.txt", "w");
    //fail_log = $fopen("fail_log.txt", "w");
		
		//$fdisplay(pass_log, "Running Read Followed by write\n\n");
		//$fdisplay(fail_log, "Running Read Followed by write\n\n");
	  $display("\n \n \nRunning Read Followed by write \n \n");
	  t_r_w.run();
	  
	  $display("\n \n \nRunning Write Followed by Read \n \n");
	  //$fdisplay(pass_log, "Running Write Followed by Read\n\n");
		//$fdisplay(fail_log, "Running Write Followed by Read\n\n");
	  fork
	    t_w_r.run();
	    ->trig;
	  join
	  
	  $display("\n \n \nRunning Regressions\n \n");
	  //$fdisplay(pass_log, "Running Regressions\n\n");
		//$fdisplay(fail_log, "Running Regressions\n\n");
	  fork
	    t_ram.run();
	    ->trig_2;
	  join
	  	  
		
		
		
		//tx_r = new();
		//env.gen.tx = tx_r;
		//t_w.env.run();
		$finish;
	end
endmodule
