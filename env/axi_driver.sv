// env/axi_driver.sv
`ifndef AXI_DRIVER_SV
`define AXI_DRIVER_SV

`include "uvm_macros.svh"   
import uvm_pkg::*;          
`include "axi_sequence_item.sv"

class axi_driver extends uvm_driver #(axi_sequence_item);

	`uvm_component_utils(axi_driver);

  // Virtual interface
  virtual axi_if.TB vif;

  // Constructor
  function new(string name = "axi_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual axi_if.TB)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NOVIF", "No virtual interface provided for axi_driver")
    end
  endfunction

  // Main run loop
  task run_phase(uvm_phase phase);
    axi_sequence_item tr;
    forever begin
      seq_item_port.get_next_item(tr);

      case (tr.cmd)
        axi_sequence_item::WRITE: drive_write(tr);
        axi_sequence_item::READ : drive_read(tr);
        default: `uvm_error("DRV", "Unknown command in transaction")
      endcase

      seq_item_port.item_done();
    end
  endtask

  // ----------------------------
  // 写通道 (AW + W + 等待 B)
  // ----------------------------
  task drive_write(axi_sequence_item tr);
    `uvm_info("DRV", $sformatf("WRITE txn: addr=0x%08h data=0x%08h", tr.addr, tr.data), UVM_MEDIUM);

    // AW channel
    @(vif.cb);
    vif.cb.awaddr  <= tr.addr;
    vif.cb.awvalid <= 1;
    vif.cb.awlen   <= 0;       // single beat
    vif.cb.awsize  <= 3'b010;  // 4 bytes
    vif.cb.awburst <= 2'b01;   // INCR
    wait (vif.awready);
    @(vif.cb);
    vif.cb.awvalid <= 0;

    // W channel
    vif.cb.wdata   <= tr.data;
    vif.cb.wstrb   <= '1;
    vif.cb.wlast   <= 1;
    vif.cb.wvalid  <= 1;
    wait (vif.wready);
    @(vif.cb);
    vif.cb.wvalid  <= 0;

    // B channel
    wait (vif.bvalid);
    @(vif.cb);
    vif.cb.bready  <= 1;
    @(vif.cb);
    vif.cb.bready  <= 0;
    `uvm_info("DRV", "WRITE complete (got BRESP)", UVM_MEDIUM);
  endtask

  // ----------------------------
  // 读通道 (AR + 等待 R)
  // ----------------------------
  task drive_read(axi_sequence_item tr);
    `uvm_info("DRV", $sformatf("READ txn: addr=0x%08h", tr.addr), UVM_MEDIUM);

    // AR channel
    @(vif.cb);
    vif.cb.araddr  <= tr.addr;
    vif.cb.arvalid <= 1;
    vif.cb.arlen   <= 0;
    vif.cb.arsize  <= 3'b010;   // 4 bytes
    vif.cb.arburst <= 2'b01;
    wait (vif.arready);
    @(vif.cb);
    vif.cb.arvalid <= 0;

    // R channel
    wait (vif.rvalid);
    @(vif.cb);
    vif.cb.rready  <= 1;
    `uvm_info("DRV", $sformatf("READ complete: data=0x%08h", vif.cb.rdata), UVM_MEDIUM);
    @(vif.cb);
    vif.cb.rready  <= 0;
  endtask

endclass

`endif

