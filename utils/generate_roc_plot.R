# Generates roc plots from a list of roc objects.  Saves a PNG image to root directory

library(pROC)
generate_roc_plot <- function(roc_objects, file = "initial_roc_plt.png") {
  
  png(file)
  
  len <- length(roc_objects)
  colors <- rainbow(len, alpha = .8)
  lty_values <- rep(1:6, length.out = len)
  
  for (i in seq_along(roc_objects)) {
    roc_plot <- plot(
      roc_objects[[i]],
      legacy.axes = T,
      main = if (i == 1) 'ROC Comparison' else "",
      lwd = 2,
      lty = lty_values[i],
      col = colors[i],
      add = i != 1
    )
  }
  
  if (!is.null(names(roc_objects))) {
    legend("bottomright",
           legend = names(roc_objects),
           col = colors,
           lty = lty_values,
           lwd = 2)
  }
  
  dev.off()
  return(file)
  
}
