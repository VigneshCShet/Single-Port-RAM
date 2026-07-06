`include "defines.svh"

interface ram_if(input bit clk, reset);
  	
  logic                       write_en, read_en;
  logic [`data_width - 1 : 0] data_in;
  logic [addr_width - 1 : 0] address;

  logic [`data_width - 1 : 0] data_out;
	
	clocking dr_cb @(posedge clk);
		default input #0 output #0;
		output  write_en, read_en, data_in, address;
		input   reset;
	endclocking
	
	clocking mn_cb @(posedge clk);
	  default input #0 output #0;
		input   data_out;
	endclocking
	
	clocking sc_cb @(posedge clk);
	  default input #0 output #0;
		input   reset;
	endclocking
	
	modport drv(clocking dr_cb);
	modport mon(clocking mn_cb);
	modport scr(clocking sc_cb);
	
endinterface
