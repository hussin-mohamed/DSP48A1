module adder #(
    parameter width =18
) (
    input [width-1:0]dz,bx,input op,cin,output reg[width-1:0]out,output reg cout
);
    always @(*) begin
        if(~op)
        {cout,out}=dz+bx+cin;
        else
        {cout,out}=dz-(bx+cin);
    end
endmodule