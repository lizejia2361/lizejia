module multiplier_2x2 (
    input wire [1:0] A, // 2λ����A
    input wire [1:0] B, // 2λ����B
    output reg [3:0] P // 4λ���P
);

  

    always @ (*) begin
        P = A * B; // �˷�����
    end

endmodule

