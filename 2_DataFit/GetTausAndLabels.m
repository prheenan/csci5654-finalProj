function [ labels,tauLog,tauPoly,tauExp ] = ....
    GetTausAndLabels( PlotDebug,deg,Limit,Force,InputDir,CacheDir )
%% Function: [labels,tauLog,tauPoly,tauExp] = GetTausAndLabels ( PlotDebug,deg,Limit,Force,InputDir,CacheDir)
%% Inputs: 
%%    (PlotDebug) === 0/1 if plots of the fits should / shouldn't be saved in CacheDir. Default: 0
%%    (deg)       === highest degree of the Polynomial. Default: 4
%%    (limit)     === limit to this many plots. Default is inf (does them all)
%%    (Force)     === Force re-generation of cached data. Default: 0 (re-uses cached data)
%%    (InputDir)  === Where the data file live. Default: './TestData/'
%%    (OutputDir) === Where to put the output. Default: './TestCache/'
%% Outputs:
%%    labels === The surface location, in nm
%%    tauLog === The 'tau' exponential decay constant in nm, according to the log (LP_ model
%%    tauPoly === The 'tau' exponential decay constant in nm, according to the polynomial (LP) model
%%    tauExp === The 'tau' exponential decay constant in nm, according to the exponential (non-linear) model
    if (nargin < 6) 
        % PlotDebug : Should we make a debugging plot
        PlotDebug = 0; 
        % deg : degree of polynomial
        deg = 4;    
        % Limit : number of taus to use
        Limit = Inf;
        % Force : if 1, then re-make cache. otherwise, use cache if present
        Force = 0;
        InputDir = './TestData/';
        CacheDir = './TestCache/';
    end
    CacheName = [CacheDir 'LogModel.csv'];
    % if the cache file exissts, use/return it.
    if ( (exist(CacheName, 'file') == 2) && ~Force)
       mMat = csvread(CacheName);
       % first/second column are labels/taus
       labels = mMat(:,1);
       tauLog = mMat(:,2);
       tauPoly = mMat(:,3);
       tauExp = mMat(:,4);
       return
    end
    % get the (absolute) labels. Will need to normalize
    % to each separation curve
    labelFileName = [InputDir 'DetectedLabels.csv'];
    labels = csvread(labelFileName);
    % get all the input (hdf) files
    files = dir([InputDir '*.hdf']);
    nFiles = numel(files);
    % loop through each file, read it in, get the tau
    fileNames = {files.name};
    % only look at the first n labels, where n is the number of 
    % files
    labels = labels(1:nFiles);
    tauLog = zeros(nFiles,1);
    tauPoly = zeros(nFiles,1);
    tauExp = zeros(nFiles,1);
    maxI = min(Limit,nFiles);
    for i=1:maxI
        fprintf('Getting Tau %d/%d\n',i,nFiles);
        mFile = fileNames{i};
        tmpFile = [InputDir mFile];
        [~,Sep,Force] =...
            ReadRawData(tmpFile);
        % minimize the surface location to this separation.
        % also convert to nm (from meters)
        minV = min(Sep);
        labels(i) = 1e9 * (labels(i) - minV);
        % get tau, only lookin near the surface (make  the problem smaller)
        [SepFit,ForceFit] = GetPortionToFit( Sep,Force );
        % convert Sep to nm from meters
        SepFit = SepFit .* 1e9;
        % zero it out, to match our definition of Tau
        SepFit = SepFit - min(SepFit);
        % sort everything min to max sep
        [~,I] = sort(SepFit);
        SepFit = SepFit(I);
        ForceFit = ForceFit(I);
        % zero the force out to between 0 and 1...
        n = numel(ForceFit);
        minF = median(ForceFit(ceil(n*4/5):end));
        maxF = max(ForceFit);
        ForceFit = (ForceFit -minF)/(maxF-minF);
        % get tau
        % fit an exponential model  using a logairthmic model
        [tauLogTmp,predXLog,predYLog] = ...
            FitLogarithmicLP_Exponential( SepFit,ForceFit );
        [ tauPol,predictPoly,~ ] = FitPolynomialLP_Exponential( SepFit,ForceFit,deg );
        tauLog(i) = FilterTau(tauLogTmp,SepFit);
        tauPoly(i) = FilterTau(tauPol,SepFit);
        % get the coefficients
        % compare to 'true' exponential fit (not an LP )
        [ tauExpTmp,~ ] = FitNonLinearExponential( SepFit,ForceFit ); 
        tauExp(i) = tauExpTmp;
        % if we want, give a debugging plot for this model...
        if (PlotDebug)
            % compare to 'true' exponential fit (not an LP )
            [ ~,predExp ] = FitNonLinearExponential( SepFit,ForceFit );
            % plot the true data
            lw = 2; % line width
            fig = figure('Visible','Off');
            hold all;
            plot(SepFit,ForceFit,'.','Color',[0.4,0.4,0.4]);
            plot(SepFit,predExp,'b-','linewidth',lw/2);
            % plot the models
            plot(predXLog,predYLog,'r--','linewidth',lw);
            plot(SepFit,predictPoly,'k--','linewidth',lw);
            xlabel('Separation (nanometers)');
            ylabel('Force (arb)');
            legend('Raw Data','Non-linear Model (Not LP)',...
                'LP in Log-space','LP with polynomial')
            legend();
            PlotBeautify(); 
            dirPath = [CacheDir 'DebugPlots/' num2str(i) '_' mFile '.png'];
            print(dirPath,'-dpng');
            close(fig);
        end
    end
    mMat = [labels,tauLog,tauPoly,tauExp];
    csvwrite(CacheName,mMat);
end

function [trueTau] =  FilterTau(tau,sep)
    % use 0 for min, and maxSep for maximum tau; 
    trueTau = max(0,tau);
    trueTau = min(trueTau,max(sep));
end

