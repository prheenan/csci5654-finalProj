function [ Time,Separation,Force ] = ...
    ReadRawData( FilePath )
%READRAWDATA Reads in an HDF5 file with AFM data formatted according to the
% AFM_Database Schema
%   FilePath: Path to the file
    mDataSetName = '/PrhHD5GenericData';
    mData = h5read(FilePath,mDataSetName);
    Time = mData(1,:);
    Separation = mData(2,:);
    Force = mData(3,:);
end

