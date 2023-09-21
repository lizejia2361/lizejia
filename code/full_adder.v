module full_adder (
    input  wire  [2:0] cin ,// 输入：3位的输入信号，cin[2] 为最高位，cin[0]
    output wire        Cout,// 输出：进位信号
    output wire        S    // 输出：和
);
	// 计算和 S 的逻辑表达式
    assign S = (cin[0]&~cin[1]&~cin[2])  // A=0, B=0, Cin=0
				|(~cin[0]&cin[1]&~cin[2])// A=1, B=1, Cin=0
				|(~cin[0]&~cin[1]&cin[2])// A=1, B=0, Cin=1
				|(cin[0]&cin[1]&cin[2]); // A=0, B=0, Cin=1
	// 计算进位 Cout 的逻辑表达式
    assign Cout = cin[0]&cin[1]// A=0, B=0
				  |cin[0]&cin[2]// A=0, Cin=1
				  |cin[1]&cin[2];// B=0, Cin=1
endmodule