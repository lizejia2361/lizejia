// ������Ҫ���Ե�ģ��
`include "mul_tc_16_16.v"
`include "mul_tc_16_16_ref.v"

// ����Ĭ�ϵ���������Ϊ none
`default_nettype none

// �������̨ģ��
module mul_tc_16_16_tb;
    parameter TCLK = 10;  // ����ʱ������

    reg [15:0]  a;       // ���� a
    reg [15:0]  b;       // ���� b
    wire [31:0] product; // �˷��������
    wire [31:0] p;       // �ο��˷��������

    // ��ʼ�飬�������������źŲ�ִ�в���
    initial
    begin
        // �ظ�20�β���
        repeat(20)
        begin
            a = {$random}%17'h10000;  // ����һ�������16λ����Ϊ���� a
            b = {$random}%17'h10000;  // ����һ�������16λ����Ϊ���� b
            # TCLK ;  // �ȴ�һ��ʱ������
        end
        $finish;  // ��ɲ���
    end

    // ʵ�����ο��˷���
    mul_tc_16_16_ref u_mul_tc_16_16_ref(
        .a (a ),
        .b (b ),
        .p (p )
    );

    // ʵ���������Եĳ˷���
    mul_tc_16_16 u_mul_tc_16_16(
        .a       (a       ),
        .b       (b       ),
        .product (product )
    );

endmodule

// ����Ĭ�ϵ���������Ϊ wire
`default_nettype wire
