# Optimal canopy light-use strategy shapes global greenness dynamics

[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.XXXXXXX-blue)](https://doi.org/10.5281/zenodo.XXXXXXX)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

![Figure 1](figure/Figure1_small.png)

> **Fig. 1 |** Seasonality of the fraction of absorbed photosynthetically active radiation (fAPAR, dimensionless) and potential primary production (A₀, g C m⁻² month⁻¹). **(a)** fAPAR seasonality (dimensionless) derived from the MODIS product. The seasonality metric used here represents seasonal concentration, ranging from zero (uniform throughout the year) to unity (a complete leaf growth cycle within a single month). **(b)** A₀ seasonality (dimensionless) derived from the P model. **(c)** Latitudinal variations in the seasonality of fAPAR and A₀, with values representing area-weighted averages in 1° latitudinal bands.

This repository accompanies the manuscript **"Optimal canopy light-use strategy shapes global greenness dynamics"** (Zhu et al., *Nature Communications*, 2026; manuscript **NCOMMS-25-24941B**) and provides the code, data, and figures needed to reproduce the main and supplementary results.

---

## Authors

Ziqi Zhu (朱子琪)¹·², Han Wang (王焓)¹·*, Boya Zhou (周博雅)³, Wenjia Cai (蔡文佳)³, Sandy P. Harrison⁴·¹, Martin G. De Kauwe⁵, I. Colin Prentice³·¹

¹ Department of Earth System Science, Ministry of Education Key Laboratory for Earth System Modelling, Institute for Global Change Studies, Tsinghua University, Beijing 100084, China
² State Key Laboratory of Space Information System and Integrated Application, Beijing 100086, China
³ Georgina Mace Centre for the Living Planet, Department of Life Sciences, Imperial College London, Silwood Park Campus, Buckhurst Road, Ascot SL5 7PY, United Kingdom
⁴ School of Archaeology, Geography and Environmental Sciences (SAGES), University of Reading, Reading RG6 6AH, United Kingdom
⁵ School of Biological Sciences, University of Bristol, Bristol, BS8 1TQ, United Kingdom

\* Corresponding author: **Han Wang** — `wang_han@tsinghua.edu.cn`

---

## Abstract

"Greenness" is a key indicator of the functional state of vegetation. However, the physiological processes behind seasonal patterns in greenness are diverse and incompletely understood, hindering the predictability of climate-driven shifts in global foliage phenology. Optimality principles suggest that plants invest in canopy architecture to maximize light capture. Therefore, we hypothesize that, irrespective of specific physiological mechanisms, greenness (fAPAR: fractional canopy light absorption) commonly tracks the seasonal dynamics of potential production (A₀: theoretical canopy carbon uptake with all light absorbed). In other words, **plants tend to display foliage when it is most productive.** We show that observations confirm this hypothesis and develop a model predicting fAPAR from the seasonal cycle of A₀, with a phenological lag that increases (from 2 weeks to 3 months) with increasing moisture. This model **captures 81% of observed variations in fAPAR** and shows that light and environmentally regulated biophysical constraints shape global patterns of vegetation greenness, its seasonal cycle, and its recent increase.

---

## Contents

- [Authors](#authors)
- [Abstract](#abstract)
- [Repository Layout](#repository-layout)
- [Data Inventory](#data-inventory)
- [System Requirements](#system-requirements)
- [Setup Guide](#setup-guide)
- [Running the Workflow](#running-the-workflow)
- [Results](#results)
- [Reproducibility](#reproducibility)
- [Citation](#citation)
- [License](#license)

---

## Repository Layout

```
greenness/
├── code/                    # MATLAB scripts for the manuscript figures
│   ├── main_figures_ncomms.m / .mlx
│   ├── readme.txt
│   └── utility/             # Plotting and statistical helpers
├── data/                    # Packaged inputs (rasters, tables, TRENDY diagnostics)
├── figure/                  # Default export directory
│   ├── Figure1.png          # High-resolution (master copy)
│   ├── Figure1_small.png    # Low-resolution copy used in this README
│   ├── Figure2.png ... Figure6.png
│   └── ...
└── README.md
```

## Data Inventory

| File | Description | Used in |
| --- | --- | --- |
| `FluxInformation.csv` | Flux-tower metadata and biome classes for Figure 2 site diagnostics. | `main_figures_ncomms.m` |
| `gpp_global_pgc.mat` | Annual global GPP totals for PL simulations. | `main_figures_ncomms.m` |
| `trendy_data_output.mat` | TRENDY ensemble seasonal diagnostics. | `main_figures_ncomms.m` |
| `trendy_param_output.mat` | TRENDY model performance summary metrics. | `main_figures_ncomms.m` |
| `trendy_data_output_gpp.mat` | TRENDY ensemble GPP diagnostics. | `main_figures_ncomms.m` |
| `trendy_param_output_gpp.mat` | TRENDY ensemble GPP performance metrics. | `main_figures_ncomms.m` |
| `fapar_global_modis_05d.tif` | MODIS fAPAR climatology (0.5°). | `main_figures_ncomms.m` |
| `fapar_global_plmodel_05d.tif` | PL-model simulated fAPAR climatology (0.5°). | `main_figures_ncomms.m` |
| `a0_global_plmodel_05d.tif` | Potential production A₀ driving the PL model (0.5°). | `main_figures_ncomms.m` |
| `roi_global_05d.tif` | Region-of-interest / land mask (0.5°). | `main_figures_ncomms.m` |
| `fapar_trend_global_plmodel_05d.tif` | PL-simulated fAPAR trend field. | `main_figures_ncomms.m` |
| `fapar_trendy_plmodel_05d.tif` | TRENDY-simulated fAPAR trend field. | `main_figures_ncomms.m` |

All packaged assets in `data/` are referenced by `code/main_figures_ncomms.m`; the GeoTIFF stacks and `roi_global_05d.tif` must remain alongside these files for the workflow to complete.

## System Requirements

- **Software:** MATLAB R2021b (or newer) with the Mapping Toolbox.
- **Operating System:** Windows or macOS tested; Linux should also work when the Mapping Toolbox is available.
- **Hardware:** ≥ 16 GB RAM recommended for global GeoTIFF stacks.

## Setup Guide

1. Clone or download the repository and keep the directory structure intact.
2. Ensure the `data/` folder contains the GeoTIFF and MAT assets distributed with the project.
3. Launch MATLAB and set the current folder to the repository's `code/` directory.
4. Verify that `utility/` is on the MATLAB path (the main script adds it automatically).

## Running the Workflow

```matlab
cd code
main_figures_ncomms      % runs the entire analysis end-to-end
```

The script sequentially:

- Loads gridded greenness and potential-production stacks.
- Generates the seasonality, flux-site synchrony, spatial-comparison, and trend panels.
- Exports publication-ready figures to `figure/` at 600 dpi.

## Results

The script writes the following assets to `figure/`:

| File | Description |
| --- | --- |
| `Figure1.png` | Fig. 1 — fAPAR and A₀ seasonality maps with latitudinal comparison. |
| `Seasonality_Pattern_A0.png` | Global MODIS vs. PL seasonality maps with latitude-band summary. |
| `Figure2.png` / `FluxSynchrony_Map.png` / `FluxSynchrony_Box.png` | Fig. 2 — flux-tower fAPAR–A₀ synchrony diagnostics. |
| `Figure3.png` / `spatial_compare.png` / `spatial_compare_density.png` | Fig. 3 — spatial comparison of PL and MODIS fAPAR. |
| `Figure4.png` / `Seasonality_Pattern.png` / `Trendy_Performance.png` | Fig. 4 — PL vs. TRENDY seasonal-cycle comparison. |
| `Figure5.png` / `fAPARtrend_pvalue.png` / `fAPARtrend_pvalue_nolabel.png` / `fAPARtrend_driver_attribution.png` | Fig. 5 — observed and modelled fAPAR trends and driver attribution. |
| `Figure6.png` / `GPPtrend_series.png` | Fig. 6 — global GPP trajectories for TRENDY, PL, and the A₀-only experiment. |
| `FigS_Trend_Scenariosctrl.png` | Supplementary trend-scenario control panel. |

## Reproducibility

The tag `v1.0.0` of this repository corresponds exactly to the code version used to generate Figs. 1–6 and Supplementary Figs. S1–S34 of the manuscript. To reproduce the figures:

```matlab
% In MATLAB, with the Mapping Toolbox installed
cd code
main_figures_ncomms   % runs the entire analysis end-to-end
```

All inputs in `data/` are bundled with the repository; the workflow writes 600-dpi PNGs into `figure/`.

## Citation

If you use this code in a publication, please cite both the manuscript and the versioned software deposit:

> Zhu, Z., Wang, H., Zhou, B., Cai, W., Harrison, S. P., De Kauwe, M. G., &
> Prentice, I. C. **Optimal canopy light-use strategy shapes global greenness
> dynamics**. *Nature Communications* (2026).

Software deposit (the exact version used to produce all results and figures in the manuscript above):

> Zhu, Z. et al. *Code for "Optimal canopy light-use strategy shapes global
> greenness dynamics"*, `greenness`, **https://doi.org/10.5281/zenodo.XXXXXXX**
> (2026).

(The DOI `10.5281/zenodo.XXXXXXX` is a placeholder; it will be replaced with the actual identifier assigned by Zenodo when this release is published. The frozen DOI for this specific release is preserved permanently.)

## License

MIT — see `LICENSE` for the full text.