pacman::p_load(dplyr, sf, openxlsx)

## NOTE: I'm using range maps and taxonomy that's a couple years out of date
## Accessed in October 2015

# Create metadata to link with presence, origin, and seasonality codes
# From http://datazone.birdlife.org/species/spcdistPOS
source("R/make_metadata.R")
source("R/shorten_orgnames.R")
source("R/make_birdlist.R")

# refs <- readRDS(file.path(system.file("extdata/fws_interest.rds", package = "fwspp"))) %>%
#   filter(RSL_TYPE == "NWR")
# saveRDS(refs, file = "Output/refs.rds")
refs <- readRDS("Output/refs.rds")

# botw <- read_sf(dsn = "~/FWS_Projects/GIS/BOTW.gdb",
#                 layer = "All_Species", stringsAsFactors = FALSE, quiet = TRUE) %>%
#   select(sciname = SCINAME, pcode = PRESENCE, ocode = ORIGIN, scode = SEASONAL)
# keep <- sapply(st_intersects(botw, refs), function(z) if (length(z)==0) FALSE else TRUE)
# refbirds <- botw[keep, ]
# saveRDS(refbirds, file = "Output/refbirds.rds")
refbirds <- readRDS("Output/refbirds.rds")

# Fill out taxonomy from FWS and BirdLife
# Oct 2015 version of checklist
# From http://datazone.birdlife.org/species/taxonomy
bl_names <- read.xlsx("Data/BirdLife_Checklist_Version_8.xlsx",
                      startRow = 2) %>%
  # Getting rid of duplicates
  select(SNFromBirdlife = Scientific.name, CNFromBirdlife = Common.name) %>%
  filter(!is.na(CNFromBirdlife))
fws_names <- read.csv("Data/USFWS_BirdLife_lookup.csv", stringsAsFactors = FALSE) %>%
  select(-CNFromBirdlife)
birdnames <- left_join(bl_names, fws_names, by = "SNFromBirdlife")
refbirds <- left_join(refbirds, birdnames, by = "SNFromBirdlife")

# Harris Neck
make_birdlist()
