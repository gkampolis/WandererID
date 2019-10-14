# Description

This repository holds labelled zooplankton data obtained from scanned samples by Marine Scotland. The dataset has been created by Marine Scotland and is released under OGL v3 (please see the more detailed [copyright notice](#copyright-notice) below as well as the included [license file](LICENSE)).

The primary aim is to build a classifier to predict the species of zooplankton from the included  measurements.

# How to

The dataset is supplied in text format (`.txt`) for convenience but the underlying structure is that of tab-separated values, i.e. `.tsv`.

In `R`, using `readr` from `tidyverse` and assuming your working directory is the root of this repository, then:
```r
# install.packages("readr")
require(readr)
data <- read_tsv("Data.txt")
```

# Data provenance

The data has been produced by scanning water samples (obtained  from Stonehaven by Marine Scotland directly) and then automatically detecting all objects/particles in the image. A number of measurements have been extracted from the scans for each particle, mainly referring to geometric measurements and grey levels (morphometric measurements). These were initially stored to PID files and converted to simple text files using [Plankton Identifier](http://www.obs-vlfr.fr/~gaspari/Plankton_Identifier/index.php).

# Copyright notice

© Crown, 2019

This dataset is licensed under the [Open Government License 3.0](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3). <a href="http://www.nationalarchives.gov.uk/doc/open-government-licence/"><img alt="Open Government Licence logo" src="https://www.nationalarchives.gov.uk/images/infoman/ogl-symbol-41px-retina-black.png"></a>
