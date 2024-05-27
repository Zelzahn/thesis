library(ggplot2)
library(ggrepel)

# Colorblind-friendly palette
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
 
# Create a dataset
setup <- rep(c("Native", "Wasmtime", "Wasmtime (fully optimized)", "WAMR"), 2)
type <- c(rep("Sensor", 4), rep("Display", 4))

value <- c(7.3159, 8.7018, 7.8869, NA, 3.0009, 10.165, 2.9623, 3.0505)

data <- data.frame(type, setup, value)

# Change the order from alphabetical to the desired one
data$order <- factor(data$setup, levels = c("Native", "Wasmtime", "Wasmtime (fully optimized)", "WAMR"))

to_ms <- function(val) {
    paste(val, " ms")
}
 
# Grouped
ggplot(data, aes(fill=order, y=value, x=type)) + 
    scale_fill_manual(values=cbPalette) +
    geom_bar(position="dodge", stat="identity") +
    geom_label_repel(aes(label=to_ms(value))) + 
    labs(x = "", y = "Execution time", fill = "Setup") + 
    theme_minimal()

ggsave("execution_times.png")

