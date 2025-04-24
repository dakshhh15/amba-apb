class transaction;

  //signals
  bit psel, penable;
  rand bit pwrite;
  rand bit [31:0] paddr, pwdata;
  bit pready;
  bit [31:0] prdata;

  //internal signals
  static bit [31:0] prev_addr;
  static bit prev_write;

  //coverage
  covergroup g1;
    addr : coverpoint paddr { bins valid[] = {[0:255]}; }
    read_wr : cross paddr, pwrite;
  endgroup : g1

  //constraints
  constraint address_range { paddr[31:0] < 256; }
  constraint sequence_w_r { if (prev_write == 1)
			{ pwrite == 0;
			  prev_addr == paddr; } }

  //inititalizing internal signals
  function void post_randomize();
    prev_addr = paddr;
    prev_write = pwrite;
  endfunction 

  //constructor
  function new ();
    g1 = new();
  endfunction

  //display function
  function void display (string name);
    $write ("[%s]", name);
    $display ("[%0t] PADDR : %0d || PWDATA : %0d || PWRITE : %0d || PRDATA : %0d", $time, paddr, pwdata, pwrite, prdata);
  endfunction : display

endclass : transaction
