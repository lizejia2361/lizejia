`include "full_adder.v"
`include "half_adder.v"
// 导入所需的模块,全加器和半加器
module wallace_1_8(
    input   [7: 0]     N   ,// N个1bit数进行压缩(拥有相同的权重)
    input   [5: 0]     cin ,// 来自右侧的进位(index大的在高层)
    output             C   ,// 最后一级计算的C
    output             S   ,// 最后一级计算的S
    output  [5: 0]     cout // 传递到左侧的进位
);
    // layer 1
    wire [5: 0]    layer_2_in;// 第二层的输入
	 // 实例化第一层的各个加法器模块
    full_adder u_adder_l1_1(.cin(N[7-:3]),.Cout(cout[0]),.S(layer_2_in[5]));
    full_adder u_adder_l1_2(.cin(N[4-:3]),.Cout(cout[1]),.S(layer_2_in[4]));
    half_adder u_adder_l1_3(.cin(N[1-:2]),.Cout(cout[2]),.S(layer_2_in[3]));
	// 将进位传递到第二层的输入
    assign layer_2_in[2:0] = {cin[0],cin[1],cin[2]};

    // layer 2
    wire [3:0]    layer_3_in;// 第三层的输入
	// 实例化第二层的各个加法器模块
    full_adder u_adder_l2_1(.cin(layer_2_in[5-:3]),.Cout(cout[3]),.S(layer_3_in[3]));
    full_adder u_adder_l2_2(.cin(layer_2_in[2-:3]),.Cout(cout[4]),.S(layer_3_in[2]));
	// 将进位传递到第三层的输入
    assign layer_3_in[1:0] = {cin[3],cin[4]};
    
    // layer 3
    wire [2:0]    layer_4_in;// 第四层的输入
	// 实例化第三层的各个加法器模块
    full_adder u_adder_l3_1(.cin({layer_3_in[3-:2],cin[3]}),.Cout(cout[5]),.S(layer_4_in[2]));
	// 将进位传递到第四层的输入
    assign layer_4_in[1:0] = {layer_3_in[0],cin[5]};

    // layer 4 实例化第四层的加法器模块
    full_adder u_adder_l4_1(.cin(layer_4_in[2-:3]),.Cout(C      ),.S(S            ));

endmodule