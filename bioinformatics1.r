if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install(version = "3.11")

myDNA <- c("ATGTTGCATTCATTAATTAAGAACGACCCAATACA") 
myDNASeq <- BiocManager::DNAString("CTGATTT-GATGGTC-NAT") 


BiocManager::install
