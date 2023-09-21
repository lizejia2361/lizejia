module mul_tc_16_16_ref(a, b, p);
    input signed[15:0] a, b;      // 输入：两个16位有符号数 a 和 b
    output signed[31:0] p;        // 输出：32位有符号乘积 p
    assign p = a * b;             // 将输入数 a 和 b 相乘，结果存储在 p 中
endmodule
