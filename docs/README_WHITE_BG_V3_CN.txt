CAP-CSDP 白底论文图 — v3 说明
==============================

一、为什么要改成白底
-------------------
CAP-CSDP 的底层数值图是非负能量张量：
    background = 0

如果直接用 RGB image() 显示：
    [0,0,0] -> 黑色

这对于屏幕诊断可以，但放论文存在三个问题：
1. 双栏缩小以后细线不清楚；
2. 打印/转 PDF 时黑底视觉负担大；
3. 图中的 Br/Bt/Bz 轨迹不容易和白色论文页面融合。

因此 v3 将“显示层”改为：
    zero response -> white

但数值层仍保持：
    zero response = 0

所以：
CAP-CSDP tensor、WSCN 输入、scattering coefficient、energy metrics
都没有因为白底而改变。

二、白底 RGB 映射
----------------
先使用一个严格公共尺度 M：

    R = clip(E_r/M,0,1)
    G = clip(E_t/M,0,1)
    B = clip(E_z/M,0,1)

令：
    I = max(R,G,B)

RGB hue：
    H = [R,G,B] / I

白底混合：
    alpha = I^gamma
    C = (1-alpha)*white + alpha*H

gamma 默认：
    0.58

gamma 只用于显示，让低能量轨迹在白纸上更清楚。

三、论文主 CAP-CSDP 图
---------------------
文件：
    CAP_CSDP_RGB_AllStates_WHITE_BG

布局：
    (a) D0
    (b) D10
    (c) D30
    (d) D50
    (e) D70
    (f) D100

颜色：
    R = Br
    G = Bt
    B = Bz

尺度：
    所有 D 状态 + 三通道共用一个 M。

因此这张图最适合放论文正文，用来展示：
    退磁严重度增加时 CAP-CSDP morphology 和 channel contribution 的演化。

四、三通道分解图
---------------
文件：
    CAP_CSDP_Channels_AllStates_WHITE_BG

行：
    Br
    Bt
    Bz

列：
    D0 ... D100

为了使弱通道 Bz 也能被看清楚：
每个 channel 有自己的 row scale，
但该 row scale 在 D0~D100 之间固定。

所以这张图适合：
    看每个物理通道内部的退磁演化。

不要用它直接比较：
    Br vs Bt vs Bz 的绝对亮度。

跨通道严格比较请看：
    CAP_CSDP_RGB_AllStates_WHITE_BG

五、WSCN
-------
原黑底版仍保留：
    WSCN_Process_RGB_AllStates_COMMON_SCALE

新增白底打印版：
    WSCN_Process_RGB_AllStates_WHITE_BG

两者只是显示方式不同。
底层 maps 和 energy 完全相同。

六、推荐论文排图
---------------
建议正文顺序：

Figure X:
    CAP_CSDP_RGB_AllStates_WHITE_BG
说明前端视觉编码结果。

Figure Y:
    WSCN_Process_RGB_AllStates_WHITE_BG
说明散射网络的逐阶响应。

Figure Z:
    WSCN_TotalOrderEnergy
定量说明各通道/各阶能量变化。

后续：
    WSCN_RelativeToD0
    WSCN_MeanEnergyPerPath
    WSCN_TotalOrderEnergyRatio

CAP_CSDP_Channels_AllStates_WHITE_BG
可放正文详细分析或补充材料。

七、论文图格式
-------------
paper/：
    Times New Roman
    约 180 mm 宽
    PNG 600 dpi
    TIFF 600 dpi
    PDF
    SVG
    FIG

ppt/：
    Arial
    大字号
    PNG/TIFF 300 dpi
    PDF/SVG/FIG
