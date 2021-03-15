# createLink for GeneCards ------------------------------------------------
geneCardsLink <- function(val,name) {
  sprintf('<a href="https://www.genecards.org/cgi-bin/carddisp.pl?gene=%s" target="_blank" class="btn btn-primary">%s</a>',val,name)
}

# createLink for GPL ------------------------------------------------------
gplLink <- function(val,gpl) {
  sprintf('<a href="https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=%s" target="_blank" class="btn btn-primary">%s</a>',val,gpl)
}

# createLink for NCBI -----------------------------------------------------
ncbiLink <- function(val,ncbi) {
  sprintf('<a href="https://www.ncbi.nlm.nih.gov/gene/?term=%s" target="_blank" class="btn btn-primary">%s</a>',val,ncbi)
}

# createLink for Esemble --------------------------------------------------
ensemblLink <- function(val,ensembl) {
  sprintf('<a href="https://www.ensembl.org/Homo_sapiens/Gene/Summary?db=core;g=%s" target="_blank" class="btn btn-primary">%s</a>',val,ensembl)
}