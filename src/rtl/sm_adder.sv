`timescale 1ns / 1ps

module sm_adder #(
    parameter int SIZE = 4
)(
    input  logic [SIZE-1:0] a,
    input  logic [SIZE-1:0] b,
    output logic [SIZE-1:0] s,
    output logic overflow
);
    logic sign_a, sign_b;
    logic [SIZE-2:0] num_a, num_b;
    
    logic a_gt_b;
    logic [SIZE-2:0] big_num, small_num;
    logic big_sign, same_sign;
    logic [SIZE-1:0] nums_sum_ext;
    logic [SIZE-2:0] res;
    logic res_sign;
    
    assign sign_a = a[SIZE-1];
    assign sign_b = b[SIZE-1];
    assign num_a  = a[SIZE-2:0];
    assign num_b  = b[SIZE-2:0];
    
    assign a_gt_b = (num_a >= num_b);
    assign big_num = a_gt_b ? num_a : num_b;
    assign small_num = a_gt_b ? num_b : num_a;
    assign big_sign = a_gt_b ? sign_a : sign_b;
    assign same_sign = (sign_a == sign_b);

    assign nums_sum_ext = {1'b0, num_a} + {1'b0, num_b};
    assign res = same_sign ? nums_sum_ext[SIZE-2:0] : (big_num - small_num);
    assign res_sign = same_sign ? sign_a : big_sign;
    assign overflow = (same_sign)? nums_sum_ext[SIZE-1] : 1'b0;
    assign s = (res == '0) ? '0 : {res_sign, res};
endmodule
