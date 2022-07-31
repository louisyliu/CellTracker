%trajLinkedMat

for i = 1:size(trajLinkedMat, 1)
    trajmat1 = logical(trajLinkedMat(i,:));
    bwcomp = regionprops(trajmat1);
    if length(bwcomp)>1
        disp('')
    end
end