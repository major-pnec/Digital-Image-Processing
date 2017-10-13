function xc=bayer2rgb(x,M,N,method)
    [Mo,No]=size(x);
    Th=Mo/M;%step at horizontal
    Tv=No/N;%step at vertical
    xc=zeros(M,N,3,'double');
    
    Green=zeros(Mo,No,'double');
    Blue=zeros(Mo,No,'double');
    Red=zeros(Mo,No,'double');
    %save each color to different array
    Green(1:2:end,1:2:end)=x(1:2:end,1:2:end); % bayer patern for green
    Green(2:2:end,2:2:end)=x(2:2:end,2:2:end);
    Red(2:2:end,1:2:end)=x(2:2:end,1:2:end);   % bayer patern for red
    Blue(1:2:end,2:2:end)=x(1:2:end,2:2:end);  % bayer patern for blue

    
    
    if strcmp(method,'nearest')
       
        xc=nearest(Red,Green,Blue,xc,Th,Tv,Mo,No);
        
    else
       %padd the channels in order to avoid extra if statements 
       Green=paded(Green,Mo,No);
       Red=paded(Red,Mo,No);
       Blue=paded(Blue,Mo,No);

       xc=bilinear(Red,Green,Blue,xc,Th,Tv,Mo,No);
       
      
    end
 
end

function xpaded=paded(x,M,N)

        xpaded=zeros(M+4,N+4,'double');
        xpaded(1,3:end-2)=x(1,:);%copy the 1st row
        xpaded(2,3:end-2)=x(2,:);%copy the 2ond row
        xpaded(3:end-2,3:end-2)=x(:,:);%copy all the rest array
        xpaded(end-1,3:end-2)=x(M-1,:);%copy last-1 row
        xpaded(end,3:end-2)=x(M,:);%copy last row
        xpaded(:,1)=xpaded(:,3);%copy 1st column
        xpaded(:,2)=xpaded(:,4);%copy 2ond column
        xpaded(:,end-1)=xpaded(:,end-3);%copy last -1 column
        xpaded(:,end)=xpaded(:,end-2);%copy last column

end



      
    function xc=nearest(Red,Green,Blue,xc,Th,Tv,Mo,No)
      
      %variables init
      indexX=0;
      indexY=0;

      for i=1:Th:Mo
          indexX=indexX +1; %keep track where we are at new image X axon
          bayerI=floor(i);  %need to round to the closest value because 'i' might be float           
          indexY=0;%new row, re-intialize indexY
          
          for j=1:Tv:No
              indexY=indexY+1; %keep track where we are at new image Y axon
              bayerJ=floor(j);
              %re-intialize distance for next round
              distgreen=1000;
              distred=1000;
              distblue=1000;
              
              for k=(bayerI-1):1:(bayerI+1) % search 3x3 neighborhood for each bayer 
                  for l=(bayerJ-1):1:(bayerJ+1)%cell in order to find the closest neighbor
                      
                      if (k>0&&l>0)&&(k<=Mo && l<=No) %checking for board limits
                           
                            dist=sqrt((k-i)^2+(l-j)^2); %comptuting current distance from the pixel we are checking
                            
                            %checking for green cells
                            if((Green(k,l)~=0) && dist<=distgreen) %if this cell is green and its distance is less than previous distance
                                distgreen=dist; %set the new minimum distance
                                xc(indexX,indexY,2)=Green(k,l);  %set this green pixel in the new image
                              
                            end
                            %checking for red cells
                            if((Red(k,l)~=0) && dist<=distred)
                                distred=dist;
                                xc(indexX,indexY,1)=Red(k,l);
                               
                            end
                            %checking for blue cells
                            if((Blue(k,l)~=0) && dist<=distblue)
                                distblue=dist;
                                xc(indexX,indexY,3)=Blue(k,l);
                               
                            end                       
                      end   
                      
                  end
 
              end  

          end

      end
    end


   
    function xc=bilinear(Red,Green,Blue,xc,Th,Tv,Mo,No)
    
      indexX=0;
      indexY=0;
      for i=3:Th:Mo+2
          indexX=indexX +1; %keep track where we are at new image X axon
          bayerI=floor(i);  %need to round to the closest value because 'i' might be float   
          indexY=0;   %reintialize indexY for new row
          for j=3:Tv:No+2
              indexY=indexY+1; %keep track where we are at new image Y axon
              bayerJ=floor(j);
      
              redFlag=0;   
              greenFlag=0;
              blueFlag=0;

              if(Green(bayerI,bayerJ)~=0)%if current pixel is green
                  greenFlag=1;
                  xc(indexX,indexY,2)=Green(bayerI,bayerJ);
                  if(Red(bayerI,bayerJ+1)~=0) %if the pixel on our right is red
                      redFlag=1; %we are at red row
                  else
                      blueFlag=1; %we are at blue row
                  end
                  
              elseif(Red(bayerI,bayerJ)~=0)
                  redFlag=1; 
                  xc(indexX,indexY,1)=Red(bayerI,bayerJ);
              else
                  blueFlag=1;
                  xc(indexX,indexY,3)=Blue(bayerI,bayerJ);
                 
              end
              
              if(greenFlag==1 && blueFlag==1) %we are at a green pixel in a blue row
                  %find blue pixels;
                  distfromtop=i-bayerI-2;
                  distfrombot=bayerI+2-i;
                  if(distfromtop<distfrombot) %find if top blue pixels are closer than bottom
                      x1=bayerI-2;
                      x2=bayerI;
                      y1=bayerJ-1;
                      y2=bayerJ+1;
                  else
                      x1=bayerI;
                      x2=bayerI+2;
                      y1=bayerJ-1;
                      y2=bayerJ+1;
                      
                  end
                      %bilinear method
                      I1=Blue(x1,y1)*(y2-j)/(y2-y1)+Blue(x1,y2)*(j-y1)/(y2-y1);
                      I2=Blue(x2,y1)*(y2-j)/(y2-y1)+Blue(x2,y2)*(j-y1)/(y2-y1);
                      I=I1*(x2-i)/(x2-x1)+I2*(i-x1)/(x2-x1);
                      xc(indexX,indexY,3)=I;
                      
                      %lets find red pixels
                      distfromleft=j-bayerJ-2;
                      distfromright=bayerJ+2-j;
                      if(distfromleft<distfromright) %if red pixels on left side are closer than left pixels on right side
                          x1=bayerI-1;
                          x2=bayerI+1;
                          y1=bayerJ-2;
                          y2=bayerJ;
                      else
                          x1=bayerI-1;
                          x2=bayerI+1;
                          y1=bayerJ;
                          y2=bayerJ+2;
                      end
                      
                      I1=Red(x1,y1)*(y2-j)/(y2-y1)+Red(x1,y2)*(j-y1)/(y2-y1);
                      I2=Red(x2,y1)*(y2-j)/(y2-y1)+Red(x2,y2)*(j-y1)/(y2-y1);
                      I=I1*(x2-i)/(x2-x1)+I2*(i-x1)/(x2-x1);
                      xc(indexX,indexY,1)=I;
              end
              
              if(greenFlag==1 && redFlag==1) %we are at green pixel at red row
                %lets find blue pixels
                  distfromleft=j-bayerJ-2;
                  distfromright=bayerJ+2-j;
                  if(distfromleft<distfromright)
                      x1=bayerI-1;
                      x2=bayerI+1;
                      y1=bayerJ-2;
                      y2=bayerJ;
                  else
                      x1=bayerI-1;
                      x2=bayerI+1;
                      y1=bayerJ;
                      y2=bayerJ+2;
                  end
                  
                      I1=Blue(x1,y1)*(y2-j)/(y2-y1)+Blue(x1,y2)*(j-y1)/(y2-y1);
                      I2=Blue(x2,y1)*(y2-j)/(y2-y1)+Blue(x2,y2)*(j-y1)/(y2-y1);
                      I=I1*(x2-i)/(x2-x1)+I2*(i-x1)/(x2-x1);
                      xc(indexX,indexY,3)=I;
                  
                      
                      %lets find red pixels
                      
                  distfromtop=i-bayerI-2;
                  distfrombot=bayerI+2-i;
                  if(distfromtop<distfrombot)
                      x1=bayerI-2;
                      x2=bayerI;
                      y1=bayerJ-1;
                      y2=bayerJ+1;
                  else
                      x1=bayerI;
                      x2=bayerI+2;
                      y1=bayerJ-1;
                      y2=bayerJ+1;
                      
                  end
                      I1=Red(x1,y1)*(y2-j)/(y2-y1)+Red(x1,y2)*(j-y1)/(y2-y1);
                      I2=Red(x2,y1)*(y2-j)/(y2-y1)+Red(x2,y2)*(j-y1)/(y2-y1);
                      I=I1*(x2-i)/(x2-x1)+I2*(i-x1)/(x2-x1);
                      xc(indexX,indexY,1)=I;

              end
              
              if(greenFlag==0 && redFlag==1) %we are at red pixel in red row
                  %blue pixels are in in diagonal positions
                  x1=bayerI-1;
                  x2=bayerI+1;
                  y1=bayerJ-1;
                  y2=bayerJ+1;
 
                  I1=Blue(x1,y1)*(y2-j)/(y2-y1)+Blue(x1,y2)*(j-y1)/(y2-y1);
                  I2=Blue(x2,y1)*(y2-j)/(y2-y1)+Blue(x2,y2)*(j-y1)/(y2-y1);
                  I=I1*(x2-i)/(x2-x1)+I2*(i-x1)/(x2-x1);  
                  xc(indexX,indexY,3)=I;
                  
                  
                  %green pixels are in cross possitions
                 I1=Green(bayerI-1,bayerJ)*(bayerJ+1-j)+Green(bayerI,bayerJ+1)*(j-bayerJ);
                 I2=Green(bayerI,bayerJ-1)*(bayerJ+1-j)+Green(bayerI+1,bayerJ)*(j-bayerJ);
                 I=I1*(bayerI-i)+I2*(i-bayerI+1);

                  xc(indexX,indexY,2)=I;
              end
              
              if(greenFlag==0 && blueFlag==1) %we are at blue pixel at blue row
                  %lets find red pixels
                  x1=bayerI-1;
                  x2=bayerI+1;
                  y1=bayerJ-1;
                  y2=bayerJ+1;
                  
                  I1=Red(x1,y1)*(y2-j)/(y2-y1)+Red(x1,y2)*(j-y1)/(y2-y1);
                  I2=Red(x2,y1)*(y2-j)/(y2-y1)+Red(x2,y2)*(j-y1)/(y2-y1);
                  I=I1*(x2-i)/(x2-x1)+I2*(i-x1)/(x2-x1);
                  xc(indexX,indexY,1)=I;
                  
                  %lets find green pixels
                  
                 I1=Green(bayerI-1,bayerJ)*(bayerJ+1-j)+Green(bayerI,bayerJ+1)*(j-bayerJ);
                 I2=Green(bayerI,bayerJ-1)*(bayerJ+1-j)+Green(bayerI+1,bayerJ)*(j-bayerJ);
                 I=I1*(bayerI-i)+I2*(i-bayerI+1);
                 xc(indexX,indexY,2)=I;
              end
          end 

      end
 
    end


      
