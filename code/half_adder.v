module half_adder (
    input  wire [1:0]  cin ,// ���룺2λ�������źţ�cin[1] Ϊ��λ��cin[0] Ϊ��λ
    output wire        Cout,// �������λ�ź�
    output wire        S    // �������
);
    assign S    = (cin[0]&~cin[1])|(~cin[0]&cin[1]); // ����� S ���߼����ʽ
    assign Cout = cin[0]&cin[1];// �����λ Cout ���߼����ʽ
endmodule