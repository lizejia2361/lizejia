`include "adder4.v"// 导入4位加法器模块
module adder32(
    input  wire [31:0]  a   ,//输入数据a，二进制补码
    input  wire [31:0]  b   ,//输入数据b，二进制补码
    input  wire         cin ,//来自低位的进位输入
    output wire [31:0]  out ,//输出和a + b，二进制补码（不包含最高位的进位）
    output wire         cout //输出和a + b，的进位
);



// level1
wire [31:0] p1 = a|b;// 计算p1：对应位的 a 或 b 的结果
wire [31:0] g1 = a&b;// 计算g1：对应位的 a 和 b 的进位生成信号
wire [31:0] c;//每一位的进位输出
wire [7:0] p2, g2;// p2 和 g2 用于 level2
wire [1:0] p3, g3;// p3 和 g3 用于 level3
assign c[0] = cin;// 第 0 位的进位输入等于来自低位的进位信号

genvar j;
// 生成8个 4位加法器实例用于 level1
generate
 // 实例化 4位加法器，每个实例处理 4 个位的加法
    for (j = 0; j<8; j=j+1) begin
        adder4 u_adder4_l1 (
		.p(p1[(4*j+3)-:4]),// 输入 p1 中的 4 位，对应于 4 个位的 a 或 b 的结果
		.g(g1[(4*j+3)-:4]),// 输入 g1 中的 4 位，对应于 4 个位的 a 和 b 的进位生成信号
		.cin(c[j*4]),// 输入进位信号，每个实例接收来自前一级的进位输出
		.P(p2[j]),// 输出进位传递信号到下一级
		.G(g2[j]),// 输出进位生成信号到下一级
		.cout(c[(4*j+3)-:3])// 输出每个 4 位的进位输出
		);
    end
endgenerate

// level2
generate
// 实例化 4位加法器，每个实例处理 16 个位中的 4 位加法
    for (j = 0; j<2; j=j+1) begin
        adder4 u_adder4_l2 (
		.p(p2[(4*j+3)-:4]),// 输入 p2 中的 4 位，对应于 16 个位的 a 或 b 的结果
		.g(g2[(4*j+3)-:4]),// 输入 g2 中的 4 位，对应于 16 个位的 a 和 b 的进位生成信号
		.cin(c[j*16]),// 输入进位信号，每个实例接收来自前一级的进位输出
		.P(p3[j]),// 输出进位传递信号到下一级
		.G(g3[j]),// 输出进位生成信号到下一级
		.cout({c[j*16+12],c[j*16+8],c[j*16+4]})// 输出每个 16 位的进位输出
		);
    end
endgenerate

// level3
assign c[16]=g3[0]|(p3[0]&c[0]); // 计算 level3 的进位输出，这是最高级别的进位，即最高位的进位

// 得到进位后计算加法和( 计算最终的和和进位)
assign cout = (a[31]&b[31]) | (a[31]&c[31]) | (b[31]&c[31]);
assign out = (~a&~b&c)|(~a&b&~c)|(a&~b&~c)|(a&b&c);

endmodule