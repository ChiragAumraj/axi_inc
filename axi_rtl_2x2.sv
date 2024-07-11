//===== AXI4 2x2 interconnect (wrapper) =====//
`ifndef AWIDTH
  `define  ADDR_WIDTH       64
`endif
`ifndef DWIDTH
  `define  DATA_WIDTH       128
`endif
`ifndef IDWIDTH
  `define  ID_WIDTH      4
`endif


module axi_rtl_2x2 #
(   parameter DATA_WIDTH = `DATA_WIDTH,
    parameter ADDR_WIDTH = `ADDR_WIDTH,
    parameter STRB_WIDTH = (DATA_WIDTH/8),
    parameter ID_WIDTH = `ID_WIDTH,
    parameter AWUSER_ENABLE = 0,
    parameter AWUSER_WIDTH = 1,
    parameter WUSER_ENABLE = 0,
    parameter WUSER_WIDTH = 1,
    parameter BUSER_ENABLE = 0,
    parameter BUSER_WIDTH = 1,
    parameter ARUSER_ENABLE = 0,
    parameter ARUSER_WIDTH = 1,
    parameter RUSER_ENABLE = 0,
    parameter RUSER_WIDTH = 1,
    parameter FORWARD_ID = 0,
    parameter M_REGIONS = 1,
    parameter M00_BASE_ADDR = 0,
    parameter M00_ADDR_WIDTH = {M_REGIONS{32'd24}},
    parameter M00_CONNECT_READ = 2'b11,
    parameter M00_CONNECT_WRITE = 2'b11,
    parameter M00_SECURE = 1'b0,
    parameter M01_BASE_ADDR = 0,
    parameter M01_ADDR_WIDTH = {M_REGIONS{32'd24}},
    parameter M01_CONNECT_READ = 2'b11,
    parameter M01_CONNECT_WRITE = 2'b11,
    parameter M01_SECURE = 1'b0
)
(
    input  logic aclk,
    input  logic aresetn,
    axi_if m1_intf,
    axi_if m2_intf,
    axi_if s1_intf,
    axi_if s2_intf

);

localparam S_COUNT = 2;
localparam M_COUNT = 2;

// parameter sizing helpers
function [ADDR_WIDTH*M_REGIONS-1:0] w_a_r(input [ADDR_WIDTH*M_REGIONS-1:0] val);
    w_a_r = val;
endfunction

function [32*M_REGIONS-1:0] w_32_r(input [32*M_REGIONS-1:0] val);
    w_32_r = val;
endfunction

function [S_COUNT-1:0] w_s(input [S_COUNT-1:0] val);
    w_s = val;
endfunction

function w_1(input val);
    w_1 = val;
endfunction

axi_interconnect #(
    .S_COUNT(S_COUNT),
    .M_COUNT(M_COUNT),
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .STRB_WIDTH(STRB_WIDTH),
    .ID_WIDTH(ID_WIDTH),
    .M_BASE_ADDR({ w_a_r(M01_BASE_ADDR), w_a_r(M00_BASE_ADDR) }),
    .M_ADDR_WIDTH({ w_32_r(M01_ADDR_WIDTH), w_32_r(M00_ADDR_WIDTH) }),
    .M_CONNECT_READ({ w_s(M01_CONNECT_READ), w_s(M00_CONNECT_READ) }),
    .M_CONNECT_WRITE({ w_s(M01_CONNECT_WRITE), w_s(M00_CONNECT_WRITE) }),
    .M_SECURE({ w_1(M01_SECURE), w_1(M00_SECURE) })
) inc_2x2 (
    .clk(aclk),
    .rst(!aresetn),
    .s_axi_awid({ m2_intf.awid, m1_intf.awid }),
    .s_axi_awaddr({ m2_intf.awaddr, m1_intf.awaddr }),
    .s_axi_awlen({ m2_intf.awlen, m1_intf.awlen }),
    .s_axi_awsize({ m2_intf.awsize, m1_intf.awsize }),
    .s_axi_awburst({ m2_intf.awburst, m1_intf.awburst }),
    .s_axi_awlock({ m2_intf.awlock, m1_intf.awlock }),
    .s_axi_awcache({ m2_intf.awcache, m1_intf.awcache }),
    .s_axi_awprot({ m2_intf.awprot, m1_intf.awprot }),
    .s_axi_awqos({ m2_intf.awqos, m1_intf.awqos }),
    .s_axi_awuser({ m2_intf.awuser, m1_intf.awuser }),
    .s_axi_awvalid({ m2_intf.awvalid, m1_intf.awvalid }),
    .s_axi_awready({ m2_intf.awready, m1_intf.awready }),
    .s_axi_wdata({ m2_intf.wdata, m1_intf.wdata }),
    .s_axi_wstrb({ m2_intf.wstrb, m1_intf.wstrb }),
    .s_axi_wlast({ m2_intf.wlast, m1_intf.wlast }),
    .s_axi_wuser({ m2_intf.wuser, m1_intf.wuser }),
    .s_axi_wvalid({ m2_intf.wvalid, m1_intf.wvalid }),
    .s_axi_wready({ m2_intf.wready, m1_intf.wready }),
    .s_axi_bid({ m2_intf.bid, m1_intf.bid }),
    .s_axi_bresp({ m2_intf.bresp, m1_intf.bresp }),
    .s_axi_buser({ m2_intf.buser, m1_intf.buser }),
    .s_axi_bvalid({ m2_intf.bvalid, m1_intf.bvalid }),
    .s_axi_bready({ m2_intf.bready, m1_intf.bready }),
    .s_axi_arid({ m2_intf.arid, m1_intf.arid }),
    .s_axi_araddr({ m2_intf.araddr, m1_intf.araddr }),
    .s_axi_arlen({ m2_intf.arlen, m1_intf.arlen }),
    .s_axi_arsize({ m2_intf.arsize, m1_intf.arsize }),
    .s_axi_arburst({ m2_intf.arburst, m1_intf.arburst }),
    .s_axi_arlock({ m2_intf.arlock, m1_intf.arlock }),
    .s_axi_arcache({ m2_intf.arcache, m1_intf.arcache }),
    .s_axi_arprot({ m2_intf.arprot, m1_intf.arprot }),
    .s_axi_arqos({ m2_intf.arqos, m1_intf.arqos }),
    .s_axi_aruser({ m2_intf.aruser, m1_intf.aruser }),
    .s_axi_arvalid({ m2_intf.arvalid, m1_intf.arvalid }),
    .s_axi_arready({ m2_intf.arready, m1_intf.arready }),
    .s_axi_rid({ m2_intf.rid, m1_intf.rid }),
    .s_axi_rdata({ m2_intf.rdata, m1_intf.rdata }),
    .s_axi_rresp({ m2_intf.rresp, m1_intf.rresp }),
    .s_axi_rlast({ m2_intf.rlast, m1_intf.rlast }),
    .s_axi_ruser({ m2_intf.ruser, m1_intf.ruser }),
    .s_axi_rvalid({ m2_intf.rvalid, m1_intf.rvalid }),
    .s_axi_rready({ m2_intf.rready, m1_intf.rready }),

    .m_axi_awid({ s2_intf.awid, s1_intf.awid }),
    .m_axi_awaddr({ s2_intf.awaddr, s1_intf.awaddr }),
    .m_axi_awlen({ s2_intf.awlen, s1_intf.awlen }),
    .m_axi_awsize({ s2_intf.awsize, s1_intf.awsize }),
    .m_axi_awburst({ s2_intf.awburst, s1_intf.awburst }),
    .m_axi_awlock({ s2_intf.awlock, s1_intf.awlock }),
    .m_axi_awcache({ s2_intf.awcache, s1_intf.awcache }),
    .m_axi_awprot({ s2_intf.awprot, s1_intf.awprot }),
    .m_axi_awqos({ s2_intf.awqos, s1_intf.awqos }),
    .m_axi_awregion({ s2_intf.awregion, s1_intf.awregion }),
    .m_axi_awuser({ s2_intf.awuser, s1_intf.awuser }),
    .m_axi_awvalid({ s2_intf.awvalid, s1_intf.awvalid }),
    .m_axi_awready({ s2_intf.awready, s1_intf.awready }),
    .m_axi_wdata({ s2_intf.wdata, s1_intf.wdata }),
    .m_axi_wstrb({ s2_intf.wstrb, s1_intf.wstrb }),
    .m_axi_wlast({ s2_intf.wlast, s1_intf.wlast }),
    .m_axi_wuser({ s2_intf.wuser, s1_intf.wuser }),
    .m_axi_wvalid({ s2_intf.wvalid, s1_intf.wvalid }),
    .m_axi_wready({ s2_intf.wready, s1_intf.wready }),
    .m_axi_bid({ s2_intf.bid, s1_intf.bid }),
    .m_axi_bresp({ s2_intf.bresp, s1_intf.bresp }),
    .m_axi_buser({ s2_intf.buser, s1_intf.buser }),
    .m_axi_bvalid({ s2_intf.bvalid, s1_intf.bvalid }),
    .m_axi_bready({ s2_intf.bready, s1_intf.bready }),
    .m_axi_arid({ s2_intf.arid, s1_intf.arid }),
    .m_axi_araddr({ s2_intf.araddr, s1_intf.araddr }),
    .m_axi_arlen({ s2_intf.arlen, s1_intf.arlen }),
    .m_axi_arsize({ s2_intf.arsize, s1_intf.arsize }),
    .m_axi_arburst({ s2_intf.arburst, s1_intf.arburst }),
    .m_axi_arlock({ s2_intf.arlock, s1_intf.arlock }),
    .m_axi_arcache({ s2_intf.arcache, s1_intf.arcache }),
    .m_axi_arprot({ s2_intf.arprot, s1_intf.arprot }),
    .m_axi_arqos({ s2_intf.arqos, s1_intf.arqos }),
    .m_axi_arregion({ s2_intf.arregion, s1_intf.arregion }),
    .m_axi_aruser({ s2_intf.aruser, s1_intf.aruser }),
    .m_axi_arvalid({ s2_intf.arvalid, s1_intf.arvalid }),
    .m_axi_arready({ s2_intf.arready, s1_intf.arready }),
    .m_axi_rid({ s2_intf.rid, s1_intf.rid }),
    .m_axi_rdata({ s2_intf.rdata, s1_intf.rdata }),
    .m_axi_rresp({ s2_intf.rresp, s1_intf.rresp }),
    .m_axi_rlast({ s2_intf.rlast, s1_intf.rlast }),
    .m_axi_ruser({ s2_intf.ruser, s1_intf.ruser }),
    .m_axi_rvalid({ s2_intf.rvalid, s1_intf.rvalid }),
    .m_axi_rready({ s2_intf.rready, s1_intf.rready })
);

assign s1_intf.arregion    = 0;
assign s1_intf.aruser      = 0;
assign s1_intf.awregion    = 0;
assign s1_intf.awuser      = 0; 
assign s1_intf.wuser       = 0;

assign s2_intf.arregion    = 0;
assign s2_intf.aruser      = 0;
assign s2_intf.awregion    = 0;
assign s2_intf.awuser      = 0; 
assign s2_intf.wuser       = 0;

endmodule
