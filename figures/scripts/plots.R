library
library(ggplot2)
library(ggrepel)

# Colorblind-friendly palette
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
 
# create a dataset
setup <- c(rep("Native" , 3), rep("WAMR" , 3) , rep("Wasmtime" , 3) , rep("Wasmtime (fully optimized)" , 3))
type <- rep(c("Total" , "Maximum" , "At the end") , 4)
# TODO: WAMR als laatste zetten
value <- c(9007,8238, 0, 10330, 8974, 0, 6228039, 1451947, 35074, 32123, 24277, 1656)
data <- data.frame(setup,type,value)

to_kib <- function(val) {
    kib <- val / 1024
    rounded <- format(round(kib, 2), nsmall = 2)

    paste(rounded, " KiB")
}
 
# Grouped
ggplot(data, aes(fill=setup, y=value, x=type)) + 
    scale_fill_manual(values=cbPalette) +
    geom_bar(position="dodge", stat="identity") +
    scale_y_continuous(trans=scales::pseudo_log_trans(base = 10)) +
    geom_label_repel(aes(label=to_kib(value))) + 
    labs(x = "", y = "Memory size", fill = "Setup") +
    theme_minimal()

ggsave("display_memory.png")

