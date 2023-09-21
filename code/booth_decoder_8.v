// 导入所需的模块
`include "booth_decoder.v"

module booth_decoder_8 (
    input  wire [15:0] xin       ,  // 输入：乘数 x
    input  wire [15:0] yin       ,  // 输入：乘数 y，依序取其3bit进行译码得到booth编码的选择信号
    output wire [7:0]  cout      ,  // 输出：是否"加一"
    output wire [31:0] xout0     ,  // 输出：Booth编码后的部分积
    output wire [31:0] xout1     ,  // 输出：Booth编码后的部分积
    output wire [31:0] xout2     ,  // 输出：Booth编码后的部分积
    output wire [31:0] xout3     ,  // 输出：Booth编码后的部分积
    output wire [31:0] xout4     ,  // 输出：Booth编码后的部分积
    output wire [31:0] xout5     ,  // 输出：Booth编码后的部分积
    output wire [31:0] xout6     ,  // 输出：Booth编码后的部分积
    output wire [31:0] xout7      // 输出：Booth编码后的部分积
);

    wire [31:0] xout[7:0];  // 定义一个数组用于存储8个部分积

    assign xout0 = xout[0];  // 分配第一个部分积输出
    assign xout1 = xout[1];  // 分配第二个部分积输出
    assign xout2 = xout[2];  // 分配第三个部分积输出
    assign xout3 = xout[3];  // 分配第四个部分积输出
    assign xout4 = xout[4];  // 分配第五个部分积输出
    assign xout5 = xout[5];  // 分配第六个部分积输出
    assign xout6 = xout[6];  // 分配第七个部分积输出
    assign xout7 = xout[7];  // 分配第八个部分积输出

    wire [16:0] yin_t = {yin,1'b0};  // 对 yin 进行扩展，以便在 booth_decoder 中使用
    wire [16:0] xout_t[7:0];  // 定义一个数组用于存储8个 booth_decoder 模块的输出

    genvar j;
    generate
        for(j=0; j<8; j=j+1)
        begin : booth_decoder_loop
            // 实例化 booth_decoder 模块
            booth_decoder u_booth_decoder(
                .xin  (xin  ),
                .yin  (yin_t[(j+1)*2-:3]),
                .xout (xout_t[j]),
                .cout (cout[j] )
            );
            assign xout[j]={{(15-j*2){xout_t[j][16]}},xout_t[j],{(j*2){cout[j]}}};
            // 对输出进行处理，低位默认是0，负数的话，进行取反
        end
    endgenerate
endmodule
