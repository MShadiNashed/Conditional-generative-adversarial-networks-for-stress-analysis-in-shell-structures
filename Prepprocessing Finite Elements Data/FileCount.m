function [count,maximums]=FileCount(filename,structure,columns)
%Enter: 
%'Filename*' to query                          eg. 'NodalDeflections*'
% with data structure                          eg. '%s%f32%f32%f32'
% Number of Columns in which to find maximum   eg. 4
%
%Returns:
%Number of files with 'Filename'
%the maximum value for the queried columns

s=dir([filename '*']);      
count=length(s);

maximums=zeros(1,columns);

z=zeros(1,columns);

for I=1:count
    fid = fopen(s(I).name);
    rawdata=textscan(fid, string(structure));   
    fclose(fid);
    
    for J=1:columns
        z(1,J)=max(rawdata{:,J});
        if maximums(1,J)<z(1,J)
           maximums(1,J)=z(1,J);
        end
        maximums(1,4);
    end
end
end