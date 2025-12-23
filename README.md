# Optimal Light Use Greenness

Seasonal vegetation dynamics and long-term greenness trends reconstructed with an optimal light use framework that links canopy structure, meteorology, and carbon uptake.

## Contents
- [Overview](#overview)
- [Repository Layout](#repository-layout)
- [Data Inventory](#data-inventory)
- [System Requirements](#system-requirements)
- [Setup Guide](#setup-guide)
- [Running the Workflow](#running-the-workflow)
- [Results](#results)
- [Support](#support)
- [Citation](#citation)

## Overview
The PL model reproduces seasonal foliage display and multidecadal greenness trends by coupling potential production (A0) with canopy allocation decisions. Satellite benchmarks (MODIS fAPAR), flux tower observations, and TRENDY ensemble simulations provide independent constraints. This repository accompanies the manuscript *Optimal light use strategy explains seasonal vegetation greenness dynamics and trends* and enables collaborators to regenerate the main figures.

## Repository Layout
- `code/`: MATLAB scripts for generating manuscript figures, including `main_figures_ncomms.m`.
- `code/utility/`: Plotting and statistical helpers (e.g., `geoshow_global.m`, `plot_lat_bands.mlx`).
- `data/`: Packaged inputs (rasters, tables, and TRENDY diagnostics) required by the scripts.
- `figure/`: Default export directory created by the workflow.

## Data Inventory
| File | Description | Used in |
| --- | --- | --- |
| `FluxInformation.csv` | Flux tower metadata and biome classes for Figure 2 site diagnostics. | `main_figures_ncomms.m` |
| `gpp_global_pgc.mat` | Annual global GPP totals for PL simulations. | `main_figures_ncomms.m` |
| `trendy_data_output.mat` | TRENDY ensemble seasonal diagnostics. | `main_figures_ncomms.m` |
| `trendy_param_output.mat` | TRENDY model performance summary metrics. | `main_figures_ncomms.m` |

All of the packaged assets currently present in `data/` are referenced by `code/main_figures_ncomms.m`. Additional GeoTIFF stacks (`fapar_*.tif`, `roi_global_05d.tif`, etc.) are bundled with the project and must remain alongside these files for the workflow to complete.

## System Requirements
- **Software:** MATLAB R2021b (or newer) with Mapping Toolbox.
- **Operating System:** Windows or macOS tested; Linux should also work when the Mapping Toolbox is available.
- **Hardware:** ≥16 GB RAM recommended for manipulating global GeoTIFF stacks.

## Setup Guide
1. Clone or download the repository and keep the directory structure intact.
2. Ensure the `data/` folder contains the GeoTIFF and MAT assets distributed with the project.
3. Launch MATLAB and set the current folder to the repository’s `code/` directory.
4. Verify that the `utility/` subfolder is on the MATLAB path (the main script automatically adds it).

## Running the Workflow
1. Open `main_figures_ncomms.m` in MATLAB.
2. Confirm that `../data/` resolves to the packaged inputs and that `../figure/` is writable.
3. Run the entire script (Section Run or `Run` button). Execution will sequentially:
	- Load gridded greenness and potential production stacks.
	- Generate the seasonality, flux-site synchrony, spatial comparison, and trend panels.
	- Export publication-ready figures to `figure/` at 600 dpi.
4. Review the exported PNG files and, if needed, adjust figure aesthetics directly in the script.

## Results
The script writes the following assets to `figure/`:
- `Seasonality_Pattern_A0.png`: Global MODIS vs. PL seasonality maps with latitude-band summary.
- `spatial_compare.png`: Multi-year PL and MODIS climatology maps plus latitudinal comparison.
- `Seasonality_Pattern.png`: Vertical stack comparing MODIS, TRENDY, and PL seasonal concentration.
- `fAPARtrend_pvalue.png`: Observed and simulated greenness trends with significance masking.
- `GPPtrend_series.png`: Global GPP trajectories for TRENDY, PL, and the A0-only experiment.

## Support
Please open a discussion or issue in your collaboration space if you encounter missing data, plotting errors, or require additional diagnostics. Include MATLAB version details and any console warnings to accelerate troubleshooting.

## Citation
Cite *Optimal light use strategy explains seasonal vegetation greenness dynamics and trends* (Zhu et al., 2025)