%% examine whether on border.
imshow(bw1)
hold on
for i = 1:length(ccf)
    if ccf(i).Onborder
        colorstr = 'ro';
    else
        colorstr = 'b*';
    end
    plot(ccf(i).Centroid(1),ccf(i).Centroid(2),colorstr)

end
axis equal

%%
point = [100 100; 900 800; 200 600 ];
a =zeros(1000,1000);
sizeA = size(a);
a(sub2ind(sizeA, point(:,2), point(:,1))) = 1;

pointSet = findpixelbtpoints(point);
a(sub2ind(sizeA, pointSet(:,2), pointSet(:,1))) = 1;
imshow(a)
