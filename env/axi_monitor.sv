// env/axi_monitor.sv
`ifndef AXI_MONITOR_SV
`define AXI_MONITOR_SV

`include "uvm_macros.svh"   
import uvm_pkg::*;          
`include "axi_sequence_item.sv"
`include "axi_if.sv"

class axi_monitor extends uvm_monitor;

	`uvm_component_utils(axi_monitor);
  // virtual interface
  virtual axi_if.TB vif;

  // Analysis port (把 transaction 往外送)
  uvm_analysis_port #(axi_sequence_item) ap;

  // Constructor
  function new(string name = "axi_monitor", uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual axi_if.TB)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NOVIF", "No virtual interface provided for axi_monitor")
    end
  endfunction

  // Run phase: 采样信号
  task run_phase(uvm_phase phase);
    forever begin
      fork
        collect_write();
        collect_read();
      join_any
    end
  endtask

  // ----------------------------
  // 采样写事务 (AW + W + B)
  // ----------------------------
  task collect_write();
    axi_sequence_item tr;

    // 等待写地址
    @(posedge vif.clk iff (vif.awvalid && vif.awready));
    tr = axi_sequence_item::type_id::create("tr", this);
    tr.addr = vif.awaddr;
    tr.cmd  = axi_sequence_item::WRITE;

    // 等待写数据
    @(posedge vif.clk iff (vif.wvalid && vif.wready));
    tr.data = vif.wdata;

    // 等待写响应
    @(posedge vif.clk iff (vif.bvalid && vif.bready));

    `uvm_info("MON", $sformatf("Monitor captured WRITE: %s", tr.convert2string()), UVM_MEDIUM);
    ap.write(tr);
  endtask

  // ----------------------------
  // 采样读事务 (AR + R)
  // ----------------------------
  task collect_read();
    axi_sequence_item tr;

    // 等待读地址
    @(posedge vif.clk iff (vif.arvalid && vif.arready));
    tr = axi_sequence_item::type_id::create("tr", this);
    tr.addr = vif.araddr;
    tr.cmd  = axi_sequence_item::READ;

    // 等待读数据
    @(posedge vif.clk iff (vif.rvalid && vif.rready));
    tr.data = vif.rdata;

    `uvm_info("MON", $sformatf("Monitor captured READ : %s", tr.convert2string()), UVM_MEDIUM);
    ap.write(tr);
  endtask

endclass

`endif

