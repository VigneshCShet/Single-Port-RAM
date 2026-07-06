class write_read_test extends test;
  transaction_write tx_w;
  transaction_read tx_r;
  function new(virtual ram_if d_vif, virtual ram_if m_vif, virtual ram_if s_vif);
	  super.new(d_vif, m_vif, s_vif);
	endfunction
	
	task run();
	  env = new(d_vif, m_vif, s_vif);
		env.build();
		$display("Only Write Test Cases");
		begin
		  tx_w = new();
		  env.gen.tx = tx_w;
	  end
		env.run();
		$display("Only Read Test Cases");
		begin
	    tx_r = new();
	    env.gen.tx = tx_r;
	  end
	  env.run();
	endtask
	
endclass
