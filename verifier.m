function  verifier(file, root, output)
%setup vfeat
run('vlfeat-0.9.17/toolbox/vl_setup')
%% READ FILE
pairspath = file';

fin = fopen(pairspath);
nums = textscan(fin, '%d %d', 1, 'collectoutput', true); % nums{1,1} = [10,300]
nfolds = nums{1}(1); %10
nperfold = nums{1}(2); %300
same = cell(3000,3);
diff = cell(3000,4);
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
        
        same{(ifold-1)*nperfold+iperfold,1} = sub;
        same{(ifold-1)*nperfold+iperfold,2} = n1; 
        same{(ifold-1)*nperfold+iperfold,3} = n2;
        
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
        
        diff{(ifold-1)*nperfold+iperfold,1} = sub1;
        diff{(ifold-1)*nperfold+iperfold,2} = n1; 
        diff{(ifold-1)*nperfold+iperfold,3} = sub2;
        diff{(ifold-1)*nperfold+iperfold,4} = n2;
        
        pairs(nperfold+iperfold, :) = { ...
            sprintf('%s/%s_%04d.jpg', sub1, sub1, n1), ...%directoory of picture1
            sprintf('%s/%s_%04d.jpg', sub2, sub2, n2)};   %directoory of picture2
    end
    %lable: 1,-1 ; paires: directoory of picture1 to directoory of picture2
    folds(ifold) = struct('labels', {[ones(nperfold, 1); -ones(nperfold, 1)]}, ...
                          'pairs', {pairs});
end

%% FEATURES EXTRACTION
DATA = struct2cell(folds);

f_num = 6; %number of feautures we select
FEATURES = zeros(6000, 128*f_num);%6000 512
    
    %left eye
     s_c = 26/12;%24
     h_e = 110;
     x_e1 = 148;
     y_e1 = h_e+4;
     %right eyebrow
     x_e2 = 154;
     y_e2 = h_e-3;
%      %left eyebrow
     x_e3 = 98;
     y_e3 = h_e-3;
     %right eye
     x_e4 = 104;
     y_e4 = h_e+4;
     
     %area between eyebrows
     s_nt = 26/12;
     x_n1 = 126;
     y_n1 = 112;
     %bridge of nose
%      s_nd = 28/12;
%      x_n2 = 126;
%      y_n2 = 142;
%      %right cheek
%      s_ck = 24/12;
%      x_n3 = 116;
%      y_n3 = 150;
% %      %left cheek
%      x_n4 = 136;
%      y_n4 = 150;
  
%      s_m = 16/12;
%      h_m = 162;
%      %right lip
%      x_m1 = 117;
%      y_m1 = h_m;
% 
%      %left leap
%      x_m3 = 135;
%      y_m3 = h_m;
     
     %entire mouth
     s_mc = 26/12;
     x_m = 127;
     y_m = 162; 
     
     x = 125;
     y = 125;  
     size1 = 64/12;
     %size2 = 80/12;
     size3 = 96/12;
    
%      %center of mouth
%      x_m2 = 127;
%      y_m2 = h_m-2;
%      
%      %right side of nose
%      s_ns = 16/12;
%      x_n5 = 118;
%      y_n5 = 150;
%      
%      %left side of nose
%      x_n6 = 134;
%      y_n6 = 150;
     
%     frames = [
%              x_e1 x_e2 x_e3 x_e4 x_n1 x_n2 x_n3 x_n4 x_m1 x_m3 x_m  x     x;
%              y_e1 y_e2 y_e3 y_e4 y_n1 y_n2 y_n3 y_n4 y_m1 y_m3 y_m  y     y;
%              s_c  s_c  s_c  s_c  s_nt s_nd s_ck s_ck s_m  s_m  s_mc size1 size3;
%              0    0    0    0    0    0    0    0    0    0    0    0     0
%              ];
%73.65
%     frames = [
%              x_e2 x_e3  x_n1 x_m  x      x;
%              y_e2 y_e3  y_n1 y_m  y      y;
%              s_c  s_c   s_nt s_mc size3  size1;
%              0    0     0    0    0      0
%              ];    
    frames = [
             x_e2 x_e3  x_e1 x_e4  x      x;
             y_e2 y_e3  y_e1 y_e4  y      y;
             s_c  s_c   s_c  s_c   size3  size1;
             0    0     0    0     0      0
             ];
for fold_idx = 1:nfolds %10 nfolds
    
    target = DATA{fold_idx*2};
    
    for i  = 1:nperfold*2 %300*2 nperfold
        
        t1 = target(i,1);
        dir_1 = [ root '/' t1{1}];
        t2 = target(i,2);
        dir_2 = [ root '/' t2{1}];
        im_a = imread(dir_1);
        im_b = imread(dir_2);
        
        %show picture
        %imshow(im_a);
        %siigle precision
        im_a = single(im_a) ./ 255;
        im_b = single(im_b) ./ 255;
 
        %window for mouth
        [fa,da] = vl_sift(im_a, 'frames', frames);
        [fb,db] = vl_sift(im_b, 'frames', frames);
        temp = da' - db';
        %sub_feature = [temp(1,:) temp(2,:) temp(3,:) temp(4,:) temp(5,:) temp(6,:) temp(7,:) temp(8,:) temp(9,:) temp(10,:) temp(11,:) temp(12,:) temp(13,:)];
        sub_feature = [temp(1,:) temp(2,:) temp(3,:) temp(4,:) temp(5,:) temp(6,:)];
        FEATURES((fold_idx-1)*600+i,:) = sub_feature;
    end
end
disp('features extraction done');

%% NORMALIZATION
eps = 0.0001; %to avoid 'nan' 'inf'
for i=1:128*f_num %128* number of features
    mean_value = mean(FEATURES(:,i));
    std_value = std(FEATURES(:,i)) + eps;
    FEATURES(:,i) =  (FEATURES(:,i)- mean_value)/std_value;
end

%% CROSS VALIDATION (10 FOLD)
    accuracy = [];
    section = 600;%600
    lablels = DATA{1}(1:600,:);
    trainlabels = [lablels; lablels; lablels; lablels; lablels; lablels; lablels; lablels; lablels];
    testlabels = lablels;
    truelabels = [trainlabels; lablels];
    pred_v = zeros(6000,1);
    
    Output = fopen(output, 'w');
    fprintf(Output, '10    300\n');  
    
    for VC = 1:nfolds
        if VC == 1
            trainfeats = FEATURES(VC*section+1:end,:);
            testfeats =  FEATURES(1:VC*section,:);
        elseif VC == 10
            trainfeats = FEATURES(1:(VC-1)*section,:);
            testfeats =  FEATURES((VC-1)*section+1:end,:);
        else %VC == 2~9
            trainfeats = [FEATURES(1:(VC-1)*section,:); FEATURES(VC*section+1:end,:)];
            testfeats =  FEATURES((VC-1)*section+1:VC*section,:);
        end
    
%% TRAINING ( SVM )
        model = svmtrain(trainlabels, trainfeats);
        %option:
        %default(14 with window) :    mean of accuracy rates: 72.4667(%) 
        %             standard deviationsof the accuracy rates: 1.3352
        %default2(14):mean of accuracy rates:  70.7667(%)
        %             standard deviationsof the accuracy rates: 2.1917
        %default2(17):mean of accuracy rates:  72.1833(%)
        %             standard deviationsof the accuracy rates: 1.8500
        %default2(10):mean of accuracy rates:  72.2500(%)
        %             standard deviationsof the accuracy rates: 1.6316
        %'-t 3 -c 1': mean of accuracy rates: 71.0167(%)
        %             standard deviationsof the accuracy rates: 1.4454
        
        
%% PREDICTION ( SVM )
        [preds, acc, decvals] = svmpredict(testlabels, testfeats, model);
        
        pred_v((VC-1)*600+1:VC*600,1) = decvals(:,1);
        
        for n = 1: nperfold
            fprintf(Output, '%6.4f    ', decvals(n,1));
            fprintf(Output, '%s    ', same{(VC-1)*nperfold+n,1});
            fprintf(Output, '%d    ', same{(VC-1)*nperfold+n,2});
            fprintf(Output, '%d', same{(VC-1)*nperfold+n,3});
            fprintf(Output, '\n');
        end
        for n = 1: nperfold
            fprintf(Output, '%6.4f    ', decvals( nperfold+n,1));
            fprintf(Output, '%s    ', diff{(VC-1)*nperfold+n,1});
            fprintf(Output, '%d    ', diff{(VC-1)*nperfold+n,2});
            fprintf(Output, '%s    ', diff{(VC-1)*nperfold+n,3});
            fprintf(Output, '%d', diff{(VC-1)*nperfold+n,4});
            fprintf(Output, '\n');
        end
        
        if accuracy == 0
            accuracy = [acc(1)];
        else
            accuracy = [accuracy acc(1)];
        end
    end
disp('the mean of the accuracy rates over the ten folds(accuracy):')    
disp(mean(accuracy));
disp('the standard deviationsof the accuracy rates over the ten folds:') 
disp(std(accuracy));
%% WRITE THE OUTPUT FILE
[tp, fp, threshes, eer, eeThresh] = roc(truelabels,pred_v);
plot(fp, tp,'-b');
grid;
xlabel('False recognition percentage');
ylabel('Recognition percentage');
title('ROC');

end
