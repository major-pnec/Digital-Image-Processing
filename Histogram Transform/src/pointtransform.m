function Y = pointtransform(X, x1, y1, x2, y2)
%defining lambda = y2-y1 / x2-x1
lambda1=(y1-0)/(x1-0);
lambda2=(y2-y1)/(x2-x1);
lambda3=(1-y2)/(1-x2);
[M N]=size(X);
Y=zeros(M,N);

for i=1:M
    for j=1:N
        if(X(i,j)<x1)
            Y(i,j)=lambda1*(X(i,j)-0)+0; %line equation y=lambda(x-x1)+y1 
        elseif(X(i,j)>=x1 &&X(i,j)<=x2)
            Y(i,j)=lambda2*(X(i,j)-x1)+y1;
        else
            Y(i,j)=lambda3*(X(i,j)-x2)+y2;
        end
    end
end


