`timescale 1ns / 1ps
module sm_adder_tb;

    parameter int SIZE = 4;

    logic [SIZE-1:0] a;
    logic [SIZE-1:0] b;
    logic [SIZE-1:0] s;
    logic overflow;

    sm_adder #(
        .SIZE(SIZE)
    ) dut (
        .a(a),
        .b(b),
        .s(s),
        .overflow(overflow)
    );

    task check_result(
        input logic [SIZE-1:0] test_a,
        input logic [SIZE-1:0] test_b,
        input logic [SIZE-1:0] expected_s,
        input logic expected_overflow,
        input string test_name
    );
    begin
        a = test_a;
        b = test_b;
        #1;

        if (s !== expected_s || overflow !== expected_overflow) begin
            $display("ERROR in %s", test_name);
            $display("a = %b, b = %b", a, b);
            $display("expected: s = %b, overflow = %b", expected_s, expected_overflow);
            $display("actual:   s = %b, overflow = %b", s, overflow);
        end
        else begin
            $display("OK: %s", test_name);
        end
    end
    endtask

    initial begin
        check_result(4'b0011, 4'b0010, 4'b0101, 1'b0, "+3 + +2 = +5");
        check_result(4'b1011, 4'b1010, 4'b1101, 1'b0, "-3 + -2 = -5");
        check_result(4'b0101, 4'b1011, 4'b0010, 1'b0, "+5 + -3 = +2");
        check_result(4'b1101, 4'b0011, 4'b1010, 1'b0, "-5 + +3 = -2");
        check_result(4'b0011, 4'b1011, 4'b0000, 1'b0, "+3 + -3 = +0");
        check_result(4'b1011, 4'b0011, 4'b0000, 1'b0, "-3 + +3 = +0");
        check_result(4'b1000, 4'b0000, 4'b0000, 1'b0, "-0 + +0 = +0");
        check_result(4'b1000, 4'b1000, 4'b0000, 1'b0, "-0 + -0 = +0");
        check_result(4'b0111, 4'b0001, 4'b0000, 1'b1, "+7 + +1 overflow");
        check_result(4'b1111, 4'b1001, 4'b0000, 1'b1, "-7 + -1 overflow");

        $finish;
    end

endmodule
