% this code convert finite elemnet files related to force and deflection 
% into paired images

filename1='NodalDeflections1_1_1_';
format='.TXT';
structure='%f%f%f%f%f';
columns=5;

var1=1;         %6 Materials specs
var2=5;         %8 Thicknesses
var3=1;         %10 Aspect Ratios - Leave for now
var4=3;        %10 Repeat Runs
var5=5;         %5 Forces

[~,maximums]=FileCount(filename1,structure,columns);
MaxNodes=65536;  %256x256
MaxZ=maximums(1,4);
MaxS=maximums(1,5);

filename2='ForceLocs';
[Trials,maximums]=FileCount(filename2,structure,columns);
MaxForce=maximums(1,2);
 
filename1='NodalDeflections';
[RData,~]= GenDataset(filename1,format,'%f%f%f%f%f',var1,var2,var3,var4,var5,MaxNodes,Trials);

filename2='ForceLocs';
[IData,selTrials]= GenDataset(filename2,format,'%f%f%f%f',var1,var2,var3,var4,var5,5,Trials);

cmap=gray(257);

ImgGen(IData,RData,3161000,MaxZ,MaxS,cmap,'InpImg','OutImg',var1,var2,var3,var4,var5)






