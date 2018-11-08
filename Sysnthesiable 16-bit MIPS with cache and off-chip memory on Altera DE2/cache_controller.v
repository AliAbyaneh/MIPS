// Authors : Ali Abyaneh, Mahyar Emami
// Spring 2017, Computer Architecture

module cache_controller(opc, address, read_data, write_data_from_mem, write_data_from_core, hit, clk, rst, memory_stall);
  input [3:0] opc;
  input [15:0] address, write_data_from_mem, write_data_from_core;
  output [15:0] read_data;
  output hit, memory_stall;
  input clk, rst;

  wire [// Authors : Ali Abyaneh, Mahyar Emami
  // Spring 2017, Computer Architecture
7:0] index;
  assign index = address[7:0];
  wire [7:0] tag;
  assign tag = address[15:8];
  wire v1, v2;
  wire [7:0] t1, t2;
  //way 1 cache
  wire [15:0] write_data1, read_data1;
  wire write_en1;
  cache data_cache1(
                      .write_data(write_data1),
                      .read_data(read_data1),
                      .write_en(write_en1),
                      .clk(clk),
                      .address(index),
                      .rst(rst)
                    );
  //way 2 cache
  wire [15:0] write_data2, read_data2;
  wire write_en2;
  cache data_cache2(
                      .write_data(write_data2),
                      .read_data(read_data2),
                      .write_en(write_en2),
                      .clk(clk),
                      .address(index),
                      .rst(rst)
                    );
  //way 1 overhead
  wire [9:0] write_overhead1, read_overhead1;
  wire write_en_overhead1;
  wire [7:0] tag1;
  wire LRU1, valid1;
  assign tag1 = read_overhead1[7:0];
  assign {LRU1, valid1} = read_overhead1[9:8];
  cache #(.size(10)) cache_overhead1(
                                      .write_data(write_overhead1),
                                      .read_data(read_overhead1),
                                      .write_en(write_en_overhead1),
                                      .clk(clk),
                                      .address(index),
                                      .rst(rst)
                                    );
  //way 2 overhead
  wire [9:0] write_overhead2, read_overhead2;
  wire write_en_overhead2;
  wire [7:0] tag2;
  wire LRU2, valid2;
  assign tag2 = read_overhead2[7:0];
  assign {LRU2, valid2} = read_overhead2[9:8];
  cache #(.size(10)) cache_overhead2(
                                      .write_data(write_overhead2),
                                      .read_data(read_overhead2),
                                      .write_en(write_en_overhead2),
                                      .clk(clk),
                                      .address(index),
                                      .rst(rst)
                                    );
  wire hit1, hit2;
  assign hit1 = (tag1 == tag && valid1 == 1'b1) ? 1'b1 : 1'b0;
  assign hit2 = (tag2 == tag && valid2 == 1'b1) ? 1'b1 : 1'b0;
  assign read_data = (hit1 == 1'b1) ? read_data1 : (hit2 == 1'b1) ? read_data2 : 16'b0;
  //in case of ST operation assign hit to zero(always miss)
  assign hit = (opc == 4'b1010) ? hit1 | hit2 : 1'b0;
  assign write_en_overhead1 = 1'b1;
  assign write_en_overhead2 = 1'b1;
  assign write_overhead1 = (hit == 1'b1) ? {~hit1, valid1, tag1} : {LRU1, v1, t1};
  assign write_overhead2 = (hit == 1'b1) ? {~hit2, valid2, tag2} : {LRU2, v2, t2};

  wire access_en;
  assign access_en = ((opc == 4'b1010) || (opc == 4'b1011)) ? 1'b1 : 1'b0;
  reg [1:0] count;
  always @(posedge clk)
	begin
		if(rst)
		begin
			count = 2'b0;
		end
		else if(access_en && ~hit)
		begin
			count = count + 1;
		end
	end
  assign memory_stall = (access_en && ~hit && count != 2'b11 ) ? 1'b1 : 1'b0;
  assign write_en1 = (LRU1 == 1'b1 && count == 2'b11) ? 1'b1: 1'b0;
  assign write_en2 = (count == 2'b11) ? ~write_en1 : 1'b0;
  assign write_data1 = (opc == 4'b1010) ? write_data_from_mem: write_data_from_core;
  assign write_data2 = write_data1;
  assign v1 = (write_en1 == 1'b1 && valid1 != 1'b1) ? 1'b1 : valid1;
  assign v2 = (write_en2 == 1'b1 && valid2 != 1'b1) ? 1'b1 : valid2;
  assign t1 = (write_en1 == 1'b1) ? tag : tag1;
  assign t2 = (write_en2 == 1'b1) ? tag : tag2;
endmodule
