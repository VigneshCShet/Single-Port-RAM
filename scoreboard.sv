class scoreboard;
  mailbox #(transaction) drv2scr;
	mailbox #(transaction) mon2scr;
  
	transaction d_tx, m_tx;
	
	virtual ram_if.scr s_vif;
	
	
	reg [`data_width - 1 : 0] mem[0 : `depth - 1];
	
	logic [7:0] data_out;
	//logic [7:0] duv_out[$];
	
	function new(mailbox #(transaction) drv2scr,	mailbox #(transaction) mon2scr, virtual ram_if.scr s_vif);
	  this.drv2scr = drv2scr;
		this.mon2scr = mon2scr;
		this.s_vif   = s_vif;
		d_tx         = new();
		m_tx         = new();
	endfunction
	
	task run();
	  for(int i = 0; i < `num_case; i++) begin
	    if(!s_vif.sc_cb.reset) begin
	      $display("Reset Asserted");
			  data_out = 'z;
	      foreach(mem[j])
	      	mem[j] = 0;
	    end
	  	    
		  drv2scr.get(d_tx);
			$display("%m Got data_in = %0d | address = %0d | write_en = %0d | read_en = %0d", d_tx.data_in, d_tx.address, d_tx.write_en, d_tx.read_en);
		  
		  if(!s_vif.sc_cb.reset) begin
			  data_out = 'z;
	      foreach(mem[j])
	      	mem[j] = 0;
	    end
			else begin
				@(s_vif.sc_cb);
				if(d_tx.write_en && !d_tx.read_en) begin
					$display("Writing into the reference");
					mem[d_tx.address] = d_tx.data_in;
					data_out          = 'z;
				end
					
				if(d_tx.read_en && !d_tx.write_en) begin
					$display("Reading from the reference");
					data_out          = mem[d_tx.address];
				end
			end			
			
			mon2scr.get(m_tx);
			
			if(i != `num_case - 1)
			  compare_report();
		end
	endtask
	
	task compare_report();
	
	  if(s_vif.sc_cb.reset == 0) begin
	  
	    $display("Reset Asserted");
	    
	  end
	  
	  else begin
			if(d_tx.read_en == 1 && d_tx.write_en == 0) begin
			
				if(data_out === m_tx.data_out) begin
					$display("Test PASSED : ref = %0d | dut = %0d", data_out, m_tx.data_out);
					//$fdisplay(pass_log, "Test PASSED : ref = %0d | dut = %0d", data_out, m_tx.data_out);
					d_tx.pass++;
					d_tx.total++;
			  end
				else begin
					$display("At time %0t Test FAILED : ref = %0d | dut = %0d", $time, data_out, m_tx.data_out);
			    //$fdisplay(fail_log, "Test FAILED : ref = %0d | dut = %0d", data_out, m_tx.data_out);
			    d_tx.fail++;
			    d_tx.total++;
			  end
			end
			
			 if(d_tx.write_en == 1 && d_tx.read_en == 0) begin
			 
			  $display("Writing in to RAM");
			  if(data_out === m_tx.data_out) begin
			  
					$display("Test PASSED : ref = %0d | dut = %0d", data_out, m_tx.data_out);
					//$fdisplay(pass_log, "Test PASSED : ref = %0d | dut = %0d", data_out, m_tx.data_out);
					d_tx.pass++;
					d_tx.total++;
					
			  end
			  
				else begin
				
					$display("At time %0t Test FAILED : ref = %0d | dut = %0d", $time,  data_out, m_tx.data_out);
			    //$fdisplay(fail_log, "Test FAILED : ref = %0d | dut = %0d", data_out, m_tx.data_out);
			    d_tx.fail++;
			    d_tx.total++;
			    
			  end
			end
			  
			if(!d_tx.read_en && !d_tx.write_en)
			  $display("No operation");
			  d_tx.total++; 		
		 end
		 
		 if(d_tx.read_en && d_tx.write_en) begin
		   $display("Invalid Operation");
		   d_tx.total++;
		 end
	  
	endtask
	
endclass
