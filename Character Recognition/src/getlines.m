function lines=getlines(x)
x=1-x;
vertical=sum(x,2); %vertical sum of brightness


m=size(vertical); 
first=0;
last=0;
flag=0;
j=1;

for i=1:length(vertical)
    if(flag==0)
        if(vertical(i)~=0)
            flag=1;
            first=i;
        end
    else
        if(vertical(i)==0)
            flag=1;
            last=i;
            lines{j}=x(first:last,:);
            j=j+1;
            flag=0;
        end   
    end
end
  

end