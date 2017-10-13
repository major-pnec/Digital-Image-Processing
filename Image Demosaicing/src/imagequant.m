function q = imagequant(x, w1, w2, w3)
[M N Z]=size(x);
w=[w1 w2 w3];
for i=1:1:Z %calling myquant 3 times, one for each color
   q(:,:,i)= myquant(x(:,:,i),w(i));
end
