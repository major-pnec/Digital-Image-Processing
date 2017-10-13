clear all;

MSGID='images:initSize:adjustingMag';%removing the annoying warning for image size %50
warning('off', MSGID);

load('textimage.mat');%x
load('letters.mat'); %l

tic;
y= fixrotation(x);
% figure;imshow(y);

toc

ch=readtext(y);    
    
for i=1:length(ch)
    for j=1:length(ch{i})
        fprintf('%c',ch{i}{j})
    end
    fprintf('\n')
end


warning('on', MSGID); %turning warning on again
