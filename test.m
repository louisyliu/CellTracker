% filename = 'E:\exp_script\GitProject\sample\ofandsinglecelltracking_highdensity\20Xsinglecelltracking30ms20fps10s.nd2';
filename = 'G:\exp_script\GitProject\sample\ofandsinglecelltracking_highdensity\20Xsinglecelltracking30ms20fps10s.nd2';
ima = nd2read(filename,1:10); % can't read tif for updated nd2sdkmatlab.
% ima = img(500:1500, 500:1500,:);
% imshow(im,[])
%%
for i = 1:10
    im = ima(:,:,i);
close
[finalImg, ~] = bandpassfilt(im,0,6);
imshow(finalImg)
%%
close
bw = imbinarize(imgaussfilt(finalImg,1),'adaptive');
imshow(bw)
%%
close
bw1 = imopen(bw, strel('disk',1));
imshow(bw1)
bw2 = bwareaopen(bw, 8);
imshow(bw2);
asdf(:,:,i) = bw2;
end
%%
close
CC = bwconncomp(ske,8);
re = regionprops(ske, 'all');
S = regionprops(CC,'MinorAxisLength');
ess = [S.MinorAxisLength];
numPixels  = cellfun(@numel, CC.PixelIdxList);
[nsort,idx] = sort(ess,'descend');
bg = false(size(bw));
for i = 1:3
    bg(CC.PixelIdxList{idx(i)}) = 1;
    imshow(bg)
    hold on
end
nsort(1:10)
%% 
ske = bwskel(bw2);
imshow(ske)
bw3 = activecontour(finalImg,ske);
imshow(bw3)
%%
[finalImg, filter] = bandpassfilt(s,7,9);
imshow(finalImg)
