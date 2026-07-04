# Optimal canopy light-use strategy shapes global greenness dynamics

[DOI](https://doi.org/10.5281/zenodo.21186441)
[License: MIT](LICENSE)

Figure 1

> **Fig. 1 |** Seasonality of the fraction of absorbed photosynthetically active radiation (fAPAR, dimensionless) and potential primary production (A₀, g C m⁻² month⁻¹). **(a)** fAPAR seasonality (dimensionless) derived from the MODIS product. The seasonality metric used here represents seasonal concentration, ranging from zero (uniform throughout the year) to unity (a complete leaf growth cycle within a single month). **(b)** A₀ seasonality (dimensionless) derived from the P model. **(c)** Latitudinal variations in the seasonality of fAPAR and A₀, with values representing area-weighted averages in 1° latitudinal bands.

This repository accompanies the manuscript **"Optimal canopy light-use strategy shapes global greenness dynamics"** (Zhu et al., *Nature Communications*, 2026; manuscript **NCOMMS-25-24941B**) and provides the code, data, and figures needed to reproduce the main and supplementary results.

---

## Highlights

- **A general synchronisation hypothesis** for vegetation greenness: fAPAR (fraction of absorbed photosynthetically active radiation) tracks the seasonal dynamics of potential production **A₀** across biomes — *plants tend to display foliage when it is most productive.*
- **The PL model** (potential production × light-use strategy) extends the optimality-based P model with a leaf allocation fraction *η* and a phenological lag *τ* (2 weeks – 3 months, increasing with moisture) to predict the **monthly seasonal cycle of fAPAR** directly from climate forcing.
- **Captures 81 %** of the observed monthly variation in MODIS fAPAR over 2001–2019, and substantially outperforms the 12-model **TRENDY-v9** DGVM ensemble (mean R² = 0.55 ± 0.2) in reproducing fAPAR seasonality (R² = 0.81, RMSE = 0.13).
- **Mechanistic driver attribution** of the recent global greening trend: rising CO₂ dominates tropical greening, warming dominates high-latitude greening, and precipitation shifts dominate semi-arid greening / browning.
- **Global GPP** increased by **11.7 ± 1.6 Pg C** over 2001–2019 (≈ 134.5 Pg C yr⁻¹ in 2019); a counterfactual experiment isolates that roughly two-thirds of the increase arises from leaf-level physiology and one-third from greening.

---

## Descriptions

To understand the emergent seasonal pattern of vegetation greenness based on the concept of optimality, we hypothesized that the seasonal dynamics of canopy greenness tracks that of canopy potential production. Canopy greenness was indexed by fraction of absorbed photosynthetically active radiation (fAPAR). Canopy potential production was defined here as the rate of canopy photosynthesis that would be achieved if all light were absorbed by green tissues (A0), which was estimated from climate variables with a universal photosynthesis model, the P model. We tested our hypothesis at a global scale by comparing the spatial patterns of fAPAR seasonality and A0 seasonality, especially their corelation coefficient cross grid cells and along the latitudinal gradient. We also tested our hypothesis at flux sites cross various biomes with corelation coefficient of observed monthly fAPAR and the P model predicted monthly A0. With the extensive supports from satellite data and ground data, we further developed a universal model of canopy greenness (the PL model) in which the seasonal dynamics of fAPAR are predicted directly from the climate-driven seasonal cycle of A0. We evaluated our PL model by comparing the fAPAR predictions with the remote sensing data, and predictions from state-of-the-art process-based models in TRENDY projects. We also applied the PL model to predict historical trends in global fAPAR and GPP with a comparison with TRENDY models, and identify the primary drivers of global greening and browning trends with a factorial simulation.

---

## Contents

- [Highlights](#highlights)
- [Authors](#authors)
- [Abstract](#abstract)
- [Descriptions](#descriptions)
- [Repository Layout](#repository-layout)
- [Data Inventory](#data-inventory)
- [Source Data](#source-data)
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
│   ├── main_figures_ncomms.m
│   ├── readme.txt
│   └── utility/             # Plotting and statistical helpers
├── data/                    # Packaged inputs (rasters, tables, TRENDY diagnostics)
├── source_data/             # Tabular source data behind the main figures
├── figure/                  # Default export directory
│   ├── Figure1.png          # High-resolution (master copy)
│   ├── Figure1_small.png    # Low-resolution copy used in this README
│   ├── Figure2.png ... Figure6.png
│   └── ...
└── README.md
```

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


| File                                                                                                            | Description                                                                  |
| --------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| `Figure1.png`                                                                                                   | Fig. 1 — fAPAR and A₀ seasonality maps with latitudinal comparison.          |
| `Seasonality_Pattern_A0.png`                                                                                    | Global MODIS vs. PL seasonality maps with latitude-band summary.             |
| `Figure2.png` / `FluxSynchrony_Map.png` / `FluxSynchrony_Box.png`                                               | Fig. 2 — flux-tower fAPAR–A₀ synchrony diagnostics.                          |
| `Figure3.png` / `spatial_compare.png` / `spatial_compare_density.png`                                           | Fig. 3 — spatial comparison of PL and MODIS fAPAR.                           |
| `Figure4.png` / `Seasonality_Pattern.png` / `Trendy_Performance.png`                                            | Fig. 4 — PL vs. TRENDY seasonal-cycle comparison.                            |
| `Figure5.png` / `fAPARtrend_pvalue.png` / `fAPARtrend_pvalue_nolabel.png` / `fAPARtrend_driver_attribution.png` | Fig. 5 — observed and modelled fAPAR trends and driver attribution.          |
| `Figure6.png` / `GPPtrend_series.png`                                                                           | Fig. 6 — global GPP trajectories for TRENDY, PL, and the A₀-only experiment. |
| `FigS_Trend_Scenariosctrl.png`                                                                                  | Supplementary trend-scenario control panel.                                  |


## Reproducibility

The tag `v1.0.2` of this repository corresponds to the version archived on Zenodo as **[https://doi.org/10.5281/zenodo.21186441](https://doi.org/10.5281/zenodo.21186441)** and contains the code, packaged inputs, and figure-generation scripts used to produce Figs. 1–6 and Supplementary Figs. S1–S34 of the manuscript. To reproduce the figures:

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

Versioned software deposit:

> Zhu, Z. et al. *Optimal canopy light-use strategy shapes global greenness

## License

MIT — see `LICENSE` for the full text.