%対象画像のパスのリストを作成
function list = makeImageList(target)
    n = 0;
    list = {};
    target_dir = strcat(target, "/");
    W = dir(target_dir);
    for i=1:size(W)
        if (strfind(W(i).name, ".jpg"))
            fn=strcat(target_dir, W(i).name);
            n=n+1;
            %fprintf("[%d] %s\n", n, fn);
            list = {list{:} fn};
        end
    end
    fprintf('%s 読み込み終了\n',target);
end