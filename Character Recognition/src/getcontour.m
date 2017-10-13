 function c = getcontour(x);
   
    x(x<=0.5)=0; 
    x(x>0.5)=1;
    
    xtemp=1-x;

    BW = imdilate(xtemp, strel('disk',1));
    xtemp=BW-xtemp;
    xtemp=bwmorph(xtemp,'thin','inf');
    
    xtemp = padarray(xtemp,[floor(abs(100-size(xtemp,1))/2) floor(abs(80-size(xtemp,2))/2)]);
%     figure;imshow(xtemp);
    [m,n]=size(xtemp);

    for qq=1:2 %for 2 contours
    flag=0;
    indexX=0;
    indexY=0;
   %find one pixel that is 1 to start from there searching for neighboors
    for i=1:m
        for j=1:n
            if(xtemp(i,j)==1)
                flag=1;
                indexX=i;
                indexY=j;
                xtemp(i,j)=0;
                tempc{qq}(indexX,indexY)=1;
                break
            end
        end

        if flag==1
            break
        end
    end

    
        j=1;
        flag1=0;
        flag2=0;
        i=0;
        ss=sum(sum(xtemp));
        if qq==2 %for the seccond conjur only
            ss=sum(sum(xtemp));
            if(ss>=4) %need at least 4 points to create a contour
                for i=1:m
                    for j=1:n
                        flag=0;
                        if(xtemp(i,j)==1)

                            for k=(i-1):1:(i+1) % search 3x3 neighborhood for neighboors
                                for l=(j-1):1:(j+1)
                                    if(k>0&&l>0&&(k~=i||l~=j))
                                        if(xtemp(k,l)==1)
                                            flag=1;
                                        end     
                                    end
                                end
                            end

                            if (flag==0)
                                xtemp(i,j)=0;
                            end
                        end
                    end
                end
            end
        end
        
        h=ones(3,3);
        while(flag1==0)
          for k=(indexX-1):1:(indexX+1) % search 3x3  for neighboors
              for l=(indexY-1):1:(indexY+1)
                  if(k~=indexX||l~=indexY)
                      if(k>0&&l>0)
                          if (xtemp(k,l)==1)
                              indexX=k;
                              indexY=l;
                              xtemp(k,l)=0;%delete this pixel from old so if there is second contour, it will be all thats left
                              tempc{qq}(k,l)=1;%pass this pixel to the new array
                              c{qq}(j,1)=k;
                              c{qq}(j,2)=l;
                              j=j+1;
                              
                              flag2=1;
                              break
                          end
                      end
                  end
              end
              if flag2==1
                  break
              end     
          end

          if(flag2==0)
              flag1=1;
          else
              flag2=0;
              flag1=0;
          end

        end
        
    end

    

    
%     figure;imshow(1-tempc{1});
%     title('Contour 1');
%     axis on;    
%     grid on;
%     if(size(c,2)>1)
%         figure;imshow(1-tempc{2});
%         title('Contour 2');
%         axis on;
%         grid on;
%     end
 
    
%     
% %     [c1x,c1y]=find(c{1,1}==1);
% %     c{1,1}=[c1x c1y];
%     if(size(c,2)>1)
%         [c2x,c2y]=find(c{1,2}==1);
%         c{1,2}=[c2x c2y];
%     end
%     
    
    
    
                

 end