# WandererID
An open source solution for automatic zooplankton classification using `R`, developed for [Marine Scotland Science](https://www2.gov.scot/Topics/marine/science).

This work formed the basis of a postgraduate project at the Robert Gordon University. The full report explaining the rationale for each choice made and what other alternatives are available (methodology), along with an introduction to the domain of application and a thorough discussion of results is available here: 

[*Kampolis, G., 2019. Automated zooplankton classification: Project Report, Aberdeen: Robert Gordon University*](https://www.gkampolis.com/MScReport/gkampolisAutomatedZooplanktonClassification.pdf).

A simple prototype utilizing the resulting classifier from this project and serving as a proof-of-concept is available here: [WandererPrototype](https://github.com/gkampolis/WandererPrototype).

An introduction to the supplied data set is available in the `Codebook` folder. *If github is having problems with rendering the notebook, you can try [here](https://nbviewer.jupyter.org/github/gkampolis/WandererID/blob/master/Codebook/Codebook_EDA.ipynb).*

---

Marine Scotland Science (MSS) collects samples of the microscopic marine animals known as zooplankton ("zoo" meaning animal and "plankton", meaning to wander/wanderer), with the data generated being used in monitoring trends of national (UK) and international importance. Classification of zooplankton is a time-consuming process leading to low sample throughput. A much quicker alternative is to scan samples and obtain measurements that will be classified via a machine learning system, enhancing the organization's ability to provide scientific advice on trends in the zooplankton communities in Scottish waters. This project serves as an early milestone in developing this approach and will aid MSS in evaluating the proposed process. 

---

## Structure and how-to

The point of entry for the project is `Main.R`. It is assumed that this will be accessed by launching RStudio via double-clicking the `WanderedID.Rproj` from the project root, for automatically detecting the workspace root directory. This is important as all paths are constructed in a relative manner. Of course if setting the workspace directory manually, then the above is moot.

Package requirements are handled in the `Scripts/loadPackages.R` via `pacman`.

Please note that sourcing this script is a a lengthy affair, due to the time needed for training. A more practical way of working with this script would be to step-through the `Main.R` and taking advantage of the simple flag system implemented at the top, to only run the needed sections.

## Data set description

An introductory analysis of key aspects of the data set is forthcoming. Until then, please refer to chapter 3 of the project's [main report](https://www.gkampolis.com/MScReport/gkampolisAutomatedZooplanktonClassification.pdf).

## Data attribution

Please note that the contents of the `Data` folder are governed by a different license than the rest of the project, as noted by the included license in that folder. Specifically, this project is based on data that contains public sector information.

**Copyright for the used data set is © Crown, Marine Scotland, 2019. This dataset is licensed under the [Open Government License 3.0](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3).** <a href="http://www.nationalarchives.gov.uk/doc/open-government-licence/"><img alt="Open Government Licence logo" src="https://www.nationalarchives.gov.uk/images/infoman/ogl-symbol-41px-retina-black.png"></a> 


## Further work

The main avenues for future work are with respect to the class imbalance (which is treated separately on its own sub section), feature engineering and the potential for further hyperparameter tuning. These are expanded upon in section 8.3 of the [main report](https://www.gkampolis.com/MScReport/gkampolisAutomatedZooplanktonClassification.pdf).

Of immediate interest is the possibility of implementing the tuning of XGBoost with a Model-Based/Bayesian Optimization approach instead of the random search that was initially used. While this is a relatively simple change to implement (see the `R` package `mlrMBO` for details), the time required for training with the currently owned hardware is prohibitive. As such, this will be added some time in the future, but it is a low priority.