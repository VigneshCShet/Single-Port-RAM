class generator;

  transaction tx;
	mailbox #(transaction)gen2drv;
	
	function new(mailbox #(transaction) gen2drv);
		this.gen2drv = gen2drv;
		tx           = new();
	endfunction
	
	task run();
		for(int i = 0; i < `num_case; i++) begin
		
			assert(tx.randomize() == 1);
			gen2drv.put(tx.copy());
			
		end
	endtask
	
endclass
