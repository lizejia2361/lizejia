module Multply_Signed_Unsigned(
    input           [7:0]   dina,
    input signed    [7:0]   dinb,
    output signed   [15:0]   dout
    );

//wire    [15:0]  dout_r;

//assign  dout_r = dina * dinb;			//结果为无符号数
assign  dout =$signed(dina) * $signed(dinb);	//结果为有符号数

endmodule

