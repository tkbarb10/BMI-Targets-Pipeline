## Variables used to filter the NHIS data

nhis_vars <- c(
  # Demographics
  "SRVY_YR", "HHX", "FMX", "FPX", "PX",
  
  # Work history (last two are pre-2004)
  "INDSTRN2", "OCCUPN2", "PDSICKA", "INDSTRY2", 'OCCUP2', "PDSICK",
  
  # Basic Health
  "HYPEV", "HYPDIFV", "CHDEV", "ANGEV", "MIEV", "HRTEV", "STREV",
  "EPHEV", "AASMEV", "BMI", "AHEIGHT", "AWEIGHTP", "AHSTATYR",
  "SLEEP", "ASISLEEP", # change from 2013 on
  
  # Cancer
  "CANEV",
  
  # Diabetes (the last two are for 2016 on)
  "DIBEV", "DIBAGE", "AFLHCA10", "DIBEV1", 'DIBAGE1', "INSLN", "INSLN1",
  
  # Cardiac
  "HYPEV", "CHDEV", "ANGEV", "MIEV", "HRTEV", "STREV", "AFLHCA7",
  
  # Smoking
  "SMKEV", "SMKNOW", "SMKSTAT2",
  
  # Physical Activity
  "VIGFREQW", "MODFREQW", "STRFREQW", 'AFLHCA18',
  
  # Alcohol
  "ALCSTAT", "ALCSTAT1"
)

