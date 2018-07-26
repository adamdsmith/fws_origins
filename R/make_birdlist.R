make_birdlist <- function(refuge = NULL, outdir = "Output/refuge_birds") {
  
  # Get list of available refuges
  poss_refs <- pull(refs, ORGNAME) %>% unique() %>% sort()
  # Pick a refuge
  if (is.null(refuge)) {
    refuge <- utils::select.list(poss_refs, title="Select one or more refuges.",
                                  multiple = TRUE, graphics = TRUE)
    if (length(refuge) == 0) stop("You must select or provide a refuge.", call. = FALSE)
  } else {
    refuge <- poss_refs[grep(paste(refuge, collapse = "|"), poss_refs, ignore.case = TRUE)]
    if (identical(refuge, character(0))) stop("No refuges matched your criteria.", call. = FALSE)
    message(length(refuge), " refuges matched your criteria:")
    message(paste(paste(" ", refuge), collapse = "\n"))
  }

  # Convert polygons to bounding boxes to speed intersection
  r_bbs <- filter(refs, ORGNAME %in% refuge)
  bb_list = lapply(seq(nrow(r_bbs)), function(i) {
    tmp <- r_bbs[i, ]
    on <- pull(tmp, ORGNAME)
    tmp <- st_bbox(tmp) %>% st_as_sfc() 
    tmp <- st_sf(data.frame(ORGNAME = on, geom = tmp))
    tmp
  })
  r_bbs <- do.call("rbind", bb_list)
  keep <- suppressMessages(st_intersects(r_bbs, refbirds))
  names(keep) <- refuge

  for (i in refuge) {
    ref <- shorten_orgnames(i)
    out <- refbirds[keep[[i]], ] %>% as.data.frame() %>%
      left_join(origin, by = "ocode") %>%
      left_join(seasonality, by = "scode") %>%
      dplyr::select(CommonName, ScientificName, CommonNameBL = CNFromBirdlife,
                    ScientificNameBL = SNFromBirdlife, Origin = fws_oname,
                    Seasonality = fws_sname, ServcatClassID, DisplayOrder) %>%
      arrange(DisplayOrder)

    # Make, write, and save Excel spreadsheet
    wb <- createWorkbook()
    addWorksheet(wb, ref)
    setColWidths(wb, 1, cols = seq_along(out), widths = "auto")
    freezePane(wb, 1, firstRow = TRUE)
    writeData(wb, 1, out)
    if (is.null(outdir)) outdir <- ""
    path <- file.path(outdir, paste0(ref, ".xlsx"))
    saveWorkbook(wb, path, overwrite = TRUE)
    message("Processed bird list for ", ref)
  }
}