module multiplier_2x2 (
    input wire [1:0] A, // 2位输入A
    input wire [1:0] B, // 2位输入B
    output reg [3:0] P // 4位输出P
);

  

    always @ (*) begin
        P = A * B; // 乘法操作
    end

endmodule

