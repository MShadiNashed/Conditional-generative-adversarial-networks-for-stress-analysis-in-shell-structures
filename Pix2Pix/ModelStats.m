%count number of files in Validation set:
ValCount=size(val_dataset.Files,1);

%Count the number of Saved Epochs:
checkpointName = '\FEANet*';
checkpointFile=fullfile(checkpoint_dir Dataset checkpointName];
files=dir(checkpointFile);
files=natsortfiles({files.name});

CheckCount=length(files);

%We want to store:
%Errors:
%DAE - Target
%DAE - Mean
%RPD - Target
%RPD - Mean
%For each Validation entry 
%For each Epoch

%Pre Allocate a Matrix to Store the above:
%Rows = Validation entry [1; ; ; ; ;ValCount]
%Colums = Errors [DAETarget, DAEMean, RPDTarget, RPDMean]
%Depth = Model Epochs [1st.....Nth Epoch]
Results=zeros(ValCount,4,CheckCount);
Epochs=zeros(CheckCount);
%Sequence:
%Load ith Checkpoint
%   Load Jth Validation entry
%       Make Prediction
%       Calculate errors
%       Store Errors
%   Increment Validation entry
%Increment Epoch

for i=1:CheckCount
    checklistName = files{i};
    checklistFile=fullfile(checkpoint_dir, Dataset, checklistName);
    
    [~,~,generator,~,Epoch,~,~,~,~,~]=load_checkpoint(checkpoint_dir, Dataset, checklistFile,-1);
    
    %Store checkpoint version Epoch
    Epochs(i)=Epoch;
    
    for j=1:ValCount
        [inp,target]=load_img(val_dataset.Files{j},'.png',1,2);
        
        %Locate max force position for test purposes (before normalization!)
        maxval=0
        for k=1:256
            for l=1:256
                if inp(k,l,1)>maxval
                    maxval=inp(k,l,1);
                    x=l;
                    y=k;
                end
            end
        end
        if maxval==0  %choose middle pixel if no values
            x=127;
            y=127;
        end
        
        %Prepare Input image for Generator inputs:
        [inp]=normalize_img(inp,1,'forward');
        inp=dlarray(inp,"SSCB");
        if (executionEnvironment == "auto" && canUseGPU) || executionEnvironment == "gpu"
            inp = gpuArray(inp);
        end
        
        %Make Prediction using Generator
        Prediction = forward(generator,inp);
        Prediction = tanh(Prediction);
        Prediction = normalize_img(Prediction,1,'backward');
        Prediction = gather(extractdata(Prediction));
        
        %Calculate errors:
        %===================
        %Absolute Error
        dif=target(:,:,1)-Prediction(:,:,1);
        Results(j,1,i)=abs(dif(y,x,1);
        Results(j,2,i)=mean(abs(dif),"all");
        
        %Relative Percent Difference (RPD)
        RPD=abs(Prediction(:,:,1)-(target(:,:,1)))./((Prediction(:,:,1))+(target(:,:,1))/2);
        Results(j,3,i)=RPD(y,x,1);
        Results(j,4,i)=mean(RPD(:,:,1),"all");
        
    end
end
    

%Plot end results
%DAE-Target
subplot1(2,2,1);
hold on;
for i=1:ValCount
    plot(Epochs,Results(i,1,:))
end
hold off;

%DAE-Mean
subplot1(2,2,2);
hold on;
for i=1:ValCount
    plot(Epochs,Results(i,2,:))
end
hold off;

%RPD-Target
subplot1(2,2,3);
hold on;
for i=1:ValCount
    plot(Epochs,Results(i,3,:))
end
hold off;

%RPD-Mean
subplot1(2,2,4);
hold on;
for i=1:ValCount
    plot(Epochs,Results(i,4,:))
end
hold off;


    