function cfunc=calc_1exp(A,d,tvec,tshift)
    cfunc=A*exp(-(1/d).*(tvec+tshift));
%     cfunc=exp(-(1/d).*tvec);
end