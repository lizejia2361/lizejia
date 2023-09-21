module adder4
(
input    wire          cin ,//输入，来自低位的进位信号
input    wire [3:0]    p   ,//p=a|b 进位传递因子（a或b对应位相加结果）
input    wire [3:0]    g   ,//g=a&b 进位生成因子（a和b对应位相加进位生成信号）
output   wire          G   ,//下一级的进位生成信号
output   wire          P   ,//下一级的进位传递信号
output   wire [2:0]    cout //每个位对应的进位输出信号
);

assign P=&p; // 下一级的进位传递信号等于对应位相加结果 p
assign G=g[3]|(p[3]&g[2])|(p[3]&p[2]&g[1])|(p[3]&p[2]&p[1]&g[0]); // 下一级的进位生成信号 G 计算方式
assign cout[0]=g[0]|(p[0]&cin); // 第 0 位的进位输出信号
assign cout[1]=g[1]|(p[1]&g[0])|(p[1]&p[0]&cin); // 第 1 位的进位输出信号
assign cout[2]=g[2]|(p[2]&g[1])|(p[2]&p[1]&g[0])|(p[2]&p[1]&p[0]&cin); // 第 2 位的进位输出信号
endmodule