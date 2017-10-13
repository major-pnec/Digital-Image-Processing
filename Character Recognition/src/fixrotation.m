function y= fixrotation(x)

h = fspecial('gaussian',20,40);

%padding to avoid loosing text near the boarder and because imfilter creates a black boarder 
xpadded=padarray(x,[200 200],1,'both'); 
xnew=imfilter(xpadded,h);
xnew=xnew(200:end-200,200:end-200); %removing the paded area

%filtering the image in order to join all the black letters
xnew(xnew<=0.95)=0; 
xnew(xnew>0.95)=1;

%removing dc
dc=mean2(xnew); 
xnew=xnew-dc;

%DFT
FF=fft2(xnew); 

%abs of complex number returns its magnitude 
magnitude=abs(FF); 
[I,J]=find(magnitude==max(max(magnitude)));
% tempxx=magnitude;
% tempxx(I,J)=0;
% [I,J]=find(tempxx==max(max(tempxx)));

theta=atan2(J(1),I(1)); %finding the angle
theta=radtodeg(theta);
fprintf('Angle found using fft %0.3f\n',theta);
xtemp=1-x; %inverting the image to avoid the black pixels when rotating
ytemp = imrotate(xtemp,-theta,'crop'); %rotating
% ytemp=1-ytemp; %invert back to normal

proj=sum(ytemp,2); %find the projection at vertical axes
num=sum(proj(:) == 0);

%init
maxproj=proj;
best=theta;

fprintf('Searching arround this angle\n');
for i= (theta-0.3):0.01:(theta+0.3) %searching for the best angle to rotate in serial manner
    ytemp = imrotate(xtemp,-i,'crop'); 
%     ytemp=1-ytemp;
    proj=sum(ytemp,2);
    tempnum=sum(proj(:) == 0); %finding the angle that produce the maximum projection of the brightness
    %by comparing the total number of rows having the maximum projection between all the angles so far
    if(tempnum>num)
        num=tempnum;
        best=i;
    end
end

y = imrotate(xtemp,-best,'crop'); %using no decimal points, from test understood its best this way
y=1-y; %inverting colors back
% figure;imshow(y);
fprintf('rotating by %0.3f\n',-best);

