class environment;

  virtual ram_if d_vif;
	virtual ram_if m_vif;
	virtual ram_if s_vif;
	
	generator gen;
	driver d;
	monitor mon;
	scoreboard sb;
	
	mailbox #(transaction) gen2drv;
	mailbox #(transaction) drv2scr;
	mailbox #(transaction) mon2scr;
	
	function new(virtual ram_if d_vif, virtual ram_if m_vif, virtual ram_if s_vif);
	  this.d_vif = d_vif;
		this.m_vif = m_vif;
		this.s_vif = s_vif;
	endfunction
	
	task build();
	  gen2drv = new();
		drv2scr = new();
		mon2scr = new();
    gen     = new(gen2drv);
		d       = new(gen2drv, drv2scr, d_vif);
		mon     = new(mon2scr, m_vif);
		sb      = new(drv2scr, mon2scr, s_vif);
	endtask
	
	task run();
	
	  fork
			gen.run();
			d.run();
			mon.run();
			sb.run();
		join
		  sb.compare_report();
		  $display("Total cases = %0d | Passed = %0d | Failed = %0d", sb.d_tx.total, sb.d_tx.pass, sb.d_tx.fail);
	endtask
	
endclass
