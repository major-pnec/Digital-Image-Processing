function h = pdf2hist(d, f)
    h=zeros(length(d)-1,1);
    for i=1:length(d)-1 %integrating each space to find the Propability
        h(i)=integral(f,d(i),d(i+1));
    end
    sumh=sum(h(:)); %normalazing the histogram
    h=h/sumh;
end
