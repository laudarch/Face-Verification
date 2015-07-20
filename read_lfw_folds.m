% Reads a file in the format of LFW's pairs.txt, and returns a struct array describing the
% folds, with one entry per fold.  Each entry has two members, 'labels' which is a column vector
% of labels (1 for same, -1 for different), and 'pairs', which is a two-column cell array with
% the image paths in each pair.
function folds = read_lfw_folds() %pairspath

% clear all;
pairspath = 'pairs.txt';

fin = fopen(pairspath);
nums = textscan(fin, '%d %d', 1, 'collectoutput', true); % nums{1,1} = [10,300]
nfolds = nums{1}(1); %10
nperfold = nums{1}(2); %300

folds = struct('labels', {}, 'pairs', {});
for ifold = 1:nfolds
    pairs = cell(nperfold*2, 2); %(600 x 2)
    %read 300 picture info in class 1
    d = textscan(fin, '%s %d %d', nperfold, 'collectoutput', true); 
    %for class 1: d{1} = labels(subs)...,d{1,2} = (n1,n2)
    for iperfold = 1:nperfold
        sub = d{1}{iperfold};
        n1 = d{2}(iperfold, 1);
        n2 = d{2}(iperfold, 2);
        pairs(iperfold, :) = { ...
            sprintf('%s/%s_%04d.jpg', sub, sub, n1), ... %directoory of picture1
            sprintf('%s/%s_%04d.jpg', sub, sub, n2)};    %directoory of picture2
    end
    d = textscan(fin, '%s %d %s %d', nperfold, 'collectoutput', true); 
    %for class -1: d{1} = labels(subs), d{2} = n1, d{3} = labels(subs), d{4} = n2
    %read 300 picture info in class -1
    for iperfold = 1:nperfold %300
        sub1 = d{1}{iperfold};
        n1 = d{2}(iperfold);
        sub2 = d{3}{iperfold};
        n2 = d{4}(iperfold);
        pairs(nperfold+iperfold, :) = { ...
            sprintf('%s/%s_%04d.jpg', sub1, sub1, n1), ...%directoory of picture1
            sprintf('%s/%s_%04d.jpg', sub2, sub2, n2)};   %directoory of picture2
    end
    %lable: 1,-1 ; paires: directoory of picture1 to directoory of picture2
    folds(ifold) = struct('labels', {[ones(nperfold, 1); -ones(nperfold, 1)]}, ...
                          'pairs', {pairs});
end
data = struct2cell(folds);
observation = data{2}(1,:);
while 1
    s = fgetl(fin);
    if s == -1, break; end;
    assert(isempty(s)); %length(s) == 0
end
fclose(fin);
