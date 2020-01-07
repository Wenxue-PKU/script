library(ChIPseeker)
library(TxDb.Mmusculus.UCSC.mm10.knownGene)
txdb <- TxDb.Mmusculus.UCSC.mm10.knownGene
library(clusterProfiler)
setwd('/WORK/lbyybl/WH/rvb/cor_uniq/sample_Ruvbl/R1_2_overlap/grahp/annopeak')
#files <- getSampleFiles()
#print(files)
peak_file <- '../../Ruvbl1_2_overlap_peak.narrowPeak'
#peak <- readPeakFile(files[[4]])
peak <- readPeakFile(peak_file)
#setwd('/DATA/work/lbyybl/wh/ruvb2/chip-seq/Ruvbl1/sample20190509/graph/subtract_heatmap/distribution/annopeak')
pdf('peak_chr.pdf',width = 6,height = 5)
covplot(peak,chrs = c(paste0('chr',c(1:19,'X','Y'))))
dev.off()
#covplot(peak, weightCol="V5", chrs=c("chr17", "chr18"), xlim=c(4.5e7, 5e7))
#data("tagMatrixList")
#tagMatrix <- tagMatrixList[[4]]
# promoter <- getPromoters(TxDb=txdb, upstream=3000, downstream=2000)
# tagMatrix <- getTagMatrix(peak, windows=promoter)
# tagHeatmap(tagMatrix, xlim=c(-3000, 3000), color="red")
pdf('promoter_hetmap.pdf',width = 3,height = 7)
peakHeatmap(peak_file, TxDb=txdb, upstream=3000, downstream=3000, color="red")
dev.off()
# plotAvgProf(tagMatrix, xlim=c(-2000, 2000),
#             xlab="Genomic Region (5'->3')", ylab = "Read Count Frequency")
pdf('promoter_profile.pdf',width=5,height = 5)
plotAvgProf2(peak_file, TxDb=txdb, upstream=3000, downstream=3000,
             xlab="Genomic Region (5'->3')", ylab = "Read Count Frequency")
dev.off()
# plotAvgProf(tagMatrix, xlim=c(-3000, 3000), conf = 0.95, resample = 1000)

peakAnno <- annotatePeak(peak_file, tssRegion=c(-2000, 2000),
                         TxDb=txdb, annoDb="org.Mm.eg.db")
colors   <- rainbow(10)
pdf('pieplot_anno.pdf',width = 6,height = 4)
plotAnnoPie(peakAnno)
dev.off()
pdf('bar_anno.pdf',width = 6,height = 3)
plotAnnoBar(peakAnno)
dev.off()
pdf('venn_anno.pdf',width = 5,height = 5)
vennpie(peakAnno)
dev.off()
pdf('upset_anno.pdf',width = 1,height = 1)
upsetplot(peakAnno)
dev.off()
pdf('unset_venn_anno.pdf',width = 12,height = 12)
upsetplot(peakAnno, vennpie=TRUE)
dev.off()
pdf('dis2tss_anno.pdf',width = 6,height = 3)
plotDistToTSS(peakAnno,
              title="Distribution of transcription factor-binding loci\nrelative to TSS")
dev.off()
library(ReactomePA)

pathway1 <- enrichPathway(as.data.frame(peakAnno)$geneId,organism = 'mouse')
head(pathway1, 2)
gene <- seq2gene(peak, tssRegion = c(-1000, 1000), flankDistance = 3000, TxDb=txdb)
enrich_gene <- data.frame('name'=gene)
fwrite(enrich_gene,'enrich_gene.txt',col.names = F)
pathway2 <- enrichPathway(gene,organism = 'mouse')
head(pathway2, 2)
pdf('seq2gene_enrich.pdf',width = 8,height = 5)
dotplot(pathway2)
dev.off()
pdf('enrich.pdf',width=7,height = 5)
dotplot(pathway1)
dev.off()