## Upsample the minority class to balance the training data
## df: data frame with UCOD_LEADING as target

upsampled <- function(df) {
  df <- upSample(
    x = df[, setdiff(names(df), "UCOD_LEADING")],
    y = df$UCOD_LEADING,
    yname = "UCOD_LEADING"
)
  return(df)
}
