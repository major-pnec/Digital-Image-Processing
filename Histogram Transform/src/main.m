clear all
close all


% Load image , and convert it to gray -scale
 x = imread('lena.bmp');
x = rgb2gray(x);
x = double(x) / 255;

[M N]=size(x);
% Show the histogram of intensity values
[hn , hx] = hist(x(:), 0:1/255:1);
figure(2);
hn=100.*hn./sum(hn);
bar(hx , hn)
title('Original histogram');
xlabel('Intensity')
ylabel('Histogram %')



while(true)
    %Menu
    str=sprintf(['Choose one of the following\n' ...
                ,'0.Point transform \n' ... 
                ,'1.Case 1\n' ... 
                ,'2.Case 2\n' ... 
                ,'3.Case 3\n' ... 
                ,'4.Uniform distribution [0,1]\n' ...
                ,'5.Uniform distribution [0,2]\n' ...
                ,'6.Normal distribution m=0.5 ó=0.1\n' ...
                ,'7.Exit\n' ...
                ,'Enter your choise: ']);
    choise = input(str);
    
    %close all; %closing previous figures because sometimes if u dont wait enough Error occures
    
    if(choise==7) %exit
        break;
    end
    
    %Point Transform
    if(choise==0)
        Y=pointtransform(x, 0.1961, 0.0392, 0.8039, 0.9608);
        figure(3);
        imshow(Y);
        title('Point Transform 0.1961, 0.0392, 0.8039, 0.9608');
        
        [hn , hx] = hist(Y(:), 0:1/255:1);
        hn=100*hn/sum(hn);
        figure(4);
        bar(hx , hn,'facecolor','b');
        hold on;
        grid on;
        title('Point Transform 0.1961, 0.0392, 0.8039, 0.9608');
        xlabel('Intensity')
        ylabel('Histogram %')
        hold off;
        
        
        %black and white
        Y=pointtransform(x, 0.5, 0, 0.5, 1);
        figure(5)
        imshow(Y);
        title('Point Transform Black&White');
        
        [hn , hx] = hist(Y(:), 0:1/255:1);
        hn=100*hn/sum(hn);
        figure(6);
        bar(hx , hn,'facecolor','b');
        hold on;
        grid on;
        title('Point Transform Black&White');
        xlabel('Intensity')
        ylabel('Histogram %')
        hold off;
        
    end


    % Case 1
    if(choise==1)
        L = 10;
        v = linspace (0, 1, L);
        h = ones([1, L]) / L;
      
        Y = histtransform(x, h, v);
        
        figure(7);
        imshow(Y);
        title('Case 1 : Uniform distribution [0,1]');
      
        
        [hn , hx] = hist(Y(:), 0:1/255:1);
        hn=100*hn/sum(hn);
        h=h*100;
        
        figure(8);
        bar(hx , hn,2,'facecolor','b');
        hold on;
        stem(v,h,'LineWidth',1,'Color','r');
        plot(v,h,'LineWidth',1,'Color','r');
        xlim([min(v)-0.02,max(v)+0.02]);
        set(gca,'XTick',v,'XTickLabelRotation',45,'XTickLabel',sprintf('%0.2f\n',v));
        legend({'Y','[v,h]'},'FontSize',8,'Location','northeast')
        grid on;
        title('Case 1 : Uniform distribution [0,1]');
        xlabel('Intensity')
        ylabel('Histogram %')
        hold off;
    end


    % Case 2
    if(choise==2)
        L = 20;
        v = linspace (0, 1, L);
        h = ones([1, L]) / L;
        
        Y = histtransform(x, h, v);
        
        figure(9);
        imshow(Y);
        title('Case 2 : Uniform distribution [0,2]');
        
        [hn , hx] = hist(Y(:), 0:1/255:1);
        hn=100*hn/sum(hn);
        h=h*100;
        
        figure(10);
        bar(hx , hn,2,'facecolor','b');
        hold on;
        stem(v,h,'LineWidth',1,'Color','r');
        plot(v,h,'LineWidth',1,'Color','r');
        xlim([min(v)-0.02,max(v)+0.02]);
        set(gca,'XTick',v,'XTickLabelRotation',45,'XTickLabel',sprintf('%0.2f\n',v));
        legend({'Y','[v,h]'},'FontSize',8,'Location','northeast')
        grid on;
        title('Case 2 : Uniform distribution [0,2]');
        xlabel('Intensity')
        ylabel('Histogram %')
        hold off;
    end

    % Case 3
    if(choise==3)
        L = 10;
        v = linspace (0, 1, L);
        h = normpdf(v, 0.5) / sum(normpdf(v, 0.5));
        Y = histtransform(x, h, v);
        
        figure(11);
        title('Case 3 : Normal distribution mean=0.5 sigma=1');
        imshow(Y);
        
        [hn , hx] = hist(Y(:), 0:1/255:1);
        hn=100*hn/sum(hn);
        h=h*100;
        
        figure(12);
        bar(hx , hn,2,'facecolor','b');
        hold on;
        stem(v,h,'LineWidth',1,'Color','r');
        plot(v,h,'LineWidth',1,'Color','r');
        xlim([min(v)-0.02,max(v)+0.02]);
        set(gca,'XTick',v,'XTickLabelRotation',45,'XTickLabel',sprintf('%0.2f\n',v));
        legend({'Y','[v,h]'},'FontSize',8,'Location','northeast')
        title('Case 3 : Normal distribution mean=0.5 sigma=1');
        xlabel('Intensity')
        ylabel('Histogram %')
        grid on;
        hold off;
    end

        

    %pdf2hist
    if(choise==4||choise==5||choise==6)
%         syms n; %symbolic variable        
        if(choise==4)
            d=[0:0.1:1];
%             f(n)= heaviside(n)-heaviside(n-1);
            f=@uniformpdf1; %uniform pdf [0,1]
            h = pdf2hist(d, f);
        elseif(choise==5)
            d=[0:0.1:1];
%             f(n)=(heaviside(n)-heaviside(n-2))/2;
            f=@uniformpdf2; %uniform pdf [0,2]
            h = pdf2hist(d, f);
        else
            sigma=0.1;
            mean=0.5;

             d=linspace(0,1,20);
%             d=linspace(mean-2*sigma,mean+2*sigma,20);
%             f(n)=(1/sqrt(2*pi*(sigma^2)))*exp(-((n-mean)^2)/(2*(sigma^2))); %symbolic function
            f=@normalpdf; %normal pdf with mean =0.5 and sigma =0.1
            h = pdf2hist(d, f);
            
        end
        
        v=zeros(length(d)-1,1); 
        for i=1:length(d)-1 %defining intensity at the half of each interval
            v(i)=abs(d(i)+d(i+1))/2;
        end
        Y = histtransform(x, h, v);
        
        figure(13);
        imshow(Y);
        if(choise==4)
            title('Uniform distribution [0,1]');
            [hn , hx] = hist(Y(:), 0:1/255:1);
        elseif(choise==5)
            title('Uniform distribution [0,2]');
            [hn , hx] = hist(Y(:), 0:1/255:2);
        else
            title('Normal distribution mean=0.5 sigma=0.1');
            [hn , hx] = hist(Y(:), 0:1/255:1);
        end
        
        hn=100*hn/sum(hn); %making the histogram %
        h=h*100;
        
        figure(14);
        
        bar(hx , hn,2,'facecolor','b');
        

        hold on;
        stem(v,h,'LineWidth',1,'Color','r');
        plot(v,h,'LineWidth',1,'Color','r');
        xlim([min(v)-0.02,max(v)+0.02]);
        set(gca,'XTick',v,'XTickLabelRotation',45,'XTickLabel',sprintf('%0.2f\n',v));
        legend({'Y','[v,h]'},'FontSize',8,'Location','northeast')
        grid on;
        xlabel('Intensity')
        ylabel('Histogram %')
        if(choise==4)
            title('Uniform distribution [0,1]');
        elseif(choise==5)
            title('Uniform distribution [0,2]');
        else
            title('Normal distribution mean=0.5 sigma=0.1');
        end
        hold off;
    end
end
