#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic 
  fileUpload <- mod_fileUpload_server("fileUpload_ui_1")
  mod_geneInfo_server("geneInfo_ui_1",fileUpload=fileUpload)
  mod_GO_server("GO_ui_1",fileUpload=fileUpload)
  mod_KEGG_server("KEGG_ui_1",fileUpload=fileUpload)
}
