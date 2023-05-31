![images](./pic/torrance.svg)
$E_{p}$是观察向量$E$在$NH$平面上的投影，$N$为物体表面法向，$H$为微平面法向，v形槽两边对称，$m$区域内的射线被遮挡，所以衰减系数为
$$
        \begin{aligned}
            G&=1-\frac{m}{l}\\
            \frac{m}{l}&=\frac{\sin f}{\sin b}\\
            &=\frac{\sin(b+c)}{\sin b} \\
            c&=2d \\
            \sin c&=2 \sin d \cos d = 2 \sin a \cos a \\
            \cos c&= 1-2 \sin ^{2}d =1-2 \cos ^{2} a \\
            \sin (b+c)&=\sin b\cos c+\sin c\cos b \\
            &= \cos e (1-2 \cos ^{2} a)+ 2 \sin a \cos a \sin e  \\
            &= \cos e -2 \cos a( \cos e \cos a - \sin a \sin e) \\
            &= \cos e -2 \cos a \cos (a+e)\\
            &=H\cdot \frac{E_{p}}{|E_{p}|}-2 N\cdot H * N\cdot \frac{E_{p}}{|E_{p}|} \\
            \sin b&= \cos e = H\cdot \frac{E_{p}}{|E_{p}|} \\
            \frac{m}{l}&=\frac{\frac{1}{|E_{p}|}(H\cdot E_{p}-2N\cdot H*N\cdot E_{p})}{\frac{1}{|E_{p}|}H\cdot E_{p}} \\
            &=1-\frac{2N\cdot H*N\cdot E_{p}}{H\cdot E_{p}} \\
            &=1-\frac{2N\cdot H*N\cdot E}{H\cdot E}  \\
            G&=1-\frac{m}{l}=\frac{2N\cdot H*N\cdot E}{H\cdot E} \\
        \end{aligned}
$$
