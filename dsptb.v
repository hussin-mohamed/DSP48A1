module dsptb ();
    parameter datainwidth=18,dataoutwidth=48,opwidth=8;
    reg[datainwidth-1:0]d,b,bcin,a;
    reg clk,carryin;
    reg[dataoutwidth-1:0]c,pcin;
    reg[opwidth-1:0]opmode;
    wire[2*datainwidth-1:0]m;
    wire[dataoutwidth-1:0]pcout,p;
    wire carryout,carryoutf;
    wire[datainwidth-1:0]bcout;
    reg cea,ceb,cem,cep,cec,ced,cecarryin,ceopmode,rsta,rstb,rstm,rstp,rstc,rstd,rstcarryin,rstopmode;
    dsptop dsp(d,b,bcin,a,clk,carryin,c,pcin,opmode,m,pcout,p,carryout,carryoutf,bcout,cea,ceb,cem,cep,cec,ced,cecarryin,ceopmode,rsta,rstb,rstm,rstp,rstc,rstd,rstcarryin,rstopmode);
    initial begin
        clk=1;
        forever begin
            #5
            clk=~clk;
        end
    end
    initial begin
        cea=1;ceb=1;cem=1;cep=1;cec=1;ced=1;cecarryin=1;ceopmode=1;rsta=0;rstb=0;rstm=0;rstp=0;rstc=0;rstd=0;rstcarryin=0;rstopmode=0;
        d=20;
        b=12;
        bcin=18;
        a=15;
        c=32;
        carryin=1;
        pcin=48;
        opmode[7]=1;
        opmode[5]=1;
        opmode[6]=1;
        opmode[4]=0;
        opmode[1:0]=0;
        opmode[3:2]=0;
        repeat(5)
        @(negedge clk);
        opmode[4]=1;
        repeat(5)
        @(negedge clk);
        opmode[6]=0;
        opmode[7]=0;
        repeat(5)
        @(negedge clk);
        opmode[1:0]=1;
        opmode[3:2]=1;
        repeat(5)
        @(negedge clk);
        opmode[1:0]=2;
        opmode[3:2]=2;
        repeat(5)
        @(negedge clk);
        opmode[4]=1;
        opmode[1:0]=3;
        opmode[3:2]=3;
        repeat(5)
        @(negedge clk);
        $stop;
    end
endmodule