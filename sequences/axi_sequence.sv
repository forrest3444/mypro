// env/axi_sequence.sv
`ifndef AXI_SEQUENCE_SV
`define AXI_SEQUENCE_SV

class axi_sequence extends uvm_sequence #(axi_sequence_item);
  `uvm_object_utils(axi_sequence)

  function new(string name="axi_sequence");
    super.new(name);
  endfunction

  virtual task body();
    axi_sequence_item tr;

    // 写操作
    tr = axi_sequence_item::type_id::create("tr_write");
    tr.op   = axi_sequence_item::WRITE;
    tr.addr = 32'h0000_1000;
    tr.data = 32'hDEAD_BEEF;
    start_item(tr);
    finish_item(tr);

    // 读操作
    tr = axi_sequence_item::type_id::create("tr_read");
    tr.op   = axi_sequence_item::READ;
    tr.addr = 32'h0000_1000;
    tr.data = 'hX; // 读操作 data 可以不用填
    start_item(tr);
    finish_item(tr);
  endtask

endclass

`endif

