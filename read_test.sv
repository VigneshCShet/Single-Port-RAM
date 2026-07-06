class read_write_test extends test;
  transaction_read tx_r;
  transaction_write tx_w;
  function new(virtual ram_if d_vif, virtual ram_if m_vif, virtual ram_if s_vif);
	  super.new(d_vif, m_vif, s_vif);
	endfunction
	
	task run();
	  env = new(d_vif, m_vif, s_vif);
		env.build();
		$display("Only Read Test Cases");
		begin
		  tx_r = new();
		  env.gen.tx = tx_r;
	  end
		env.run();
		$display("Only write Test Cases");
		begin
	    tx_w = new();
	    env.gen.tx = tx_w;
	  end
	  env.run();
	endtask
	
endclass
