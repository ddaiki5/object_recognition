%カラーヒストグラムとSVMで学習を行う
function [predicted_label, scores] = colorSVM(pos_target, neg_target)
    pos_list = makeImageList(pos_target);
    neg_list = makeImageList(neg_target);
    imgs = makeColorHistgram(pos_list, neg_list);
    [predicted_label, scores] = crossValidationSVM(imgs, 100, 100, 1);
end

function imgs = makeColorHistgram(pos_list, neg_list)
    %color histgram
    imgs = zeros(200, 64);
    %path list
    list = {pos_list{1:100} neg_list{1:100}};
    for i=1:200
        X = imread(list{i});
        RED=X(:,:,1); GREEN=X(:,:,2); BLUE=X(:,:,3);
        %64色に減色
        X64=floor(double(RED)/64) *4*4 + floor(double(GREEN)/64) *4 + floor(double(BLUE)/64);
        X64_vec=reshape(X64,1,numel(X64));
        h=histc(X64_vec,[0:63]);
        h = h/sum(h);
        imgs(i, :) = h;
    end
    fprintf("color histgram作成完了\n");
end

