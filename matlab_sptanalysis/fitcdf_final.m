function [fit_results2, fit_results1]=fitcdf_final(SP,fit_params2,fit_params1)
    % fits data to a 2exp model and 1exp model and returns fits and which
    % one is better according to F-test

    tdata=SP(:,1);
    ydata=SP(:,2);

    f2 = fittype(['log(A*(F*exp(-(1/df)*(x+',num2str(tdata(1)), '))+ (1-F)*exp(-(1/ds)*(x+',num2str(tdata(1)),'))))']);
%     f2 = fittype(['log(A*(F*exp(-(1/df)*(x','))+ (1-F)*exp(-(1/ds)*(x','))))']);
    
    f1 = fittype(['log(A*exp(-(1/d)*(x+',num2str(tdata(1)),')))']);

    [TwoExp_fit, TwoExp_param] = fit(tdata, log(ydata), f2, 'Lower', fit_params2(1,:), 'Upper', fit_params2(2,:), 'StartPoint', fit_params2(3,:));   
    TwoExp_CI = confint(TwoExp_fit);
    
    fit_results2.A=TwoExp_fit.A;  fit_results2.ACIN=TwoExp_CI(1,1);   fit_results2.ACIP=TwoExp_CI(2,1);  
    fit_results2.F=TwoExp_fit.F;  fit_results2.FCIN=TwoExp_CI(1,2);   fit_results2.FCIP=TwoExp_CI(2,2);  
    fit_results2.df=TwoExp_fit.df; fit_results2.dfCIN=TwoExp_CI(1,3);   fit_results2.dfCIP=TwoExp_CI(2,3);  
    fit_results2.ds=TwoExp_fit.ds; fit_results2.dsCIN=TwoExp_CI(1,4);   fit_results2.dsCIP=TwoExp_CI(2,4);  
    fit_results2.Rsq=TwoExp_param.adjrsquare;
    fit_results2.SSE=TwoExp_param.sse;
    fit_results2.adjRsq=TwoExp_param.adjrsquare;
    fit_results2.dfe=TwoExp_param.dfe;
    
%   fit_results2.SPfit=[tdata,calc_2exp(fit_results2.A,fit_results2.F,fit_results2.df,fit_results2.ds,tdata)];
%     cfunc2=fit_results2.A*(fit_results2.F*exp(-(1/fit_results2.df).*(tdata)) + (1-fit_results2.F)*exp(-(1/fit_results2.ds).*(tdata)));  
    cfunc2=fit_results2.A*(fit_results2.F*exp(-(1/fit_results2.df).*(tdata+tdata(1))) + (1-fit_results2.F)*exp(-(1/fit_results2.ds).*(tdata+tdata(1))));  
    fit_results2.SPfit=[tdata,cfunc2];    
   
    %now do a single exponent fit    
    [OneExp_fit, OneExp_param] = fit(tdata, log(ydata), f1, 'Lower', fit_params1(1,:), 'Upper', fit_params1(2,:), 'StartPoint', fit_params1(3,:));  
    OneExp_CI = confint(OneExp_fit);
    fit_results1.A=OneExp_fit.A; fit_results1.ACIN=OneExp_CI(1,1);   fit_results1.ACIP=OneExp_CI(2,1);  
    fit_results1.d=OneExp_fit.d; fit_results1.dCIN=OneExp_CI(1,2);   fit_results1.dCIP=OneExp_CI(2,2);  
    fit_results1.Rsq=OneExp_param.adjrsquare;
    fit_results1.SSE=OneExp_param.sse;
    fit_results1.adjRsq=OneExp_param.adjrsquare;
    fit_results1.dfe=OneExp_param.dfe;  
    cfunc1=fit_results1.A*(exp(-(1/fit_results1.d).*(tdata+tdata(1))));  
    fit_results1.SPfit=[tdata,cfunc1];

    % do the F-test
    SS1=fit_results1.SSE;
    SS2=fit_results2.SSE;
    df1=fit_results1.dfe;
    df2=fit_results2.dfe;
    F=((SS1-SS2)./(df1-df2))./(SS2./df2);
    P=1-fcdf(F,df1,df2);
    
    fit_results2.Fstat=F; % save F value in fit_results 2
    fit_results2.P=P; % save P value in fit_results 2
    
    
end