%リランキングを行う
function [sorted_score,sorted_idx] = reranking(trainDir, evalDir, n)
    net = resnet101;
    pos_list = makeImageList(trainDir);
    neg_list = makeImageList("bgimg");
    pos_list = {pos_list{1:n}};
    neg_list = {neg_list{1:500}};
    list = {pos_list{:} neg_list{:}};

    model = trainSVM(net, list, n, 500);

    eval_list = makeImageList(evalDir);
    [sorted_score,sorted_idx] = predictSVM(net, model, eval_list);
end

function model = trainSVM(net, list, n1, n2)
    %特徴量取得
    data = getDcnnf(list, net);
    %正解ラベルの作成
    train_label = [ones(n1, 1); ones(n2, 1)*(-1)];
    %学習
    model = fitcsvm(data, train_label,'KernelFunction','linear');
    fprintf('学習終了\n');
end

function [sorted_score,sorted_idx] = predictSVM(net, model, list)
    %特徴量取得
    data = getDcnnf(list, net);

    [label,score] = predict(model, data);

    % 降順 ('descent') でソートして，ソートした値とソートインデックスを取得します．
    [sorted_score,sorted_idx] = sort(score(:,2),'descend');
    
    % list{:} に画像ファイル名が入っているとして，
    % sorted_idxを使って画像ファイル名，さらに
    % sorted_score[i](=score[sorted_idx[i],2])の値を出力します．
    fprintf('結果出力\n');
    for i=1:numel(sorted_idx)
      fprintf('%s %f\n',list{sorted_idx(i)},sorted_score(i));
    end
end

