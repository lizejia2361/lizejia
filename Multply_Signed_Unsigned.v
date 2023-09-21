module Multply_Signed_Unsigned(
    input           [7:0]   dina,
    input signed    [7:0]   dinb,
    output signed   [15:0]   dout
    );

//wire    [15:0]  dout_r;

//assign  dout_r = dina * dinb;			//���Ϊ�޷�����
assign  dout =$signed(dina) * $signed(dinb);	//���Ϊ�з�����

endmodule

