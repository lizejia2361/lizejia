module full_adder (
    input  wire  [2:0] cin ,// ���룺3λ�������źţ�cin[2] Ϊ���λ��cin[0]
    output wire        Cout,// �������λ�ź�
    output wire        S    // �������
);
	// ����� S ���߼����ʽ
    assign S = (cin[0]&~cin[1]&~cin[2])  // A=0, B=0, Cin=0
				|(~cin[0]&cin[1]&~cin[2])// A=1, B=1, Cin=0
				|(~cin[0]&~cin[1]&cin[2])// A=1, B=0, Cin=1
				|(cin[0]&cin[1]&cin[2]); // A=0, B=0, Cin=1
	// �����λ Cout ���߼����ʽ
    assign Cout = cin[0]&cin[1]// A=0, B=0
				  |cin[0]&cin[2]// A=0, Cin=1
				  |cin[1]&cin[2];// B=0, Cin=1
endmodule