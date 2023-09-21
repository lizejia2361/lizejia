module half_adder (
    input  wire [1:0]  cin ,// 输入：2位的输入信号，cin[1] 为高位，cin[0] 为低位
    output wire        Cout,// 输出：进位信号
    output wire        S    // 输出：和
);
    assign S    = (cin[0]&~cin[1])|(~cin[0]&cin[1]); // 计算和 S 的逻辑表达式
    assign Cout = cin[0]&cin[1];// 计算进位 Cout 的逻辑表达式
endmodule