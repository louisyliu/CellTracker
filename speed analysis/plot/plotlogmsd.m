function plotlogmsd(meanMSD, timeInterval, scale, fitRatio)
%PLOTLOGMSD Plot and analyze MSD on a log-log scale
%
%   plotlogmsd(meanMSD) plots the mean square displacement data on a log-log
%   scale and fits a line to the data to estimate the slope. The slope is
%   displayed on the graph.
%
%   plotlogmsd(meanMSD, timeInterval) specifies the time interval between
%   data points. Default is 1.
%
%   plotlogmsd(meanMSD, timeInterval, scale) scales the MSD data by a factor
%   of scale^2. Default is 1.
%
%   plotlogmsd(meanMSD, timeInterval, scale, fitRatio) specifies the ratio
%   of data points to use for fitting the line. fitRatio can be a scalar
%   (e.g., 0.6 to use the first 60% of data points) or a two-element vector
%   (e.g., [0.1 0.7] to use the first 10% and last 30% of data points).
%   Default is [0.1 0.7].
%
% Inputs:
%   meanMSD - Vector of mean square displacement data.
%   timeInterval - Scalar specifying the time interval between data points.
%                  Default is 1.
%   scale - Scalar specifying the scaling factor for MSD data. Default is 1.
%   fitRatio - Scalar or two-element vector specifying the ratio of data
%              points to use for fitting the line. Default is [0.1 0.7].
%
% Examples:
%   % Plot MSD data with default settings
%   plotlogmsd(meanMSD)
%
%   % Plot MSD data with a time interval of 0.1 and a scaling factor of 2
%   plotlogmsd(meanMSD, 0.1, 2)
%
%   % Plot MSD data and fit a line using the first 20% and last 40% of data
%   plotlogmsd(meanMSD, 1, 1, [0.2 0.6])

if nargin < 4
    fitRatio = [0.1 0.7];
end
if nargin < 3
    scale = 1;
end
if nargin < 2
    timeInterval = 1;
end

% real unit
t = (1:length(meanMSD))*timeInterval;
meanMSD =  meanMSD*scale*scale;

logt = log(t');
logMSD = log(meanMSD);

% for j = 1:9
% fitRatio(2) = j/10;

% fit slope
ft = fittype('poly1');
nFit = length(fitRatio);

if nFit == 1
    idx = floor(1:length(meanMSD)*(1-fitRatio));
    fitresult = fit(logt(idx), logMSD(idx), ft);
    p1 = fitresult.p1;
    p2 = fitresult.p2;
elseif nFit == 2
    idx{1} = floor(1:length(meanMSD)*fitRatio(1));
    idx{2} = floor(length(meanMSD)*(1-fitRatio(2))):length(meanMSD);
    for i = 1:2
        fitresult = fit(logt(idx{i}), logMSD(idx{i}), ft);
        p1(i) = fitresult.p1;
        p2(i) = fitresult.p2;
    end
end
% end

plotslope(t, p1, p2, idx)
loglog(t, meanMSD, 'k.', 'MarkerSize',14);

% set axis
yl = log10(meanMSD);
ylim([10^floor(min(yl)) 10^(ceil(max(yl))+1.5)]);
xl = log10(t);
xlim([10^(floor(min(xl))-0.5) 10^(ceil(max(xl))+0.5)]);
xlabel('Time');
ylabel('MSD');
hold off
end

function plotslope(t, p1, p2, idx)
if iscell(idx) % two seg
    for i = 1:2
        x = t(idx{i});
        y = exp(p2(i)+2)*t(idx{i}).^(p1(i));
        loglog(x(2:end-3), y(2:end-3), 'k');
        hold on
        text(x(floor(end/2)), y(floor(end/2))*exp(1), sprintf('Slope: %.1f', p1(i)), ...
            "FontSize", 10, "HorizontalAlignment","center");
    end
else % one seg
    x = t(idx);
    y = exp(p2+2)*t(idx).^(p1);
    loglog(x(2:end-3), y(2:end-3), 'k');
    hold on
    text(x(floor(end/2)), y(floor(end/2))*exp(1), sprintf('Slope: %.1f', p1), ...
        "FontSize", 10, "HorizontalAlignment","center");
end
end