# Intro Comments ----------------------------------------------------------

# Purpose: Script to setup parallelization for mlr execution
# Author: Georgios Kampolis
# For: Marine Scotland Science
# Comments: As part of RGU MSc course in Data Science

# Details: This script is called by Main.R in the root folder of the project.


# Parallelization setup ---------------------------------------------------

# Determine if there are enough cores for parallelization
if (parallel::detectCores() >= 4) {
  if (Sys.info()[1]=="Windows") {
    # OS is Windows
    OSmode <- "socket"
    
  } else {
    # OS is Linux or Mac or other Unix based - NOT TESTED!
    OSmode <- "multicore"

  }
  
  parallelMap::parallelStart(
    mode = OSmode,
    cpus = parallel::detectCores() - 2L # Leave 2 cores free for other processes 
  )
  
  # Flag to enforce paralleziation stop or not at the end.
  parallelizationFlag <- TRUE
  
  # Clean up
  rm(OSmode)

} else {
  # Not enough cores to make parallelization worthwile.
  parallelizationFlag <- FALSE
}
