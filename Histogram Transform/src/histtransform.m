function Y = histtransform(X, h, v)
[M N]=size(X);
counter=0;
pixelsum=M*N;
[xsort index]=sort(X(:)); %sorting X so we can access similar intensities at once
                          %while keeping in index array the possition of
                          %each pixel
sum=1;
previouspixel=xsort(1);
z=1;
Y=zeros(M*N,1); %creating Y as a vector
while(sum<pixelsum)
    while(xsort(sum)==previouspixel) %same intensitys will be at the same bin
        Y(index(sum))=v(z);
        counter=counter+1;
        sum=sum+1;
    end
    previouspixel=xsort(sum);
    if((counter/pixelsum)>=h(z)) %if this bin is full then start filling the next
        z=z+1;
        counter=0;
    end  
end
Y=reshape(Y,[M N]); %reshaping Y as an MxN array


            
            
            