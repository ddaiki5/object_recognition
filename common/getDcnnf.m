%DCNN特徴量を取得
function data = getDcnnf(list, net)
    data = [];
    for i=1:size(list, 2)
        %画像読み込み
        img = imread(list{i});
        %リサイズ
        img = imresize(img,net.Layers(1).InputSize(1:2));
        %特徴量抽出
        dcnnf = activations(net, img, 'fc7');
        %ベクトル化
        dcnnf = squeeze(dcnnf);
        %正規化
        dcnnf = dcnnf/norm(dcnnf);

        data = [data dcnnf];
    end
    
    %転置
    data = data.';%(n1+n2)×4096
    fprintf('dcnn特徴量抽出完了\n');
end