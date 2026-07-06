class transaction_write extends transaction;

  virtual function transaction copy();
	  transaction_write copy_w;
		copy_w          = new();
		copy_w.write_en = this.write_en;
		copy_w.read_en  = this.read_en;
		copy_w.data_in  = this.data_in;
		copy_w.address  = this.address;
		copy_w.data_out = this.data_out;
		return copy_w;
	endfunction
	
	constraint rule1{
	  {write_en, read_en} == 2'b10;
	}
	
endclass
