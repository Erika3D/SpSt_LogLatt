
# Source Code

This directory contains the MATLAB source code used to generate the simulation datasets analyzed in the paper.

## Requirements

The code requires:

- MATLAB;
- the LogLatt library [1].

The simulations are built upon the MATLAB library **LogLatt** [1], developed by C. S. Campolina. This library provides the core numerical tools for computations on logarithmic lattices, including lattice construction, differential operators, nonlinear products, and norm evaluations.

### References

[1] Campolina C. 2020  LogLatt: A Computational Library for the Calculus on Logarithmic Lattices. Freely available for non-commercial use through MATLAB Central File Exchange: https://www.mathworks.com/matlabcentral/fileexchange/76295-loglatt. 

Comprehensive documentation is available at: https://arxiv.org/abs/2006.00047.



## Main simulation scripts

 - `LLNS_Irregular_IC.m`: Solves the three-dimensional Landau-Lifshitz-Navier-Stokes equations with irregular initial data.

 - `LLNS_Regular_IC.m`: Solves the three-dimensional Landau-Lifshitz-Navier-Stokes equations with regular initial data.

 - `Euler_Regular_IC.m`: Solves the three-dimensional Euler equations with regular initial data.

 - `NS_Regular_IC.m`: Solves the three-dimensional Navier-Stokes equations with regular initial data.
   
## Initial conditions

- `IC_Irregular.m`: Generates the irregular initial condition used in the simulations.

- `IC_Regular.m`: Generates the regular initial condition used in the simulations.

## Time integration

- `RKF45_nStep.m`: One-step Runge-Kutta 4(5) integrator used for the nonlinear Euler dynamics.

## Dynamical operators

- `RHS_Euler3D.m`: Computes the right-hand side of the Euler equations in vorticity form.
 
## Data processing

- `Collect_PDF_data_IIC`: Collects individual simulation outputs for the irregular initial data, and assembles the datasets used to compute probability density functions.

- `Collect_PDF_data_RIC`: Collects individual simulation outputs for the regular initial data, and assembles the datasets used to compute probability density functions.

