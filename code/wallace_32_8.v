`include "wallace_1_8.v"
// 导入所需的模块，wallace树压缩器
module wallace_32_8(
    // input wire [31:0]  xin[7:0] ,//booth编码后得到的8个部分积
    input wire [31:0]  xin0     ,	// 输入：第0部分积
    input wire [31:0]  xin1     ,	// 输入：第1部分积
    input wire [31:0]  xin2     ,	// 输入：第2部分积
    input wire [31:0]  xin3     ,	// 输入：第3部分积
    input wire [31:0]  xin4     ,	// 输入：第4部分积
    input wire [31:0]  xin5     ,	// 输入：第5部分积
    input wire [31:0]  xin6     ,	// 输入：第6部分积
    input wire [31:0]  xin7     ,	// 输入：第7部分积
    input wire [5:0]   cin      ,//32位数的wallace树最右侧的cin
    output wire [31:0] C        ,//32位数的wallace树最上面的输出进位C
    output wire [31:0] S        ,//32位数的wallace树最上面的输出结果S
    output wire [5:0]  cout      //32位数的wallace树最左侧的cout，被丢弃了，没用
);

wire [5:0] c_t[32:0];// 定义一个数组用于存储各级的进位信号
assign c_t[0] = cin[5:0];// 初始化数组的第一个元素为输入的最右侧进位
genvar j;
generate
    for(j=0; j<32; j=j+1)
    begin:wallace_1_8_loop
	// 实例化 wallace_1_8 模块
        wallace_1_8 u_wallace_1_8(
        	.N    ({xin7[j],xin6[j],xin5[j],xin4[j],xin3[j],xin2[j],xin1[j],xin0[j]}),
            .cin  (c_t[j]   ),
            .C    (C[j]     ),
            .S    (S[j]     ),
            .cout (c_t[j+1] )
        );
    end
endgenerate

assign cout = c_t[32];// 最终的进位输出

endmodule