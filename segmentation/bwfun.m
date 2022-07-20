function imgBw = bwfun(func, imgOriginal)
%BWFUN Apply a function to each image in an image sequence.
%   IMGBW = BWFUN(IMGORIGINAL, FUNC) applies the function FUNC to the
%   contents of each image of 3D image sequence IMGORIGINAL, one image at a
%   time. BWFUN then concatenates the outputs from FUNC into the output
%   array IMGBW, so that for the ith image of IMGORIGINAL, IMGBW(i) =
%   FUNC(IMGORIGINAL{i}). The input argument func is a function handle to a
%   function that takes one input image and returns processed image. The
%   output from func can have any data type, so long as objects of that
%   type can be concatenated. The array IMGBW and array IMGORIGINAL
%   have the same size.       

imgBw = false(size(imgOriginal));
nImg = size(imgOriginal, 3);

for i = 1:nImg
    imgBw(:,:,i) = feval(func,imgOriginal(:,:,i));
    dispbar(i, nImg);
end
end
