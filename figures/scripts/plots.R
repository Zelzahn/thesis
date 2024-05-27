library(ggplot2)
library(ggrepel)

# Colorblind-friendly palette
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
 
# Create a dataset
setup <- c(rep("Native" , 3), rep("Wasmtime" , 3) , rep("Wasmtime (fully optimized)" , 3), rep("WAMR" , 3))
# setup <- c(rep("Native" , 3), rep("Wasmtime" , 3) , rep("Wasmtime (fully optimized)" , 3))
type <- rep(c("Total" , "Maximum" , "At the end") , 4)
# type <- rep(c("Total" , "Maximum" , "At the end") , 3)

value_display <- c(9007,8238, 0, 6228039, 1451947, 35074, 32123, 24277, 1656, 10330, 8974, 0)
value_sensor <- c(1270,1052, 1024, 26123631, 2666861, 35074, 38081, 30294, 1656)

# value <- value_sensor
value <- value_display

data <- data.frame(setup,type,value)

# Change the order from alphabetical to the desired one
data$order <- factor(data$setup, levels = c("Native", "Wasmtime", "Wasmtime (fully optimized)", "WAMR"))

to_kib <- function(val) {
    kib <- val / 1024
    rounded <- format(round(kib, 2), nsmall = 2)

    paste(rounded, " KiB")
}

to_mib <- function(val) {
    kib <- val / 1024
    rounded <- format(round(kib / 1024, 2), nsmall = 2)

    paste(rounded, " MiB")
}
 
# Grouped
ggplot(data, aes(fill=order, y=value, x=type)) + 
    # scale_y_continuous(transform = "log2", limits = c(NA, 3e07), labels = to_kib) +
    # scale_y_continuous(trans=scales::pseudo_log_trans(base = 2), limits = c(NA, 3e07)) +
    scale_y_continuous(transform = "pseudo_log", 
                       limits = c(NA, max(value_sensor)), 
                       labels = to_mib, 
                       breaks = seq(0, max(value_sensor), by = 1024 * 1024),
                       guide = guide_axis(check.overlap = TRUE)) + 
    scale_fill_manual(values=cbPalette) +
    geom_col(position = "dodge") +
    geom_label_repel(aes(label=to_kib(value)), segment.alpha = 0.2) + 
    labs(x = "", y = "Memory size", fill = "Setup") + 
    theme_minimal()

# ggsave("sensor_memory.png")
ggsave("display_memory.png")

