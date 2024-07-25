module mult #(
    parameter width =18
) (
    input [width-1:0]dz,bx,output [2*width-1:0]out
);
    assign out=dz*bx;
endmodule