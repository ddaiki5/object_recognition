%5分割クロスバリデーションによるSVMの学習を行う
function [predicted_label, scores] = crossValidationSVM(imgs, n1, n2, mode)
    data_pos = imgs(1:n1, :);
    data_neg = imgs(n1+1:n1+n2, :);
    cv=5;
    n = 100;
    idx=[1:n];
    accuracy=[];
    
    % idx番目(idxはcvで割った時の余りがi-1)が評価データ
    % それ以外は学習データ
    for i=1:cv 
        fprintf("%d回目 学習開始\n", i);
        %trainデータとvalidデータを分割
        train_pos=data_pos(find(mod(idx,cv)~=(i-1)),:);
        eval_pos =data_pos(find(mod(idx,cv)==(i-1)),:);
        train_neg=data_neg(find(mod(idx,cv)~=(i-1)),:);
        eval_neg =data_neg(find(mod(idx,cv)==(i-1)),:);
        
        train=cat(1, train_pos, train_neg);         
        eval=cat(1, eval_pos, eval_neg);
        
        %正解ラベルを作成
        train_label = [ones(n-n/cv, 1); ones(n-n/cv, 1)*(-1)];%160×1
        eval_label = [ones(n/cv, 1); ones(n/cv, 1)*(-1)];%40×1
        
        %線形モデルか非線形モデルかを選択
        if mode==1
            model = fitcsvm(train, train_label,'KernelFunction','linear');
        else
            model = fitcsvm(train, train_label,'KernelFunction','rbf', 'KernelScale','auto');
        end          
        [predicted_label, scores] = predict(model, eval);

        printResult(eval_label, predicted_label, cv, i);
        %ac = 評価(認識精度値を出力)
        ac = sum(eval_label==predicted_label)/(n*2/cv);
        
        fprintf("%d回目accuracy: %f\n", i, ac);
        accuracy = [accuracy ac];
    end
    fprintf('mean accuracy: %f\n', mean(accuracy));
end

function [tlist, flist] = printResult(eval_label, predicted_label, cv, n)
    tlist = {};
    flist = {};
    acc = eval_label==predicted_label;
    for i=1:size(acc, 1)
        if acc(i)==1
            if size(tlist, 2) < 10
                tlist = {tlist{:} cv*(i)-mod(5-n, cv)};
            end
        else
            if size(flist, 2) < 10
                flist = {flist{:} cv*(i)-mod(5-n, cv)};
            end
        end
    end
    fprintf("正解画像\n");
    for i=1:size(tlist, 2)
        fprintf("%d ",tlist{i});
    end
    fprintf("\n");
    fprintf("間違い画像\n");
    for i=1:size(flist, 2)
        fprintf("%d ",flist{i});
    end
    fprintf("\n");
end