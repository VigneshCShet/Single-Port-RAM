class transaction_read extends transaction;

  virtual function transaction copy();
	  transaction_read copy_r;
		copy_r          = new();
		copy_r.write_en = this.write_en;
		copy_r.read_en  = this.read_en;
		copy_r.data_in  = this.data_in;
		copy_r.address  = this.address;
		copy_r.data_out = this.data_out;
		return copy_r;
	endfunction
	
	constraint rule1{
	  {write_en, read_en} == 2'b01;
	}
	
	constraint rule2{
	  if(read_en == 1){
	    data_in == 0;
	  }
	}
	
endclass
