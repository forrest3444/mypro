`ifndef AXI_SEQUENCE_ITEM_SV
`define AXI_SEQUENCE_ITEM_SV

class axi_sequence_item extends uvm_sequence_item;

	typedef enum { READ, WRITE } axi_cmd_e;

	rand bit [31:0] addr;
	rand bit [31:0] data;
	rand axi_cmd_e cmd;
	
	`uvm_object_utils_begin(axi_sequence_item)
		`uvm_field_int (addr, UVM_ALL_ON)
		`uvm_field_int (data, UVM_ALL_ON)
		`uvm_field_enum (axi_cmd_e, cmd, UVM_ALL_ON)
	`uvm_object_utils_end
	
	function new(string name="axi_sequence_item");
		super.new(name);
	endfunction

  function string convert2string();
		return $sformatf("AXI txn: addr=0x%08h data=0x%08h cmd=%s",
			addr, data, cmd.name());
	endfunction

endclass

`endif

