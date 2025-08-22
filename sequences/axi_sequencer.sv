// env/axi_sequencer.sv
`ifndef AXI_SEQUENCER_SV
`define AXI_SEQUENCER_SV

class axi_sequencer extends uvm_sequencer #(axi_sequence_item);
  `uvm_component_utils(axi_sequencer)

  function new(string name="axi_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction

endclass

`endif

