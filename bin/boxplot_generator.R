library(ggplot2)
library(scales)

options(scipen = 999)

args = commandArgs(trailingOnly=TRUE)
##args <- "TEST"
##args[1] <- "tmp/BRCA1.dataframe"
##args[2] <- "results/BRCA1.png.build"

I_FILE <- args[1]
O_FILE <- args[2]

wg.df <- read.table(I_FILE, header = T)

GENE <- unique(wg.df$GENE)

ggplot(wg.df, aes(x = EXON, y = MEAN_DEPTH/TOTAL_READS_IN_BAM)) +
    geom_boxplot() +
    labs(title=paste0("Exon coverage for ",GENE),
         x ="EXON in format chromosome:START-END:EXON_NUMBER",
         y = "Normalized depth \n (mean depth/total reads in bam)") +
    theme(axis.title=element_text(size=8),
          axis.text=element_text(size=5),
          plot.title=element_text(size=8,face="bold", hjust = 0.5),
      axis.text.x = element_text(angle = 45, hjust = 1))

ggsave(O_FILE, device = "png")
dev.off()
