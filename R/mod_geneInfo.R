#' geneInfo UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_geneInfo_ui <- function(id){
  ns <- NS(id)
  tagList(
 	shinycustomloader::withLoader(
      DT::DTOutput(ns("geneInfo")),
      type = "html",
      loader = "dnaspin"
    ),
    downloadButton(ns("downloadgeneInfo"), "Download Gene Info")
  )
}
    
#' geneInfo Server Functions
#'
#' @noRd 
mod_geneInfo_server <- function(id,fileUpload=""){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 	geneID <- reactive({
      fileUpload$geneID()
    })
    
    idType <- reactive({
      fileUpload$idType()
    })
    geneInfoO <- reactive({
      geneID <- geneID()
      idType <- idType()
      AnnoProbe::annoGene(geneID[,1],ID_type = idType)
    })
    geneInfo <- reactive({
      tmp <- geneInfoO()
      tmp$NCBI <- ncbiLink(tmp$SYMBOL,tmp$SYMBOL)
      tmp$Ensembl.ASIA <- ensemblLink(tmp$ENSEMBL,tmp$ENSEMBL)
      tmp$GeneCards <- geneCardsLink(tmp$SYMBOL,tmp$SYMBOL)
      tmp
    })
    
    output$geneInfo <- DT::renderDT(
      #output$preview3 <- reactable::renderReactable({
      DT::datatable( geneInfo(), escape = FALSE,filter="top", selection="multiple",
                     rownames = TRUE, 
                     extensions = 'Buttons', 
                     options=list(
                       sDom  = '<"top">flrt<"bottom">ip',
                       #columnDefs = list(list(className = 'dt-center', targets = 5)),
                       pageLength = 15,
                       lengthMenu = list(c(15, 50, 100, -1),c(15, 50, 100, "ALL")),
                       dom = 'Blfrtip',
                       buttons = list(list(extend ='collection',
                                           buttons =  c('csv', 'excel', 'pdf'),text = 'Download View'
                       ),
                       list(extend ='colvis',text = 'Hide Columns')),
                       scrollX = TRUE,
                       scrollY = TRUE,
                       fixedColumns = TRUE,
                       fixedHeader = TRUE
                     )
      )
    )
    
    output$downloadgeneInfo <- downloadHandler(
      filename = function() {
        paste("Gene_Info", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        write.csv(geneInfoO(), file)
      }
    )
  })
}
    
## To be copied in the UI
# mod_geneInfo_ui("geneInfo_ui_1")
    
## To be copied in the server
# mod_geneInfo_server("geneInfo_ui_1")
