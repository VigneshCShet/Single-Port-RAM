class test;
  virtual ram_if d_vif;
	virtual ram_if m_vif;
	virtual ram_if s_vif;
	environment env;
	
	function new(virtual ram_if d_vif, virtual ram_if m_vif, virtual ram_if s_vif);
	  this.d_vif = d_vif;
		this.m_vif = m_vif;
		this.s_vif = s_vif;
	endfunction
	
	task run();
	  env = new(d_vif, m_vif, s_vif);
		env.build();
		env.run();
	endtask
endclass
