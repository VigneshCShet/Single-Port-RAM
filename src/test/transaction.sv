class transaction;
  rand bit write_en;
	rand bit read_en;
	rand bit [`data_width - 1 : 0] data_in;
	rand bit [addr_width - 1 : 0]  address;
	logic    [`data_width - 1 : 0] data_out;
	
	static int fail;
	static int pass;
	static int total;
	
	virtual function transaction copy();
	  copy          = new();
		copy.write_en = this.write_en;
		copy.read_en  = this.read_en;
		copy.data_in  = this.data_in;
		copy.address  = this.address;
		copy.data_out = this.data_out;
	endfunction

//constraints
	constraint rule1{
	  {write_en, read_en} inside {[0:3]};
	  {write_en, read_en} dist {0 := 10, 2 := 40, 1 := 40, 3 := 10};
	}
	
endclass
