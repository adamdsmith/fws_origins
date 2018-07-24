presence <- tibble(
  pcode = 1:6,
  pname = c("extant", "probably extant", "possibly extant", "possibly extinct", "extinct", "uncertain"),
  pdesc = c("The species is known or thought very likely to occur presently in the area, usually encompassing current or recent localities where suitable habitat at appropriate altitudes remains.",
            "The species' presence is considered probable, either based on extrapolations of known records, or realistic inferences (e.g., based on distribution of suitable habitat at appropriate altitudes and proximity to areas where it is known or thought very likely to remain Extant). 'Probably Extant' ranges often extend beyond areas where the species is Extant, or may fall between them.",
            "The species may possibly occur, based on the distribution of suitable habitat at appropriate altitudes, but where there are no known records. 'Possibly Extant' ranges often extend beyond areas where the species is Extant (q.v.) or Probably Extant (q.v.), or may fall between them.",
            "The species was formerly known or thought very likely to occur in the area, but it is most likely now extirpated from the area because habitat loss/other threats are thought likely to have extirpated the species and/or owing to a lack of records in the last 30 years.",
            "The species was formerly known or thought very likely to occur in the area, but there have been no records in the last 30 years and it is almost certain that the species no longer occurs, and/or habitat loss/other threats have almost certainly extirpated the species.",
            "The species was formerly known or thought very likely to occur in the area but it is no longer known whether it still occurs (usually because there have been no recent surveys).")
)
  
origin <- tibble(
  ocode = 1:5,
  oname = c("native", "reintroduced", "introduced", "vagrant", "uncertain"),
  odesc = c("The species is/was native to the area",
            "The species is/was reintroduced through either direct or indirect human activity",
            "The species is/was introduced outside of its historical distribution range through either direct or indirect human activity.",
            "The species is/was recorded once or sporadically, but it is known not to be native to the area.",
            "The species' provenance in an area is not known (it may be native, reintroduced or introduced).")
)

seasonality <- tibble(
  scode = 1:5,
  sname = c("resident", "breeding", "non-breeding", "passage", "uncertain"),
  sdesc = c("The species is/was known or thought very likely to be resident throughout the year",
            "The species is/was known or thought very likely to occur regularly during the breeding season and to breed.",
            "The species is/was known or thought very likely to occur regularly during the non-breeding season. In the Eurasian and North American contexts, this encompasses 'winter'.",
            "The species is/was known or thought very likely to occur regularly during a relatively short period(s) of the year on migration between breeding and non-breeding ranges.",
            "The species is/was present, but it is not known if it is present during part or all of the year.")
)
