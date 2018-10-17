function cfunc=calc_2exp(A,F,df,ds,tvec,tshift)
    cfunc=A*(F*exp(-(1/df).*(tvec+tshift)) + (1-F)*exp(-(1/ds).*(tvec+tshift)));
    
   
end