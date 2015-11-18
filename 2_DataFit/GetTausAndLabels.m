function [ labels,taus ] = GetTausAndLabels( varargin )
    InputDir = './TestData/';
    CacheDir = './TestCache/';
    % XXX TODO: add other models.
    CacheName = [CacheDir 'LogModel.csv'];
    % if the cache file exissts, use it
    if (exist(CacheName, 'file') == 2)
       mMat = csvread(CacheName);
       % first/second column are labels/taus
       labels = mMat(:,1);
       taus = mMat(:,2);
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
    taus = zeros(nFiles,1);
    for i=1:nFiles
        fprintf('Getting Tau %d/%d\n',i,nFiles);
        tmpFile = [InputDir fileNames{i}];
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
        % zero the force out to between 0 and 1...
        minF = min(ForceFit);
        maxF = max(ForceFit);
        ForceFit = (ForceFit -minF)/(maxF-minF);
        % get tau
        % fit an exponential model  using a logairthmic model
        [tauLog,~,~] = FitLogarithmicLP_Exponential( SepFit,ForceFit );
        taus(i) = tauLog;
    end
    mMat = [labels,taus];
    csvwrite([CacheName],mMat);
end

