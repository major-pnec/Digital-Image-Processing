function ch=getChar(r1Ref,r2Ref,r1,r2)
    if(isempty(r2))
        flag=0;
    else
        flag=1;
    end
  
    for i=1:length(r1Ref)
            size1=length(r1);
            size2=length(r1Ref{i});
            r1=interp1(linspace(1,size1,size1),r1,linspace(1,size1,size2)).';
            R1=fft2(r1);
            R1ref{i}=fft2(r1Ref{i});
            d1(i)=0;
            temp=abs(R1ref{i});
            temp=temp-abs(R1);
            d1(i)=sum(temp.^2);

%             d1(i)=immse(R1ref{i},R1);
    end

    if(flag==1)
        for i=1:length(r2Ref)
                if(~isempty(r2Ref{i})&&(length(r2)>=2)) % if there is 2ond contour
                    size1=length(r2);
                    size2=length(r2Ref{i});
                    r2=interp1(linspace(1,size1,size1),r2,linspace(1,size1,size2)).';
                    R2=fft2(r2);
                    R2ref{i}=fft2(r2Ref{i});
                    temp=abs(R2ref{i});
                    temp=temp-abs(R2);
                    d2(i)=sum(temp.^2);
                else
                    d2(i)=inf;
                
                end
        end
        d(i)=(d1(i)+d2(i))/2; %mean of d1 +d2
    else
        d=d1;
    end
    
    
    [mind index]=min(d); %min difference
    ch=char(64+index);   %int to char

    
    
    
    
end
