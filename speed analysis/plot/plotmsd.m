function plotmsd(meanMSD, stdMSD, timeInterval, scale)

if nargin < 3
    timeInterval = 1;
    scale = 1;
elseif nargin < 4
    scale = 1;
end

areaerrorbar((0:length(meanMSD)-1)*timeInterval, meanMSD*scale*scale, stdMSD*scale*scale, 'k');
xlim([0 (length(meanMSD)-1)*timeInterval]);
xlabel('\Deltat');
ylabel('MSD');

end