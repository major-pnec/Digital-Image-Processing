clear all;
close all;
clc;

MSGID='images:initSize:adjustingMag';%removing the annoying warning for image size %50
warning('off', MSGID);

load('march.mat','x');

[Mo, No]=size(x);

strN=sprintf('State the width of the image (recomended %d): ',No);
strM=sprintf('State the width of the image (recomended %d): ',Mo);
N = input(strN);
M = input(strM);

method= input('State the method of interpolation (linear or nearest): ','s');
while(1)
        if strcmp(method,'linear') || strcmp(method,'nearest')
           break;
        end
         disp('Method must be either "linear" either "nearest"');
         method = input('State the method of interpolation: ','s');
end

n=zeros(1,3);
n(1) = input('State the number of quantization bits for red: ');
n(2) = input('State the number of quantization bits for green: ');
n(3) = input('State the number of quantization bits for blue: ');
clc;

fprintf('Image size Width*Height: %d*%d\nMethod: %s\nQuantization bits RGB=[%d %d %d]\n',N,M,method,n(1),n(2),n(3));
totaltime1=tic;

fprintf('\nStarting interpolation ');
tic;
xc=bayer2rgb(x, M, N,method);
bayertime=toc;
fprintf('\t\t\t\t\t\t\t\t%0.4f\tsec\n',bayertime);

imwrite(xc,'march.png');

maxnum=2.^n-1;%max represented number with n bits is the number of quantization levels


w=(1-0)./(maxnum+1); %width of quantization max number +1 cause of level 0

fprintf('Starting quantization ');
tic;
q=imagequant(xc,w(1),w(2),w(3));
quanttime=toc;
fprintf('\t\t\t\t\t\t\t\t%0.4f\tsec\n',quanttime);

fprintf('Starting dequantization ');
tic;
xcdeq=imagedequant(q,w(1),w(2),w(3));
dequanttime=toc;
fprintf('\t\t\t\t\t\t\t%0.4f\tsec\n',dequanttime);


filename='march.ppm'; %setting filename
K=max(maxnum); %taking the max represented number as max quantation number
fprintf('Saving the image ');
tic;
saveasppm(q,filename,K);
savetime=toc;
fprintf('\t\t\t\t\t\t\t\t\t%0.4f\tsec\n',savetime);




totaltime2=toc(totaltime1);

fprintf('Total run time elapsed \t\t\t\t\t\t\t\t%0.4f\tsec\n',totaltime2);


figure(1);
imshow(xc);
title(['Image produced by $$ ' method '$$\ method '],'interpreter','latex')
xlabel(['$$' num2str(N) '$$'],'interpreter','latex')
ylabel(['$$' num2str(M) '$$'],'interpreter','latex')


figure(2);
imshow(xcdeq);
title(['Image produced after dequantization with RGB = $$[' num2str(n(1)) '\ ' num2str(n(2)) '\ ' num2str(n(3)) ']$$\ bits '],'interpreter','latex')
xlabel(['$$' num2str(N) '$$'],'interpreter','latex')
ylabel(['$$' num2str(M) '$$'],'interpreter','latex')

figure(3);
imshow(filename);
title(['Image produced after saving as "$$' filename '$$"'],'interpreter','latex')
xlabel(['$$' num2str(N) '$$'],'interpreter','latex')
ylabel(['$$' num2str(M) '$$'],'interpreter','latex')


warning('on', MSGID); %turning warning on again



