%urlから画像のダウンロードを行う
function imgDownloader(target)
    targetPath = strcat("url/", target, "_url.txt");
    list=textread(targetPath,'%s');
    OUTDIR=target;
    mkdir(OUTDIR);
    for i=1:size(list,1)
      fname=strcat(OUTDIR,'/',num2str(i,'%04d'),'.jpg')
      websave(fname,list{i});
    end
end
