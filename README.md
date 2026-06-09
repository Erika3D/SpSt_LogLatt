# Spontaneous Stochasticity in Fluctuating Hydrodynamics on Logarithmic Lattices

This repository contains the MATLAB codes and datasets used in the paper

 > "Spontaneous stochasticity in the fluctuating Navier--Stokes equations on a logarithmic lattice"

by E. P. Ortiz, C. S. Campolina, and A. A. Mailybaev.

The repository includes:

- MATLAB codes used to generate the simulation data;
- Datasets produced by the simulations;
- Scripts used to generate all figures presented in the paper.


## Contents

- `Data/`: simulation datasets used to generate the figures.

- `PDF_irregular_IC.m`: generates Figure 2, which shows the probability density functions (PDFs) corresponding to the irregular initial condition case.

- `PDF_regular_IC.m`: generates Figure 4, which shows the probability density functions (PDFs) corresponding to the regular initial condition case.

- `VorticityNorm_regular_IC.m`: generates Figure 3, which shows the time evolution of the supremum norm of the vorticity for the Euler and Navier--Stokes equations for the regular initial condition.

- `tightfig.m`: auxiliary MATLAB function used by the previous scripts to improve the appearance and spacing of the figures.

- `Source/`: MATLAB source code used to generate the simulation datasets.
