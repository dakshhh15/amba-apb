class generator;
  
  transaction trans_gen;
  mailbox gen2driv;
  int count = 10;
  event ended;
  
  function new (mailbox gen2driv);
    this.gen2driv = gen2driv;
  endfunction
  
  task main;
    repeat (count)
      begin
        trans_gen = new();
        void'(trans_gen.randomize());
        trans_gen.g1.sample();
        gen2driv.put(trans_gen);
        trans_gen.display("GENERATOR");
      end
    -> ended;
  endtask : main 
  
endclass : generator
