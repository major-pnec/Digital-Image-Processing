function letters=getletters(lines)
numLines=length(lines);

for i=1:numLines
    x=lines{1,i};
    x=imopen(x,strel('square',3));
    x(x<=0.4)=0; 
    x(x>0.4)=1;
    horizontal=sum(x,1);
    
    m=size(lines{1,i});
    
    
    
    first=0;
    last=0;
    flag=0;
    j=1;
    clear templetters
    for ii=1:length(horizontal)
        if(flag==0)
            if(horizontal(ii)~=0)
                flag=1;
                first=ii;
            end
        else
            if(horizontal(ii)==0)
                flag=1;
                last=ii;
                templetters{j}=x(:,first:last);
%                 sz=sizeof(templetters{j});
                j=j+1;
%                 templetters{j}=zeros(sz);
%                 j=j+1;
                flag=0;
            end   
        end
    end
    letters{i}=templetters;
end
% figure;imshow(letters{1}{1});
end