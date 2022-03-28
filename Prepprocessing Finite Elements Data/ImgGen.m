function ImgGenV2(Idata3d,RData3d,maxForce,deflectionScale,stressScale,cmap,name1,name2,var1,var2,var3,var4,var5)


%Read "inputVariables.csv" table
InVars=ReadRaw('InputVariablesE1','.csv','%f%f%f%f%f');
%Normalise InputVariables [0:1] ie Divide by each Variables Range
ScaleFactor=(max(InVars,[],1));
NormInVars=InVars./ScaleFactor;%
 
%Permute Z matrix into image layout
%==================================
Trial=1;
for I=1:var1                            %Material Ex
    for J=1:var2                        %Thickness
        for K=1:var3                    %Aspect Ratio 
            for L=1:var4                %Repeat runs
                for M=1:var5            %Forces
                
                   % define number of color according to FEA analysis (in
                   % our case we have 66049 samples for each image
                   % (257*257)
                    Numcolor=257;
                    newmap=gray(257);
                    
                    newmap(:,2)=NormInVars(I,1);     %This will vary per Material
                    newmap(:,3)=NormInVars(J,2);     %This will vary per Thickness
                    colormap(newmap);
                    caxis([0,257]);
                    
                    % Get data for images one by one
                   
                    data=RData3d(:,:,Trial);
                    [n, ~]=size(data);
                    dimy=257;
                    dimx=257;
                    deflectionData=data(:,4);    %Extract Deflections
                    stressData=data(:,5);    %Extract Stresses
                   
                   % Create both stress and deflection image from FE data
                   % file
                    %deflectionScale = MaxZ; % comment after debug
                    %stressScale = MaxS; % comment after debug
                    deflectionImg = reshape (deflectionData, [dimx dimy]); % create deflection image from deflection data
                    stressImg = reshape( stressData, [dimx dimy]); % create stress image from stres data
                    deflectionImgNormalized=deflectionImg./deflectionScale;     %Normalize Displacement between [0:1]
                    stressImgNormalized=stressImg./stressScale;     %Normalize Stress between [0,1]
                   
                    
                    
                    % get force data 
                    data=Idata3d(:,:,Trial);             %Extract input data (forces & Locations)
                    [n , ~]=size(data);
                    nodes= uint32( data(:,1));
                    nodes = nodes(nodes>0);
                    Force=data(:,2);
                    Force = Force(nodes>0);
%                     nodes
%                     Force
                    
                    % create image for force data
                    %maxForce = 50000; % comment after debug
                    forceImage = zeros(dimx*dimy,1); % create empty array 
                    forceImage(nodes) = Force;
                    forceImage = reshape(forceImage, [257 257]);
                    forceImgNormalized=forceImage./maxForce; 
                             
                   % Plot images
                   normalizedScale = 1;
                   % Plot forces
                   subplot(2,2,1)
                   imagesc(forceImgNormalized,[0 normalizedScale])
                   colormap(newmap)
                   title ('Force image')
                   axis xy
                   axis image
                   
                   % Plot Deflection
                   subplot(2,2,2)
                   imagesc(deflectionImgNormalized,[0 normalizedScale])
                   colormap(newmap)
                   title ('Defelection image')
                   axis xy
                   axis image

                  % Plot Stress
                  subplot(2,2,3)
                  imagesc(stressImgNormalized,[0 normalizedScale])
                  colormap(newmap)
                  title ('Stress image')
                  axis xy
                  axis image
                  
                  % Plot deflection 3d
                   subplot(2,2,4)
                   s=surf(deflectionImgNormalized);
                   s.EdgeColor = 'none';
                   colormap(newmap)
                   caxis manual
                   axis([0 inf 0 inf 0 normalizedScale])
                   title ('Defelection 3D Surface') 
                   
                   
                    
                    
                    
                     % Convert image data into uint8 to save to file
                    forceImgNormalized = uint8( flipud(forceImgNormalized).*(Numcolor-1) ) ;
                    deflectionImgNormalized = uint8( flipud(deflectionImgNormalized).*(Numcolor-1) ) ;
                    stressImgNormalized = uint8( flipud(stressImgNormalized).*(Numcolor-1) ) ;
                    %  Resize iamges to  256 * 256

                    % Force image
                    forceImgNormalized = imresize( forceImgNormalized, [256 256]);
                    
                    % Defelection image
                     deflectionImgNormalized = imresize( deflectionImgNormalized, [256 256]);
                    
                     % Stress image
                    stressImgNormalized = imresize( stressImgNormalized, [256 256]);
                    
                    % Redifine color map and intensity
                    newmap=gray(256);
                    newmap(:,2)=NormInVars(I,1);     %This will vary per Material
                    newmap(:,3)=NormInVars(J,2);     %This will vary per Thickness
                    colormap(newmap);
                    caxis([0,256]);
                    
                    % Combine images and write them into files
                    % Force  to defelction file
                    combImg = cat(2,forceImgNormalized,deflectionImgNormalized);
                    imwrite(combImg,newmap,['combined' num2str(I) '_' num2str(J) '_' num2str(K) '_' num2str(L) '_' num2str(M) '.bmp']); 
                    
                    % Defelection to Stress file 
                    combImg = cat(2,deflectionImgNormalized,stressImgNormalized);
                    imwrite(combImg,newmap,['Stress' num2str(I) '_' num2str(J) '_' num2str(K) '_' num2str(L) '_' num2str(M) '.bmp']);
                    
                    % Force to Stress file 
                    combImg = cat(2,forceImgNormalized,stressImgNormalized);
                    imwrite(combImg,newmap,['Direct' num2str(I) '_' num2str(J) '_' num2str(K) '_' num2str(L) '_' num2str(M) '.bmp']);
                    
                    Trial=Trial+1;
                    
                end
            end
        end
    end
end

                
end