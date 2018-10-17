function pars=pars_500ms
%%
pars.fr=0.505;% frame rate in seconds
pars.um_px=0.104; % microns per pixel

impars.PixelSize=0.104; % um per pixel
impars.psf_scale=1.2; % PSF scaling
impars.wvlnth=0.580; %emission wavelength in um
impars.NA=1.1; % NA of detection objective
impars.psfStd= impars.psf_scale*0.55*(impars.wvlnth)/impars.NA/1.17/impars.PixelSize/2; % PSF standard deviation in pixels
impars.FrameRate=pars.fr; %secs
impars.FrameSize=pars.fr; %secs

% localization parameters
locpars.wn=11; %detection box in pixels keep odd
locpars.errorRate=-6.5; % error rate (10^-)
locpars.dfltnLoops=3; % number of deflation loops
locpars.minInt=0; %minimum intensity in counts
locpars.maxOptimIter= 50; % max number of iterations
locpars.termTol=-2; % termination tolerance
locpars.isRadiusTol=false; % use radius tolerance
locpars.radiusTol=50; % radius tolerance in percent
locpars.posTol= 1.5;%max position refinement
locpars.optim = [locpars.maxOptimIter,locpars.termTol,locpars.isRadiusTol,locpars.radiusTol,locpars.posTol];
locpars.isThreshLocPrec = false;
locpars.minLoc = 0;
locpars.maxLoc = inf;
locpars.isThreshSNR = false;
locpars.minSNR = 0;
locpars.maxSNR = inf;
locpars.isThreshDensity = false;
% tracking parameters
trackpars.trackStart=1;
trackpars.trackEnd=inf;
trackpars.Dmax=0.1;
trackpars.searchExpFac=1.2;
trackpars.statWin=10;
trackpars.maxComp=3;
trackpars.maxOffTime=1;
trackpars.intLawWeight=0.9;
trackpars.diffLawWeight=0.5;

pars.impars=impars;
pars.trackpars=trackpars;
pars.locpars=locpars;

end