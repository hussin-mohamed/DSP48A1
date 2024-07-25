module dffmux #(
    parameter width =18 ,RSTTYPE="SYNC",REGG=0
) (
    input [width-1:0]d,input clk , enable , rst , output[width-1:0]q
);
    
    generate
        if(REGG)
        begin
        if(RSTTYPE=="SYNC")
        dffsync  #(width) sync(d,clk,enable,rst,q);
        else if (RSTTYPE=="ASYNC")
        dffasync  #(width) async(d,clk,enable,rst,q);
        end
        else
        assign q=d;
    endgenerate
    
endmodule