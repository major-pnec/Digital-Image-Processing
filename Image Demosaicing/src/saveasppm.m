function saveasppm(x, filename, K)
K=K(1);
if K<256 %if K is >=256 we need Big Endian and 16 bit representation
    type='uint8';
    endian='l';
else
    type='uint16';
    endian='b';
end

[M N Z]=size(x);

g=zeros([1,M*N*Z]);
index=1;
for i=1:M           %creating an vector that contains all the pixels of each row in RGBRGBRGBRGB...
g(index:3:i*N*3)=x(i,:,1);
g((index+1):3:i*N*3+1)=x(i,:,2);
g((index+2):3:i*N*3+2)=x(i,:,3);
index=i*N*3+1;
end

file=fopen(filename,'w'); %creating a file
fprintf(file,'P6 %d %d %d\n',N,M,K); %writing the header
fwrite(file,g(1:end),type,endian);  %writing the array with the pixels in binary form
fclose(file); %close file






