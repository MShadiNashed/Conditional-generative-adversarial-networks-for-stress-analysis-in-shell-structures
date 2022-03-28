function [data3d,SelTrials]= GenDataset(filename,format,structure,var1,var2,var3,var4,var5,maxrows,trials)
%reads Raw data textfiles into 3Dimentional array
%2D portion of array is each "Trials" data
%3rd Dimension is each sequential Trial

data3d = zeros(maxrows,4,trials);    
Trials = 1;
for I=1:var1                    %6 Ex
    for J=1:var2                %8 Thicknes
        for K=1:var3            %10 Aspect Ratios
            for L=1:var4        %10 Iterations
                for M=1:var5    %5 Sequential Forces
                    
                    file= [filename num2str(I) '_' num2str(J) '_' num2str(K) '_' num2str(L) '_' num2str(M)]
                    data=ReadRaw(file,format,structure);
                    [A,B]=size(data);
                    for N=1:A
                        for O=1:B
                        data3d(N,O,Trials)=data(N,O);
                        end
                    end
                   
                    Trials=Trials+1;
                end
            end
        end
    end
end
SelTrials=Trials-1;
end