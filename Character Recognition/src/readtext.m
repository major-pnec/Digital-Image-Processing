function ch=readtext(y)
load('letters.mat'); %l

lines=getlines(y);

letters=getletters(lines);
z=letters{1}{1};

%find the reference from given letters
for i=1:26
    reference{i}=getcontour(l{1,i});
    [m n]=size(reference{i});
    contour1=reference{i}{1};
    r1Ref{i}=contour1(:,1)+1j*contour1(:,2);

    if(n>1)
        contour2=reference{i}{2};
        r2Ref{i}=contour2(:,1)+1j*contour2(:,2);

    else
        r2Ref{i}=[];
    end
        
end

%finding which char represents each one of the letter images
numrows=length(letters);
for i=1:numrows
    numletters=length(letters{i});
    for z=1:numletters
        lc{i}{z}=getcontour(letters{i}{z});
        [m n]=size(lc{i}{z});
        contour1=lc{i}{z}{1};
        r1{i}{z}=contour1(:,1)+1j*contour1(:,2);

        if(n>1)
            contour2=lc{i}{z}{2};
            r2{i}{z}=contour2(:,1)+1j*contour2(:,2);
        else
             r2{i}{z}=[];
        end
        ch{i}{z}=getChar(r1Ref,r2Ref,r1{i}{z},r2{i}{z});

    end
    
end



end