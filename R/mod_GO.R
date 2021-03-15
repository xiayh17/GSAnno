#' GO UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_GO_ui <- function(id){
  ns <- NS(id)
  tagList(
 	helpText("This step will take several minutes. Please wait..."),
    shinyWidgets::sliderTextInput(
      inputId = ns("pvalue"),
      label = "Choose a pvalue:", 
      choices = seq(from = 0.05,
                    to = 0.01,
                    by = -0.01),
      grid = TRUE
    ),
    shinyWidgets::sliderTextInput(
      inputId = ns("qvalue"),
      label = "Choose a qvalue:", 
      choices = seq(from = 0.05,
                    to = 0.01,
                    by = -0.01),
      grid = TRUE
    ),
    shinycustomloader::withLoader(
      plotOutput(ns("gobar")),
      type = "html",
      loader = "dnaspin"
    )
  )
}
    
#' GO Server Functions
#'
#' @noRd 
mod_GO_server <- function(id,fileUpload=""){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 	geneID <- reactive({
      fileUpload$geneID()
    })
    
    idType <- reactive({
      fileUpload$idType()
    })
    
    ENTREZID <- reactive({
      geneID <- geneID()
      geneID <- geneID[,1]
      idType <- idType()
      df <- clusterProfiler::bitr(unique(geneID), fromType = idType,
                                  toType = c( "ENTREZID" ),
                                  OrgDb = org.Hs.eg.db::org.Hs.eg.db)
      df$ENTREZID
    })
    
    go <- reactive({
      ENTREZID <- ENTREZID()
      clusterProfiler::enrichGO(ENTREZID, OrgDb = "org.Hs.eg.db", ont="all",
               pvalueCutoff = input$pvalue,qvalueCutoff = input$qvalue) 
    })
    
    output$gobar <- renderPlot({
      barplot(go(), split="ONTOLOGY",font.size =10)+
        ggplot2::facet_grid(ONTOLOGY~., scale="free")
    })
  })
}
    
## To be copied in the UI
# mod_GO_ui("GO_ui_1")
    
## To be copied in the server
# mod_GO_server("GO_ui_1")
