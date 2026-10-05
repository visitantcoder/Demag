CAP-CSDP WSCN Compatible v2
==============================

本版本修复两个兼容问题：

1) 旧版 MATLAB 没有 tiledlayout
   -> 自动使用 subplot。

2) CSV 表头识别错误
   原因：旧代码在 lower() 之前先删除非小写字符，
   导致 "Btan_side []" 的大写 B 被删除，
   变成 "tanside"，因此无法识别 Bt/Br/Bz。

   v2 已改为：
       lower() -> regexprep()
   并使用 strfind() 代替 contains()，进一步兼容旧 MATLAB。

另外加入了针对本包固定 CSV 结构的安全 fallback：
   第1列 = Time
   第2列 = Bt
   第3列 = Br
   第4列 = Bz

直接运行：
   RUN_ME

不要把 v2 文件覆盖到旧文件夹里混用。
建议把旧 CAP_CSDP_WSCN_Publication_Compatible 文件夹删除，
然后完整解压本 v2 包。
