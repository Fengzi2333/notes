---
export_on_save:
 html: true
---

<!-- TOC -->

[TOC]

# Games101Notes
## Linear Algebra
- cross product
    $$
        \begin{aligned}
            \vec{a}\times\vec{b}
        &=   \begin{pmatrix}
                y_az_b-y_bz_a \\
                z_ax_b-x_az_b \\
                x_ay_b-y_ax_b \\
            \end{pmatrix}
        &=  \bold{A}^*b
        &=  \begin{pmatrix}
            0 & -z_a & y_a \\
            z_a & 0 & -x_a \\
            -y_a & x_a & 0 \\
        \end{pmatrix}
        \begin{pmatrix}
            x_b \\
            y_b \\
            z_b \\
        \end{pmatrix}
        \end{aligned}
    $$

    - 作用：判断点是否在三角形内，$\vec{AB}/\vec{BC}/\vec{CA}$分别与$\vec{AP}/\vec{BP}/\vec{CP}$叉乘，判断结果符号是否相同

## Transformation
### 2D Transformations
- scale
  $$A_{scale}=\begin{pmatrix}
      s_{00} & 0 \\
      0 & s_{11} \\
  \end{pmatrix}A$$
- shear
  $$A_{shear}=\begin{pmatrix}
      1 & s \\
      0 & 1 \\
  \end{pmatrix}A$$
- Rotation
    $$A_{rotate}=\begin{pmatrix}
        \cos{\theta} & -\sin{\theta} \\
        \sin{\theta} & \cos{\theta} \\
    \end{pmatrix}A\\
    R_{\theta} = \begin{pmatrix}
        \cos{\theta} & -\sin{\theta} \\
        \sin{\theta} & \cos{\theta} \\
    \end{pmatrix}\\
    R_{-\theta} = \begin{pmatrix}
        \cos{\theta} & \sin{\theta} \\
        -\sin{\theta} & \cos{\theta} \\
    \end{pmatrix}=R_\theta^{-1}=R_\theta^T
    $$
    满足$R_\theta^{-1}=R_\theta^T$的称为正交矩阵
- translation
  - 引入齐次坐标系：
    点：$\begin{pmatrix}
        a_0 \\
        a_1\\
        ... \\
        a_{n-1}\\
        1 \\
    \end{pmatrix}$
    向量：$\begin{pmatrix}
        a_0 \\
        a_1 \\
        ... \\
        a_{n-1}\\
        0 \\
    \end{pmatrix}$
    $$A_{translation}=\begin{pmatrix}
        1 & 0 & t_x \\
        0 & 1 & t_y \\
        0 & 0 & 1 \\
    \end{pmatrix}A$$
- Linear Transformation = scale+shear+rotate
- Affine Transformation = Linear+translation
- 组合变换时，先应用线性变换，再应用位移变换

### 3D Transformations
- Rotation

  - Around Axis
  
    - x axis
        $$
        R_x(\alpha)=\begin{pmatrix}
            1 & 0 & 0 & 0 \\
            0 & \cos\alpha & -\sin\alpha & 0 \\
            0 & \sin\alpha & \cos\alpha & 0 \\
            0 & 0 & 0 & 1 \\
        \end{pmatrix}
        $$
    - y axis
        $$
        R_y(\alpha)=\begin{pmatrix}
            \cos\alpha & 0 & \sin\alpha & 0 \\
            0 & 1 & 0 & 0 \\
            -\sin\alpha & 0 & \cos\alpha & 0 \\
            0 & 0 & 0 & 1 \\
        \end{pmatrix}
        $$
    - z axis
        $$
        R_z(\alpha)=\begin{pmatrix}
            \cos\alpha & -\sin\alpha & 0 & 0 \\
            \sin\alpha & \cos\alpha & 0 & 0 \\
            0 & 0 & 1 & 0 \\
            0 & 0 & 0 & 1 \\
        \end{pmatrix}
        $$
    - xyz axis
        $$R_{xyz}(\alpha,\beta,\gamma)=R_x(\alpha)R_y(\beta)R_z(\gamma)\cdots Euler Angle
        $$
    - Rotation by angle α around axis n
        $$
            R(\vec{n},\alpha)=\cos\alpha\vec{I}+(1-\cos\alpha)\vec{n}\vec{n}^T+\sin\alpha\begin{pmatrix}
                0 & -n_z & n_y \\
                n_z & 0 & -n_x \\
                -n_y & n_x & 0 \\
            \end{pmatrix}\\
            \cdots Rodrigues’\ Rotation\ Formula
        $$
        
        - 推导（“$\hat{\ \ }$”表示单位向量）
        ![images](ref/images/vec%20rot.svg)
        $$
            \begin{aligned}
                \vec{S}^{rot}&=\vec{S}_\parallel+\vec{S}_\perp^{rot}\\
                \vec{S}_\parallel&=proj(\vec{S},\hat{n})\\
                &=\hat{n}(\hat{n}\cdot\vec{S})\\
                &=\bold{n}\bold{n}^T\vec{S}\\
                \vec{S}_\perp
                &=\vec{S}-\vec{S}_\parallel\\
                \hat{a}
                &=\frac{\vec{S}_\perp}{\|\vec{S}_\perp\|} \\
                \hat{b}&=\hat{n}\times\hat{a}\\
                &=\hat{n}\times\frac{\vec{S}_\perp}{\|\vec{S}_\perp\|}\\
                &=\frac{\hat{n}\times\vec{S}}{\|\vec{S}_\perp\|} \\
                \vec{S}_\perp^{rot}&=\|\vec{S}_\perp^{rot}\|\cos\theta\hat{a}+\|\vec{S}_\perp^{rot}\|\sin\theta\hat{b}\\
                &=\|\vec{S}_\perp\|\cos\theta\hat{a}+\|\vec{S}_\perp\|\sin\theta\hat{b}\\
                &=\|\vec{S}_\perp\|\cos\theta\frac{\vec{S}_\perp}{\|\vec{S}_\perp\|}+\|\vec{S}_\perp\|\sin\theta\frac{\hat{n}\times\vec{S}}{\|\vec{S}_\perp\|}\\
                &=\vec{S}_\perp\cos\theta+\hat{n}\times\vec{S}\sin\theta\\
                &=(\vec{S}-\vec{S}_\parallel)\cos\theta+\hat{n}\times\vec{S}\sin\theta\\
                &=(\vec{S}-\bold{n}\bold{n}^T\vec{S})\cos\theta+\hat{n}\times\vec{S}\sin\theta\\
                &=(1-\bold{n}\bold{n}^T)\cos\theta\vec{S}+\bold{N}_{dual}\sin\theta\vec{S}\\
                \vec{S}^{rot}&=\vec{S}_\perp+\vec{S}_\parallel\\
                &=(1-\bold{n}\bold{n}^T)\cos\theta\vec{S}+\bold{N}_{dual}\sin\theta\vec{S}+\bold{n}\bold{n}^T\vec{S} \\
                &=[\cos\alpha\vec{I}+(1-\cos\alpha)\bold{n}\bold{n}^T+\bold{N}_{dual}\sin\theta]\vec{S}
            \end{aligned}
        $$
### View/Camera Transformation
