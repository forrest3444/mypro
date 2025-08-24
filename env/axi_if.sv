`ifndef AXI_IF_SV
`define AXI_IF_SV

interface axi_if #(
  parameter ADDR_WIDTH = 16,
  parameter DATA_WIDTH = 32,
  parameter ID_WIDTH   = 8,
	parameter STRB_WIDTH = DATA_WIDTH/8
) (
  input  logic clk,
  input  logic rst_n
);

  // ----------------------------
  // 写地址通道 (AW)
  // ----------------------------
  logic [ID_WIDTH-1:0]      awid;
  logic [ADDR_WIDTH-1:0]    awaddr;
  logic [7:0]               awlen;     // burst length
  logic [2:0]               awsize;    // burst size
  logic [1:0]               awburst;   // burst type
  logic                     awvalid;
  logic                     awready;

  // ----------------------------
  // 写数据通道 (W)
  // ----------------------------
  logic [DATA_WIDTH-1:0]    wdata;
  logic [STRB_WIDTH-1:0]    wstrb;
  logic                     wlast;
  logic                     wvalid;
  logic                     wready;

  // ----------------------------
  // 写响应通道 (B)
  // ----------------------------
  logic [ID_WIDTH-1:0]      bid;
  logic [1:0]               bresp;
  logic                     bvalid;
  logic                     bready;

  // ----------------------------
  // 读地址通道 (AR)
  // ----------------------------
  logic [ID_WIDTH-1:0]      arid;
  logic [ADDR_WIDTH-1:0]    araddr;
  logic [7:0]               arlen;
  logic [2:0]               arsize;
  logic [1:0]               arburst;
  logic                     arvalid;
  logic                     arready;

  // ----------------------------
  // 读数据通道 (R)
  // ----------------------------
  logic [ID_WIDTH-1:0]      rid;
  logic [DATA_WIDTH-1:0]    rdata;
  logic [1:0]               rresp;
  logic                     rlast;
  logic                     rvalid;
  logic                     rready;

  // ----------------------------
  // clocking block
  // ----------------------------
  clocking cb @(posedge clk);
    default input #1step output #1step;

    // 写地址
    output awid, awaddr, awlen, awsize, awburst, awvalid;
    input  awready;

    // 写数据
    output wdata, wstrb, wlast, wvalid;
    input  wready;

    // 写响应
    input  bid, bresp, bvalid;
    output bready;

    // 读地址
    output arid, araddr, arlen, arsize, arburst, arvalid;
    input  arready;

    // 读数据
    input  rid, rdata, rresp, rlast, rvalid;
    output rready;
  endclocking

  // ----------------------------
  // modport 定义
  // ----------------------------

  // DUT 是 Slave
  modport DUT (
    input  awid, awaddr, awlen, awsize, awburst, awvalid,
    output awready,

    input  wdata, wstrb, wlast, wvalid,
    output wready,

    output bid, bresp, bvalid,
    input  bready,

    input  arid, araddr, arlen, arsize, arburst, arvalid,
    output arready,

    output rid, rdata, rresp, rlast, rvalid,
    input  rready
  );

  // TB/UVM 是 Master
  modport TB (
    clocking cb
  );
	
	clocking mon @(posedge clk);
		default input #1step output #1step;

    input  awid, awaddr, awlen, awsize, awburst, awvalid;
    input  awready;

    input  wdata, wstrb, wlast, wvalid;
    input  wready;

    input  bid, bresp, bvalid;
    input  bready;

    input  arid, araddr, arlen, arsize, arburst, arvalid;
    input  arready;

    input  rid, rdata, rresp, rlast, rvalid;
    input  rready;

	endclocking
	

	modport MON (
		clocking mon
		);

endinterface

`endif
