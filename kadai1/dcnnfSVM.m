%DCNN特徴量とSVMで学習を行う
function [predicted_label, scores] = dcnnfSVM(pos_target, neg_target)
    net = alexnet;
    pos_list = makeImageList(pos_target);
    neg_list = makeImageList(neg_target);
    list = {pos_list{1:100} neg_list{1:100}};
    data = getDcnnf(list, net);
    [predicted_label, scores] = crossValidationSVM(data, 100, 100, 1);
end