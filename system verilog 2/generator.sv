class generator;
  
  //instants and handles
  transaction trans_gen;
  mailbox gen2driv;
  int count = 10;
  event ended;
  
  //constructor
  function new (mailbox gen2driv);
    this.gen2driv = gen2driv;
  endfunction
  
  //randomizes pwrite, but whenver it is 1, the next cycle it will be 0 with previous address
  //to make write_read sequence, don't randomize pwrite
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
