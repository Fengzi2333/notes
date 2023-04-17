---
export_on_save:
  html: true
---

# Shader Language

<!-- TOC -->

[TOC]

Shader Language，着色语言，是依赖于图形硬件的准高级语言，为了加强对图形处理算法的控制而被提出，目前已被用于通用计算研究。
目前主要有三种着色语言：基于 OpenGL 的 OpenGL Shading Language（GLSL），基于 Direct3D 的 High-level shader language（HLSL），以及 Nvidia 公司的 C for Graphic（Cg）。

## 编译

- 动态编译
- 编译器先将 Cg 程序翻译为可被图形 api（OpenGL/Direct3D）可接受的形式，然后应用程序使用适当的 api 命令将翻译后的程序传递给图形处理器，最后图形 api 驱动将其翻译为图形处理器所需要的硬件可执行格式。
- 同时依赖于宿主程序所使用的三维编程接口和图形硬件环境

#### CGC 编译命令

- 格式
  cgc -profile profile 配置项 -entry 着色程序入口函数 被编译的文件

- 着色程序入口函数需要区分顶点着色程序和片段着色程序，编译时需要分别选择各自的 profile
- profile 需要硬件支持，循环语句仅被少量 profile 支持，循环语句需要有确切的循环次数才能使用
- 输入文件必须以$.cg$为后缀
- cgc 可以将 cg 文件编译为 glsl 或 hlsl，如
  cgc -profile glslv -o test.glsl -entry main_v test.cg
  将 test.cg 编译为 test.glsl

## CG 数据类型

#### 基本

- float，32 位，1 个符号位，所有 profile 支持
- half，16 位
- int，32 位，有些 profile 会把 int 作为 float 使用
- fixed，12 位定点数，所有 fragment profile 支持
- bool，所有 profile 支持
- sampler，纹理对象的句柄，分为六类，sampler，sampler1D，sampler2D，sampler3D，samplerCUBE，samplerRECT。directX profile 不支持 samplerRECT。
- string，不被支持
- 内置向量数据类型：数据类型名+数字，如 float2 表示 2 元浮点向量，向量不能超过 4 元，较长的向量可以通过较短的向量构建，如：
  $$
      \begin{aligned}
          &float2\ a = float(1.0,1.0)\\
          &float4\ b = float(a,2.0,3.0)
      \end{aligned}
  $$
- 矩阵数据类型
  如 float2x2 matrix;
  最大 4\*4 阶

#### 数组

- 作用：作为函数的形参，用于大量数据传递
- 必须指定长度

#### 结构类型

- 如果成员函数使用了成员变量，则成员变量需要声明在前
- cg 源代码一般会在文件开头定义两个结构体，用于定义输入和输出类型，这两个结构体除了定义成员的数据类型外，还定义了成员的绑定语义类型，绑定语义类型用于与宿主环境进行数据交互时识别不同数据类型。
- 语义词，表示输入图元的数据含义（是位置信息，还是法向量信息），也表 明这些图元数据存放的硬件资源（寄存器或者纹理缓冲区）。顶点着色程序和片段着色程序中 Varying inputs 类型的输入，必须和一个语义词相绑定，这称之为 绑定语义（binding semantics）。

#### 类型转换

- 常量类型后缀：
  $$
      \begin{aligned}
          float\rArr &f\\
          half\rArr &h\\
          fixed\rArr&x\\
      \end{aligned}
  $$

## 表达式和控制语句

#### 布尔运算

- 向量的布尔运算
  - 两个向量长度必须一致
  - 每个分量一对一运算
  - 结果为 bool 向量
- 没有短路

#### 数学运算

- cg 对向量的数学操作提供内置支持
- %仅用于 int
- 向量与标量间运算时会先把标量复制到与之等长的向量中

#### 移位操作

- 必须是 int，可用于向量

#### Swizzle 操作

- 作用：将向量的成员取出组成新的向量
- xyzw（rgba）分别表示原始向量的第一二三四个元素
- 例：
  $float4(a,b,c,d).wzyx\rArr float4(d,c,b,a)$
- float a 与 float1 a 等价，因此可以有
  $$
      \begin{aligned}
          &float\ a = 1.0;\\
      &float4\ b = a.xxxx
      \end{aligned}
  $$
- 仅可用于向量和结构体，不可用于数组

#### 条件操作符

- 支持向量运算，向量的每个元素分别运算

#### 控制流语句

- 避免在低级 profile 中使用循环
- 不支持递归调用

## 输入输出与语义绑定

#### Cg 关键字

- 除继承自 c/c++的 int 等关键字外，Cg 中有用于指定输入图元的数据含义（如区分位置信息和法向信息），且对应图元数据存放的硬件资源（寄存器或者纹理缓冲区）的关键字，称为语义词（Semantics），通常也根据其用法称之为绑定语义词。

##### uniform

- Cg 输入流分为两类，Varying Inputs 和 Uniform Inputs。
- Varying inputs are used for data that is specified with each element of the stream of input data. For example, the varying inputs to a vertex program are the **per‐vertex values** that are specified in vertex arrays. For a fragment program, the varying inputs are the interpolants, such as **texture coordinates**.
- Uniform inputs are used for values that are specified separately from the main stream of input data, and don’t change with each stream element. For example, a vertex program typically requires a **transformation matrix** as a uniform input. Often, uniform inputs are thought of as graphics state.
- uniform 修饰一个参数，表示该参数由外部应用程序（OpenGL 或 DirectX 程序）初始化并传入，通常用于函数形参，不允许用于声明局部变量。

##### const

- 被修饰的变量无法修改

##### in/out/inout

- in：被修饰的形参仅用于输入，进入函数体时被初始化，不影响实参值，值传递，可缺省
- out：被修饰的形参仅用于输出，进入函数体时不被初始化，可以用 return 代替
- inout：被修饰的形参既用于输入也用于输出，等于引用传递

#### 语义词与语义绑定

- 语义词表示输入图元的数据含义和存放该图元的硬件资源。着色程序中 varying inputs 类型的输入必须和一个语义词绑定，这称为绑定语义。
- DX10 以后有了新的语义类型，系统数值语义(system-value semantics),以 SV 开头，如 SV_POSITION，这类语义描述的变量用于特定目的，不可随意赋值。
- 一个语义可以使用的寄存器只能处理 4 个浮点值，因此，若要传递 float4x4 等类型需要拆分成多个 float4。

##### 顶点着色程序

- 输入语义

  - POSITION: 顶点位置坐标（通常位于模型空间）
  - NORMAL: 顶点法向量坐标（通常位于模型空间）
  - BINORMAL
  - BLENDINDICES
  - BLENDWEIGHT
  - TANGENT
  - PSIZE
  - TEXCOORD0 - TEXCOORD7

- 输出语义

  - POSITION
  - PSIZE
  - FOG
  - COLOR0 - COLOR1
  - TEXCOORD0 - TEXCOORD7

- 输入输出语义中的 POSITION 对应不同的寄存器
- 顶点着色程序必须声明一个输出变量，并绑定 POSITION 语义词，该变量中 的数据将被用于，且只被用于光栅化
- 为了保持顶点程序输出语义和片段程序输入语义的一致性，通常使用相同的
  struct 类型数据作为两者之间的传递，例：
  ```
  struct VertexIn {
    float4 position:POSITION;
    float4 normal:NORMAL;
    };
  struct VertexScreen {
    float4 oPosition:POSITION;
    float4 objectPos:TEXCOORD0;
    float4 objectNormal:TEXCOORD1;
  };
  ```
- 顶点着色程序的输出语义词，通常也是片段程序的输入语义词，语义词 POSITION 除外

##### 片段着色程序的输出语义

- 片段着色程序的输出语义通常是 COLOR，例：
  ```
  void main_f(out float4 color:COLOR){
    color.xyz = float3(1.0,1.0,1.0);
    color.w = 1.0;
  }
  ```
- 一些 fragment profile 支持输出语义词 DEPTH，与它绑定的输出变量会设置片断的深度值；还有一些支持额外的颜色输出，可以用于多渲染目标（multiple render targets , MRTs）
- 片断着色程序的输出对象少，最常用的就是颜色值（绑定输出语义词 COLOR），单独的一个向量没有必要放到结构体中

## 函数与程序设计

#### 函数

##### 数组形参

- Cg 语言中不存在指针机制（图形硬件不支持），数组作为函数形参，传递的是数组的完整拷贝
- 数组（包括多维数组）形参不必指定长度。如果指定了函数中形参数组的长度，那么在调用该函数时实参数组的长度和形参数组的长度必须保持一致，否则编译时会报错

##### 入口函数

- 以输入输出语义绑定区分顶点程序和片段程序的入口函数，内部函数忽略任何应用到形参上的语义

##### CG 标准函数库

- 数学函数
  |函数|功能|
  |:---|:---|
  |$frexp(x, out\ exp)$|将浮点数 $x$ 分解为尾数和指数，即 $m*2^{exp}$，返回$m$，并将指数存入 $exp$ 中； 如果 $x$ 为 0，则尾数和指数都返回 0|
  |$ldexp(x, n)$|计算$x*2^n$的值|
  |$lit(N\cdot L, N\cdot H, m)$|$N$表示法向量；$L$表示入射光向量；$H$表示半角向量；$m$表示高光系数。函数计算环境光、散射光、镜面光的贡献， 返回的 4 元向量$(x,y,z,w)$： $x$位表示环境光的贡献，总是 1.0； $y$位代表散射光的贡献，如果$N\cdot L\mathord{<}0$ ，则为 0；否则为$N\cdot L$，$z$位代表镜面光的贡献，如果$N\cdot L\mathord{<}0$ 或者$N\cdot H\mathord{<}0$，则为 0；否则为$(N\cdot H)^m$； W 位始终为 1.0|
  |$modf(x,out\ ip)$|将$x$分为整数和小数部分，每部分都和$x$符号相同，整数部分存储在$ip$中，返回小数部分|
  |$noise(x)$|返回值为 0 到 1|
  |$rsqrt(x)$|返回$x$的反平方根（$\frac{1}{\sqrt{x}}$），$x$必须大于 0|
  |$saturate(x)$|$clamp(x,0,1)$|
  |$sign(x)$|$ \begin{cases} -1&,x<0\\ 0&,x=0\\1&,x>0\end{cases}$|
	|$sincos(float\ x, out\ s, out\ c)$|同时计算$x$的$sin$和$cos$值，在同时需要$sin$和$cos$值的情况下，速度比分别运算快|
	|$smoothstep(min, max, x)$|返回$-2*(\frac{x-min}{(max-min)})^3 + 3*(\frac{x-min}{(max-min)})^2$|
	|$step(a,x)$|返回$x\ge a$|
- 几何函数
  |函数|功能|
  |:---|:---|
  |$faceforward(n, i, ng)$|公式：$-n\mathord{*} sign(dot(i, ng))$|
  |$reflect(I,N)$|根据入射光方向向量 I，和顶点法向量 N，计算反射光方向向量。其中 I 和 N 必须被归一化，需要非常注意的是，这个 I 是指向顶点的；函数只对三元向量有效|
  |$refract(I,N,eta)$|计算折射向量，I 为入射光线，N 为法向量，eta 为折射系数；其中 I 和 N 必须被归一化，如果 I 和 N 之间的夹角太大，则返回（0，0，0），也就是没有折射光线；I 是指向顶点的；函数只对三元向量有效|
  - 着色程序中的向量最好进行归一化之后再使用
  - reflect 函数和 refract 函数中使用的入射光方向向量，是从外指向几何顶点的；平时我们在着色程序中或者在课本上都是将入射光方向向量作为从顶点出发
- 纹理映射函数
  |函数|功能|
  |:---|:---|
  |$tex2D(sampler2D\ tex, float2\ s)$|二维纹理查询|
  |$Tex2D(sampler2D\ tex, float3\ sz)$|一维纹理查询，并进行深度值比较|
  |$tex2D(sampler2D\ tex, float2\ s, float2\ dsdx, float2\ dsdy)$|使用导数值查询二维纹理|
  |$Tex2D(sampler2D\ tex, float3\ sz, float2\ dsdx,float2\ dsdy)$|使用导数值查询二维纹理并进行深度值比较|
  |$Tex3Dproj(sampler3D\ tex, float4\ szq)$ |查询三维投影纹理，并进行深度值比较|
  - s 象征一元、二元、三元纹理坐标；z 代表使用“深度比较（depth comparison）”的值；q 表示一个透视值（perspective value,其实就是透视投影后所得到的齐次坐 标的最后一位），这个值被用来除以纹理坐标（s），得到新的纹理坐标（已归一化到 0 和 1 之间）然后用于纹理查询。
- 偏导函数
  |函数|功能|
  |:---|:---|
  |$ddx(a$|参数 a 对应一个像素位置，返回该像素值在 X 轴上的偏导数|
  |$ddy(a)$|参数 a 对应一个像素位置，返回该像素值在 Y 轴上的偏导数|
  如果参数对应的像素的为 p(i,j)，则
  $$
    ddx(a)=p(i+1,j)-p(i,j)\\
    ddy(a)=p(i,j+1)-p(i,j)\\
  $$

## 经典光照模型

### 漫反射与 Lambert 模型

- 粗糙的物体表面向各个方向等强度的反射光，成为光的漫反射（diffusion reflection），产生漫反射的物体表面成为理想漫反射体，或朗伯（Lambert）反射体。
  对于仅暴露于环境光下的朗伯反射体，某点处漫反射的光强可表示为：

  $$
    I_{AmbDiff}=k_dI_a
  $$

  其中$I_a$表示环境光强度，$k_d$为材质对环境光的反射系数，取值 0 到 1。

- Lambert 定律：当方向光照射到 Lambert 反射体上时，漫反射光的光强与入射光的方向和入射点表面法向夹角的余弦成正比。
  由此构建出 Lambert 漫反射模型
  $I_{Ldiff}=k_dI_l\cos\theta=k_dI_l(N\cdot L)$
  其中$I_l$是点光源强度，$\theta$是入射光方向和顶点法线的夹角,$N$是顶点单位法向量，$L$为顶点指向光源的单位向量。
- 综合考虑环境光和方向光，Lambert 光照模型可表示为：
  $I_{diff}=I_{Ldiff}+I_{AmbDiff}=k_dI_a+k_dI_l(N\cdot L)$
- 示例：[vertex](./Example/DiffuseVertexLevel.shader)/[pixel](./Example/DiffusePixelLevel.shader)
- 问题：光照无法到达的区域没有明暗变化，模型细节丢失。

### 半 Lambert 模型

- 由 valve 公司在开发《half life》时提出的无物理依据视觉增强技术
- 在 Lambert 模型中，$N\cdot L(-1,1)$小于 0 的部分被截断，导致细节丢失，半 Lambert 模型中被重新映射到$(0,1)$
- 示例：[HalfLambert](./Example/HalfLambert.shader)

### Phong 模型

- Phong 模型认为镜面反射的光强与反射光线和视线的夹角相关，表示为：
  $$I_{spec}=k_{s}I_{l}(v\cdot R)^{n_{s}}$$
  其中$k_{s}$为材质的镜面反射系数，$n_{s}$是高光指数，$V$表示顶点到视点的观察方向，$R$代表反射光方向。反射光方向可以通过入射光方向和物体法向求出：
  $$
      \begin{aligned}
          R+L&=(2N\cdot L)N\\
          R&=(2N\cdot L)N-L
      \end{aligned}
  $$
- 示例：[vertex](./Example/SpecularVertexLevel.shader)/[pixel](./Example/SpecularPixelLevel.shader)

### Blinn-Phong 模型

- 用$N\cdot H$代替了$v\cdot R$，公式为：
  $$
    I_{spec}=k_{s}I_{l}(N\cdot H)^{n_{s}}
  $$
  其中$N$是入射点的单位法向量，$H$是光入射方向$L$与视点方向$V$的中间向量，也称半角向量，
  $$
      H=\frac{L+V}{|L+V|}
  $$
