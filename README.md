# Bilateral Co-Transfer (BCT)

<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-yellow.svg"></a>

**Keywords:** Unsupervised domain adaptation, Negative transfer, Under-adaptation, Image classification

This repository contains the source code accompanying the paper:

[Fuxiang Huang\*, Jingru Fu\*, Lei Zhang, "Bilateral Co-Transfer for Unsupervised Domain Adaptation," Journal of Automation and Intelligence, 2023.](https://www.sciencedirect.com/science/article/pii/S2949855423000485)

\*Co-first authors

## BCT Demo on YaleB Dataset

- **BCT.m**: Core code of the BCT algorithm.
- **run_yaleb.m**: Demo on YaleB dataset.

## Other Methods Compared in the Paper on YaleB Dataset

- **run_YaleB_othermethods.m**: Demo of other compared methods on YaleB dataset.
- **hl_ldada.m**: [An Embarassingly Simple Approach to Visual Domain Adaptation](https://ieeexplore.ieee.org/abstract/document/8325317)
- **JDA.m**: [Transfer Feature Learning with Joint Distribution Adaptation](https://openaccess.thecvf.com/content_iccv_2013/html/Long_Transfer_Feature_Learning_2013_ICCV_paper.html)
- **JGSA.m**: [Joint Geometrical and Statistical Alignment for Visual Domain Adaptation](https://openaccess.thecvf.com/content_cvpr_2017/html/Zhang_Joint_Geometrical_and_CVPR_2017_paper.html)
- **Subspace_Alignment.m**: [Unsupervised Visual Domain Adaptation Using Subspace Alignment](https://openaccess.thecvf.com/content_iccv_2013/html/Fernando_Unsupervised_Visual_Domain_2013_ICCV_paper.html)
- **RDALR.m**: [Robust Visual Domain Adaptation with Low-Rank Reconstruction](https://ieeexplore.ieee.org/abstract/document/6247924)
- **TSL_LRSR.m**: [Discriminative Transfer Subspace Learning via Low-Rank and Sparse Representation](https://ieeexplore.ieee.org/abstract/document/7360924)

Credits go to the original authors for the compared methods!

Once you run the code, please correctly set the path of the data and liblinear toolbox.

## Citation

If you find this code useful for your research, please consider citing:

```bibtex
@article{huang2023bilateral,
    title={Bilateral Co-Transfer for Unsupervised Domain Adaptation},
    author={Huang, Fuxiang and Fu, Jingru and Zhang, Lei},
    journal={Journal of Automation and Intelligence},
    volume={2},
    number={4},
    pages={204--217},
    year={2023},
    publisher={Elsevier}
}
