pacman::p_load(dplyr, sf, openxlsx)

## NOTE: I'm using range maps and taxonomy that's a couple years out of date
## Accessed in October 2015

# Create metadata to link with presence, origin, and seasonality codes
# From http://datazone.birdlife.org/species/spcdistPOS
source("R/make_metadata.R")
source("R/shorten_orgnames.R")
# refs <- readRDS(file.path(system.file("extdata/fws_interest.rds", package = "fwspp"))) %>%
#   filter(RSL_TYPE == "NWR") %>%
#   # Crude centroids are good enough
#   st_centroid()
# saveRDS(refs, file = "Output/refpts.rds")
refs <- readRDS("Output/refpts.rds")

# botw <- read_sf(dsn = "~/FWS_Projects/GIS/BOTW.gdb",
#                 layer = "All_Species", stringsAsFactors = FALSE, quiet = TRUE) %>%
#   select(sciname = SCINAME, pcode = PRESENCE, ocode = ORIGIN, scode = SEASONAL)
# keep <- sapply(st_intersects(botw, refs), function(z) if (length(z)==0) FALSE else TRUE)
# refbirds <- botw[keep, ]
# saveRDS(refbirds, file = "Output/refbirds.rds")
refbirds <- readRDS("Output/refbirds.rds")

# Add common names
# Oct 2015 version of checklist
# From http://datazone.birdlife.org/species/taxonomy
birdnames <- read.xlsx("Data/BirdLife_Checklist_Version_8.xlsx",
                       startRow = 2) %>%
  select(sciname = Scientific.name, comname = Common.name) %>%
  filter(!is.na(comname))
refbirds <- left_join(refbirds, birdnames, by = "sciname")

# Use Harris Neck as an example
hn <- grep("HARRIS NECK", refs$ORGNAME)

# for (i in seq(nrow(refs))) {
for (i in hn) { # Harris Neck
  rpt <- filter(refs, row_number() == i)
  ref <- pull(rpt, ORGNAME) %>% shorten_orgnames()
  out <- refbirds[st_intersects(rpt, refbirds)[[1]], ] %>% as.data.frame() %>%
    left_join(presence, by = "pcode") %>%
    left_join(origin, by = "ocode") %>%
    left_join(seasonality, by = "scode") %>%
    select(comname, sciname, presence = pname, origin = oname, seasonality = sname)
  # Make, write, and save Excel spreadsheet
  wb <- createWorkbook()
  addWorksheet(wb, ref)
  setColWidths(wb, 1, cols = seq_along(out), widths = "auto")
  freezePane(wb, 1, firstRow = TRUE)
  writeData(wb, 1, out)
  path <- file.path("Output/refuge_birds", paste0(ref, ".xlsx"))
  saveWorkbook(wb, path, overwrite = TRUE)
}