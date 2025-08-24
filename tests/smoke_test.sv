`ifndef SMOKE_TEST_SV
`define SMOKE_TEST_SV

`include "axi_base_test.sv"

class smoke_test extends base_test;
   `uvm_component_utils(smoke_test)

   function new(string name="smoke_test", uvm_component parent);
      super.new(name, parent);
   endfunction

   task run_phase(uvm_phase phase);
      axi_sequence seq;

      phase.raise_objection(this);

      seq = axi_sequence::type_id::create("seq");
      seq.start(env.agt_i.sequencer);

      phase.drop_objection(this);
   endtask
endclass

`endif
