module dffsync #(
    parameter width =18 
) (
    input [width-1:0]d,input clk , enable , rst , output reg [width-1:0]q
);
    always @(posedge clk ) begin
        if(rst)
        q<=0;
        else
        if(enable)
        q<=d;
    end

endmodule