function x = imagedequant(q, w1, w2, w3)
[M N Z]=size(q);
w=[w1 w2 w3]; 
for i=1:1:Z %calling mydequant 3 time, one for each collor
   x(:,:,i)= mydequant(q(:,:,i),w(i));
end