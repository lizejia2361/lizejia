module mul_tc_16_16_ref(a, b, p);
    input signed[15:0] a, b;      // ���룺����16λ�з����� a �� b
    output signed[31:0] p;        // �����32λ�з��ų˻� p
    assign p = a * b;             // �������� a �� b ��ˣ�����洢�� p ��
endmodule
