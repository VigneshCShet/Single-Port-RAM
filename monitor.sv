class monitor;
  transaction m_tx;
	mailbox #(transaction) mon2scrb;
	
	virtual ram_if.mon m_vif;
	
	covergroup mon_cg;
	  cp1: coverpoint m_tx.data_out{
	    bins out_bin = {[0:255]};
	  }
	endgroup
	
	function new(mailbox #(transaction) mon2scrb, virtual ram_if.mon m_vif);
		this.mon2scrb = mon2scrb;
		this.m_vif    = m_vif;
		m_tx          = new();
		mon_cg        = new();
	endfunction
	
	task run();
	  repeat(4)@(m_vif.mn_cb);
	  for(int i = 0; i < `num_case; i++) begin
	  
		  
		  m_tx.data_out = m_vif.mn_cb.data_out;
		  
		  //@(m_vif.mn_cb);
		  $display("%m Test ID: %0d Monitor Putting dut out: %0d into mailbox at time %0t", i, m_tx.data_out, $time);
			mon2scrb.put(m_tx.copy());
			mon_cg.sample();
			repeat(1)@(m_vif.mn_cb);
		end
	endtask
endclass
