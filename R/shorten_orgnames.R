shorten_orgnames <- function (orgnames) {
    old <- c("National Wildlife Refuge", "Waterfowl Production Area", 
        "Wildlife Management Area", "National Fish Hatchery", 
        "Farm Service Agency")
    new <- abbreviate(old, 3)
    for (i in seq_along(old)) orgnames <- gsub(old[i], new[i], 
        orgnames, ignore.case = TRUE)
    orgnames
}
