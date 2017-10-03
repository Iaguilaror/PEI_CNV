library(ggplot2)
library(scales)
options(scipen = 999)

args = commandArgs(trailingOnly=TRUE)
##args <- "TEST"
##args[1] <- "tmp/PPIG.dataframe"
##args[2] <- "results/PPIG.png.build"

I_FILE <- args[1]
O_FILE <- args[2]

wg.df <- read.table(I_FILE, header = T)
wg.df$EXON_NUMBER <- as.factor(wg.df$EXON_NUMBER)
GENE <- unique(wg.df$GENE)

###NOT SUCESSFULLY TESTED TO LABEL OUTLIERS
#wg.df$mean_depth_normby_total_reads_outliers <- ifelse(
#  wg.df$MEAN_DEPTH/wg.df$TOTAL_READS_IN_BAM < quantile(wg.df$MEAN_DEPTH/wg.df$TOTAL_READS_IN_BAM, 0.25) - 1.5 * IQR(wg.df$MEAN_DEPTH/wg.df$TOTAL_READS_IN_BAM) | wg.df$MEAN_DEPTH/wg.df$TOTAL_READS_IN_BAM > quantile(wg.df$MEAN_DEPTH/wg.df$TOTAL_READS_IN_BAM, 0.75) + 1.5 * IQR(wg.df$MEAN_DEPTH/wg.df$TOTAL_READS_IN_BAM), "TEST", NA)

#wg.df$mean_depth_normby_gene_reads <- ifelse(
#  wg.df$MEAN_DEPTH/wg.df$READS_IN_GENE_CODING_REGION < quantile(wg.df$MEAN_DEPTH/wg.df$READS_IN_GENE_CODING_REGION, 0.25) - 1.5 * IQR(wg.df$MEAN_DEPTH/wg.df$READS_IN_GENE_CODING_REGION) | wg.df$MEAN_DEPTH/wg.df$READS_IN_GENE_CODING_REGION > quantile(wg.df$MEAN_DEPTH/wg.df$READS_IN_GENE_CODING_REGION, 0.75) + 1.5 * IQR(wg.df$MEAN_DEPTH/wg.df$READS_IN_GENE_CODING_REGION), "TEST", NA)

wg.plot1 <- ggplot(wg.df, aes(x = EXON_NUMBER, y = MEAN_DEPTH/TOTAL_READS_IN_BAM)) +
    geom_boxplot() +
    geom_dotplot(binaxis='y', stackdir='center', dotsize=0.2) +
    labs(title=paste0("Exon coverage for ",GENE),
         x ="EXON NUMBER",
         y = "Normalized depth \n (mean depth/total reads in bam)") +
    theme(axis.title=element_text(size=8),
          axis.text=element_text(size=10),
          plot.title=element_text(size=8,face="bold", hjust = 0.5),
      axis.text.x = element_text(angle = 45, hjust = 1, size = 10)) #+
#  geom_text(aes(label = wg.df$mean_depth_normby_total_reads_outliers), na.rm = TRUE, hjust = -0.3)

wg.plot2 <- ggplot(wg.df, aes(x = EXON_NUMBER, y = MEAN_DEPTH/READS_IN_GENE_CODING_REGION)) +
  geom_boxplot() +
  geom_dotplot(binaxis='y', stackdir='center', dotsize=0.2) +
  labs(title=paste0("Exon coverage for ",GENE),
       x ="EXON NUMBER",
       y = "Normalized depth \n (mean depth/reads in coding region)") +
  theme(axis.title=element_text(size=8),
        axis.text=element_text(size=10),
        plot.title=element_text(size=8,face="bold", hjust = 0.5),
        axis.text.x = element_text(angle = 45, hjust = 1, size = 10)) #+
#  geom_text(aes(label = wg.df$mean_depth_normby_gene_reads), na.rm = TRUE, hjust = -0.3)

pdf(O_FILE)
wg.plot1
wg.plot2
dev.off()
