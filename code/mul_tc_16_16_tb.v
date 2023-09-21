// 导入需要测试的模块
`include "mul_tc_16_16.v"
`include "mul_tc_16_16_ref.v"

// 设置默认的网络类型为 none
`default_nettype none

// 定义测试台模块
module mul_tc_16_16_tb;
    parameter TCLK = 10;  // 定义时钟周期

    reg [15:0]  a;       // 输入 a
    reg [15:0]  b;       // 输入 b
    wire [31:0] product; // 乘法器的输出
    wire [31:0] p;       // 参考乘法器的输出

    // 初始块，用于生成输入信号并执行测试
    initial
    begin
        // 重复20次测试
        repeat(20)
        begin
            a = {$random}%17'h10000;  // 生成一个随机的16位数作为输入 a
            b = {$random}%17'h10000;  // 生成一个随机的16位数作为输入 b
            # TCLK ;  // 等待一个时钟周期
        end
        $finish;  // 完成测试
    end

    // 实例化参考乘法器
    mul_tc_16_16_ref u_mul_tc_16_16_ref(
        .a (a ),
        .b (b ),
        .p (p )
    );

    // 实例化待测试的乘法器
    mul_tc_16_16 u_mul_tc_16_16(
        .a       (a       ),
        .b       (b       ),
        .product (product )
    );

endmodule

// 设置默认的网络类型为 wire
`default_nettype wire
