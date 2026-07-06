class driver;

  virtual ram_if.drv vinf;
	transaction d_tx;
	mailbox #(transaction) gen2drv;
	mailbox #(transaction) drv2scr;
	
	//coverage
  covergroup drv_cg;
    Write:   coverpoint d_tx.write_en {
      bins wr[]    = {0, 1};
    }
    
    Read :   coverpoint d_tx.read_en { 
      bins rd[]    = {0, 1};
    }
    
    Data_in: coverpoint d_tx.data_in { 
      bins data    = {[0:255]};
    }
    
    Address: coverpoint d_tx.address { 
      bins address = {[0:31]};
    }
    
    Write_x_Read: cross Write, Read{
      ignore_bins nt_rq = (binsof(Write.wr[1]) intersect {1}) && (binsof(Read.rd[1]) intersect {1});
    }
    
  endgroup
  
	function new(mailbox #(transaction) gen2drv, mailbox #(transaction) drv2scr, virtual ram_if.drv vinf);
	  this.gen2drv = gen2drv;
		this.drv2scr = drv2scr;
		this.vinf    = vinf;
		d_tx         = new();
		drv_cg       = new();
	endfunction
	
	task run();
		repeat(3) @(vinf.dr_cb);
	  for(int i = 0; i < `num_case; i++) begin
	    //d_tx = new();
		  gen2drv.get(d_tx);
			//repeat(1) @(vinf.dr_cb);
			
			if(vinf.dr_cb.reset == 0) begin
				vinf.dr_cb.data_in  <= 8'bz;
				vinf.dr_cb.write_en <= 0;
				vinf.dr_cb.read_en  <= 0;
				vinf.dr_cb.address  <= 0;
				
				$display("\n \nDriving inputs during reset at time %0t Test ID: %0d: data_in = %0d | address = %0d | write_en = %0d | read_en = %0d", $time,  i, d_tx.data_in, d_tx.address, d_tx.write_en, d_tx.read_en);
			  
			end
			
			else begin
			  vinf.dr_cb.data_in  <= d_tx.data_in;
				vinf.dr_cb.write_en <= d_tx.write_en;
				vinf.dr_cb.read_en  <= d_tx.read_en;
				vinf.dr_cb.address  <= d_tx.address;
		
				
				$display("\n \nDriving inputs at time %0t Test ID %0d: data_in = %0d | address = %0d | write_en = %0d | read_en = %0d", $time, i, d_tx.data_in, d_tx.address, d_tx.write_en, d_tx.read_en);
			end
			drv2scr.put(d_tx.copy());
			drv_cg.sample();
			repeat(1) @(vinf.dr_cb);
		end
	endtask
endclass
