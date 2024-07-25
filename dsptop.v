module dsptop #(
    parameter datainwidth=18,dataoutwidth=48,opwidth=8,A0REG=0,A1REG=1,B0REG=0,B1REG=1,CREG=1,DREG=1,MREG=1,PREG=1,CARRYINREG=1,CARRYOUTREG=1,OPMODEREG=1,CARRYINSEL="OPMODE5",B_INPUT="DIRECT",RSTTYPE="SYNC"
) (
    input[datainwidth-1:0]d,b,bcin,a,input clk,carryin,input[dataoutwidth-1:0]c,pcin,input[opwidth-1:0]opmode,output[2*datainwidth-1:0]m,output[dataoutwidth-1:0]pcout,p,output carryout,carryoutf,output[datainwidth-1:0]bcout,input cea,ceb,cem,cep,cec,ced,cecarryin,ceopmode,rsta,rstb,rstm,rstp,rstc,rstd,rstcarryin,rstopmode
);
    //wiredefinition
    wire[datainwidth-1:0]dready,b0ready,b1ready,a0ready,a1ready,preadderin1,preadderin2,preadderout,mux1out;
    reg[datainwidth-1:0]_0b0ready;
    reg cin0ready;
    wire[opwidth-1:0]opready;
    wire [2*datainwidth-1:0]mnotready;
    wire [dataoutwidth-1:0]muxxin0,muxxin1,muxzout,muxxout,pnotready,cready;
    wire preaddercout,cinready,coutnotready;
    //choose b or bcout and carryin or pcin
    always @(*) begin
        if(B_INPUT=="DIRECT")
        _0b0ready=b;
        else if (B_INPUT=="CASCADE")
        _0b0ready=bcin;
        else 
        _0b0ready=bcin;
        if(CARRYINSEL=="CARRYIN")
        cin0ready=carryin;
        else if(CARRYINSEL=="OPMODE5")
        cin0ready=opmode[5];
        else
        cin0ready=carryin;
    end
    //flipflop + mux for inputs
    dffmux #(.width(datainwidth),.RSTTYPE(RSTTYPE),.REGG(B0REG)) dffb0(.d(_0b0ready),.enable(ceb),.clk(clk),.q(b0ready),.rst(rstb));
    dffmux #(.width(datainwidth),.RSTTYPE(RSTTYPE),.REGG(DREG)) dffd(.d(d),.enable(ced),.clk(clk),.q(dready),.rst(rstd));
    dffmux #(.width(datainwidth),.RSTTYPE(RSTTYPE),.REGG(A0REG)) dffa0(.d(a),.enable(cea),.clk(clk),.q(a0ready),.rst(rsta));
    dffmux #(.width(dataoutwidth),.RSTTYPE(RSTTYPE),.REGG(CREG)) dffc(.d(c),.enable(cec),.clk(clk),.q(cready),.rst(rstc));
    dffmux #(.width(opwidth),.RSTTYPE(RSTTYPE),.REGG(OPMODEREG)) dffop(.d(opmode),.enable(ceopmode),.clk(clk),.q(opready),.rst(rstopmode));
    dffmux #(.width(1),.RSTTYPE(RSTTYPE),.REGG(CARRYINREG)) dffcin(.d(cin0ready),.enable(cecarryin),.clk(clk),.q(cinready),.rst(rstcarryin));
    //preadder+mux
    adder #(datainwidth) preadder(.dz(dready),.bx(b0ready),.op(opready[6]),.cout(preaddercout),.out(preadderout),.cin(0));
    mux2 #(datainwidth) mux1(.sel2(preadderout),.sel1(b0ready),.out(mux1out),.sel(opready[4]));
    //flipflop + mux for b1 and a1
    dffmux #(.width(datainwidth),.RSTTYPE(RSTTYPE),.REGG(B1REG)) dffb1(.d(mux1out),.enable(ceb),.clk(clk),.q(b1ready),.rst(rstb));
    dffmux #(.width(datainwidth),.RSTTYPE(RSTTYPE),.REGG(A1REG)) dffa1(.d(a0ready),.enable(cea),.clk(clk),.q(a1ready),.rst(rsta));
    //multiplier
    mult #(datainwidth) mul(.dz(a1ready),.bx(b1ready),.out(mnotready));
    //flipflop + mux for m
    dffmux #(.width(2*datainwidth),.RSTTYPE(RSTTYPE),.REGG(MREG)) dffm(.d(mnotready),.enable(cem),.clk(clk),.q(m),.rst(rstm));
    //mux x,z
    assign muxxin0={dready[11:0], a1ready,b1ready};
    assign muxxin1={12'd0,m};
    mux4 #(dataoutwidth) muxx(.sel4(muxxin0),.sel3(p),.sel2(muxxin1),.sel1(48'd0),.sel(opready[1:0]),.out(muxxout));
    mux4 #(dataoutwidth) muxz(.sel4(cready),.sel3(p),.sel2(pcin),.sel1(48'd0),.sel(opready[3:2]),.out(muxzout));
    //postadder
    adder #(dataoutwidth) postadder(.dz(muxzout),.bx(muxxout),.op(opready[7]),.cout(coutnotready),.out(pnotready),.cin(cinready));
    //flipflop + mux for outputs
    dffmux #(.width(1),.RSTTYPE(RSTTYPE),.REGG(CARRYOUTREG)) dffcout(.d(coutnotready),.enable(cecarryin),.clk(clk),.q(carryout),.rst(rstcarryin));
    dffmux #(.width(dataoutwidth),.RSTTYPE(RSTTYPE),.REGG(PREG)) dffp(.d(pnotready),.enable(cep),.clk(clk),.q(p),.rst(rstp));
    //cascade outputs
    assign carryoutf=carryout;
    assign pcout=p;
    assign bcout=b1ready;
endmodule