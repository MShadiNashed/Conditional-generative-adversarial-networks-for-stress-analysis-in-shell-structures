function [data]= ReadRaw(filename,format,structure)
%reads Raw data textfile Matrix

file= [filename format]
if isfile(file)
    if format=='.TXT'
       fid = fopen(file);
        rawdata=textscan(fid, structure);
        columns=size(rawdata,2);
        rows=size(rawdata{1},1);
        fclose(fid);
        data=zeros(rows,columns);
        for i=1:columns
            data(:,i)=rawdata{i};
        end
    else format=='.csv'
        fid = fopen(file);
        rawdata=readtable(file,'Delimiter',',','HeaderLines',1);
        data=table2array(rawdata);
    end
elseif istable(file)
        fid = fopen(file);
        rawdata=readtable(fid, structure);
        fclose(fid);
        data=[rawdata{1} rawdata{2} rawdata{3} rawdata{4}];
else
    data=[0 0 0 0]
end
end            