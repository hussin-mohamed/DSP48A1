module mux4 #(
    parameter width=48
) (
    input [width-1:0]sel1,sel2,sel3,sel4,input[1:0] sel,output [width-1:0] out
);
    wire [width-1:0] mux1out,mux2out;
    mux2#(width) mux(sel1,sel2,sel[0],mux1out);
    mux2#(width) muxx(sel3,sel4,sel[0],mux2out);
    mux2#(width) muxxx(mux1out,mux2out,sel[1],out);
endmodule