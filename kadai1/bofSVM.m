%BoFで学習を行う
function [predicted_label, scores] = bofSVM(pos_target, neg_target, codebookPath)
    pos_list = makeImageList(pos_target);
    neg_list = makeImageList(neg_target);
    list = {pos_list{1:100} neg_list{1:100}};
    codebook = makeColorcode(list, codebookPath);
    bof = makeBof(list, codebook);
    [predicted_label, scores] = crossValidationSVM(bof, 100, 100, 2);
end

function codebook = makeColorcode(list, name)
    if exist(name)==2
        fprintf("%sを読み込みます\n", name);
        load(name);
    else
        fprintf("codebookを作成します\n");
        Features=[];
        for i=1:200
          I=rgb2gray(imread(list{i}));
          p=createRandomPoints(I,2000);
          [f,p2]=extractFeatures(I,p);
          Features=[Features; f];
        end
        %Features=Features(randperm(size(Features, 1), 50000), :);
        %kmeansで代表ベクトルを選択
        [id,codebook]=kmeans(Features, 1000);
        save(name, "codebook");
        fprintf("codebookを%sとして保存しました\n", name);
    end
    fprintf("codebook取得完了\n");
end

function bof = makeBof(list, codebook)
    fprintf("bofを作成します");
    %bofを計算
    bof = zeros(200, 1000);
    for j=1:200   
        I=rgb2gray(imread(list{j}));
        %特徴点ランダム抽出
        p=createRandomPoints(I,2000);
        [f,p2]=extractFeatures(I,p);

        %各特徴に対して類似のコードブックに投票
        for i=1:size(p2, 1) 
            ff = repmat(f(i, :), 1000, 1);
            b = (codebook-ff).^2;
            cc = sqrt(sum(b'));
            [m, index] = min(cc);
            bof(j, index) = bof(j, index)+1;
        end
    end
    bof = bof ./ sum(bof,2); %正規化
    fprintf("bof作成終了");
end
