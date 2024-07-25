module mux2 #(
    parameter width=18
) (
    input [width-1:0]sel1,sel2,input sel,output reg [width-1:0] out
);
    always @(*) begin
        if (~sel) 
            out=sel1;
        else
            out=sel2;
    end
endmodule