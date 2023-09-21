module booth_decoder (
    input  wire [15:0] xin ,  // 输入：乘数 x
    input  wire [2:0]  yin ,  // 输入：控制信号 y，3位
    output wire        cout, // 输出：是否"加一"
    output wire [16:0] xout  // 输出：Booth编码后的部分积
);

    // 对于控制信号 y 的各种情况，定义不同的情况

    wire x_add1 = (~yin[2] & ~yin[1] & yin[0]) | (~yin[2] & yin[1] & ~yin[0]);
    // 当 y = 001 时，相当于 (not y[2]) and (not y[1]) and y[0]

    wire x_add2 = (~yin[2] & yin[1] & yin[0]);
    // 当 y = 010 时，相当于 (not y[2]) and y[1] and y[0]

    wire x_sub2 = (yin[2] & ~yin[1] & ~yin[0]);
    // 当 y = 100 时，相当于 y[2] and (not y[1]) and (not y[0])

    wire x_sub1 = (yin[2] & ~yin[1] & yin[0]) | (yin[2] & yin[1] & ~yin[0]);
    // 当 y = 101 时，相当于 y[2] and (not y[1]) and y[0] 或者 y[2] and y[1] and (not y[0])

    // 根据不同的情况，选择对应的部分积
    assign xout = {17{x_add1}} & {xin[15], xin} // 加法为正数，符号位为0
                | {17{x_add2}} & {xin[15:0], 1'b0}
                | {17{x_sub1}} & {~xin[15], ~xin}  // 减法需要进行"取反加一"操作
                | {17{x_sub2}} & ({~xin[15:0], 1'b1}) 
                ;

    // 根据不同的情况，指示是否需要在结果上加1
    assign cout = x_sub1 | x_sub2;

endmodule
