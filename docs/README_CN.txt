CAP-CSDP + Channel-wise WSCN 论文/PPT 完整包
================================================

一、包内已经包含什么
------------------
data/ 下已经放入六个三轴侧漏磁原始 CSV：

D0 / D10 / D30 / D50 / D70 / D100

因此正常情况下只需运行：

RUN_ME

自动完成：

CSV
 -> Channel-wise fixed-reference CAP-CSDP
 -> zero-background 256x256x3 tensor
 -> Br/Bt/Bz channel-wise WSCN
 -> Input/S0/U1/S1/U2/S2
 -> strict numerical audit
 -> total energy / mean energy per path / relative-to-D0 / order ratio
 -> paper + PPT figures

二、CAP-CSDP 参数
----------------
当前最终参数：

lag = 10
delta = 50 deg
psi = 60 deg

通道：
R = Br
G = Bt
B = Bz

固定参考值：

Ar = 1.05 * max(|Br|) across supplied states
At = 1.05 * max(|Bt|) across supplied states
Az = 1.05 * max(|Bz|) across supplied states

没有逐 D 状态 max normalization，因此不会把 D0-D100 的幅值演化全部洗掉。

三、WSCN 参数
------------
ImageSize = 256x256
InvarianceScale = 128
NumRotations = [6 6]

三个物理通道分别进入 WSCN。

过程展示：

Input -> S0 -> U1 -> S1 -> U2 -> S2

U1/U2/S1/S2 中如果有很多 scattering paths，程序不会挑选一条路径，
而是对该阶段全部 paths 做 RMS pooling：

A_m(x,y) =
sqrt( (1/N_m) * sum_p |C_m,p(x,y)|^2 )

四、这版最关键的可视化修正
------------------------
论文主 RGB 图使用：

“每一个 WSCN stage 只有一个公共显示尺度”

也就是对于 stage s：

M_s = robust scale over
      all D states + Br/Bt/Bz + all pixels

然后：

R = F_r / M_s
G = F_t / M_s
B = F_z / M_s

这与之前“每个 channel 自己拉伸”的 RGB 图不同。

因此：
WSCN_Process_RGB_AllStates_COMMON_SCALE

才是用于正文比较的严格版本。

注意：
因为 CAP-CSDP 前端使用 channel-wise fixed references，
RGB 亮度应该解释为“CAP-CSDP/WSCN representation space 中的 branch response”，
不要直接说它等于原始 Tesla 三轴绝对比例。

五、为什么还输出 channel diagnostic 图
------------------------------------
diagnostic_channel_scale/ 中的 Br/Bt/Bz 图使用每个 channel 自己的尺度。

目的：
看清弱通道的 morphology。

不能用于：
比较 Br/Bt/Bz 谁绝对更强。

所以文件名明确包含：
CHANNEL_SCALE_DIAGNOSTIC

六、严格能量定义
---------------
每条 scattering path：

e_m,p = mean(|S_m,p|^2)

总阶次能量：

E_m,total = sum_p e_m,p

平均每条 path：

E_m,mean = E_m,total / N_m

相对 D0：

G_m(D) = E_m(D)/E_m(D0)

阶次能量比例：

rho_m(D) = E_m(D)/(E_0+E_1+E_2)

能量全部直接从原始 scattering coefficient 计算，
不是从 resize/RMS 后的绘图矩阵反推。

七、Mean Energy per Path 为什么用 log y-axis
------------------------------------------
不同 order 的 path 数差异很大。
Order 1/2 的平均每 path 能量可能低几个数量级。

线性 y 轴会使其全部贴近 0。

因此 WSCN_MeanEnergyPerPath 使用 semilogy。
数据没有改变，只改变显示方式。

八、论文输出
-----------
results/publication/paper/

推荐正文：

1.
WSCN_Process_RGB_AllStates_COMMON_SCALE

2.
WSCN_TotalOrderEnergy

3.
WSCN_RelativeToD0

补充/深入解释：

4.
WSCN_MeanEnergyPerPath

5.
WSCN_TotalOrderEnergyRatio

Paper：
Times New Roman
约 180 mm 双栏全文宽
PNG/TIFF 600 dpi
PDF/SVG/FIG

PPT：
Arial
大字号
PNG/TIFF 300 dpi
PDF/SVG/FIG

九、审计文件
-----------
results/audit/

WSCN_InputBackground_Audit.csv
WSCN_ProcessMap_Numerical_Audit.csv
WSCN_OrderEnergy_Strict_Long.csv
WSCN_OrderEnergy_Strict_Wide.csv
WSCN_Stage_Display_Scales.csv
WSCN_Network_Info.txt
WSCN_ProcessMaps_AllStates.mat

以后如果需要检查结果，不要只看 PNG，可直接检查这些底层数值。

十、两种运行方式
--------------
A. 正常直接运行：
RUN_ME

B. 已有审核通过的 CAP-CSDP tensor，希望完全不重建：
把六个 MAT 放入 input_energy_tensors/
运行：
RUN_WSCN_ONLY
