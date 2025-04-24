class scoreboard;
  
  //objects and handles
  transaction trans_sb;
  mailbox mon2sb;
  int count2;
  bit [31:0] sc_mem [0:255];
  
  //constructor
  function new (mailbox mon2sb);
    this.mon2sb = mon2sb;
    foreach (sc_mem[i]) sc_mem[i] = 'x; 
  endfunction
  
  //task checking all the values
  task main;
    forever
      begin
        trans_sb = new ();
        mon2sb.get(trans_sb);
        trans_sb.display("SCOREBOARD");
        
        if (trans_sb.pwrite == 1)
          begin
            sc_mem[trans_sb.paddr] = trans_sb.pwdata;
            $display("WRITE DONE.");
          end
        
        else if (trans_sb.pwrite == 0)
          begin
            if (sc_mem[trans_sb.paddr] != trans_sb.prdata)
              $error("READ MISMATCH. Expected = %0d | Actual = %0d", sc_mem[trans_sb.paddr], trans_sb.prdata);
            else 
              $display("READ MATCH. Expected = %0d | Actual = %0d", sc_mem[trans_sb.paddr], trans_sb.prdata);
          end
        
        $display("------");
        count2++;
      end
  endtask : main
  
endclass : scoreboard
