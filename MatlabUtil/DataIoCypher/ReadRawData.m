function [ Time,Separation,Force ] = ...
    ReadRawData( FilePath )
%READRAWDATA Reads in an HDF5 file with AFM data 
%%   FilePath: Path to the file
    mDataSetName = '/PrhHD5GenericData';
    mData = h5read(FilePath,mDataSetName);
    Time = double(mData(1,:));
    Separation = double(mData(2,:));
    Force = double(mData(3,:));
end

