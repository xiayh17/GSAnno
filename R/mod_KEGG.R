#' KEGG UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_KEGG_ui <- function(id){
  ns <- NS(id)
  tagList(
    shinyWidgets::prettyRadioButtons(
      inputId = ns("species"),
      label = "Choices Species",
      choices = c("Human" = "hsa", "Mouse" = "mmu"),
      icon = icon("eye-dropper"),
      bigger = TRUE,
      inline = TRUE,
      fill = TRUE,
      plain = TRUE,
      status = "success",
      animation = "pulse"
    ),
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
      plotOutput(ns("keggdot")),
      type = "html",
      loader = "dnaspin"
    ),
    shinycustomloader::withLoader(
      plotOutput(ns("keggnet")),
      type = "html",
      loader = "dnaspin"
    )
  )
}
    
#' KEGG Server Functions
#'
#' @noRd 
mod_KEGG_server <- function(id,fileUpload=""){
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
    
    kk <- reactive({
      # library(createKEGGdb)
      # species <-c("mmu","hsa")
      # create_kegg_db(species)
      #library(KEGG.db)
      ENTREZID <- ENTREZID()
      enrichKK <- clusterProfiler::enrichKEGG(gene         =  ENTREZID,
                 organism     = 'hsa',
                 #universe     = gene_all,
                 pvalueCutoff = input$pvalue,
                 qvalueCutoff =input$qvalue,
                 use_internal_data = T)
      DOSE::setReadable(enrichKK, OrgDb='org.Hs.eg.db',keyType='ENTREZID')
    })
    
    output$keggdot <- renderPlot(
      clusterProfiler::dotplot(kk())
    )
    
    output$keggnet <- renderPlot(
      clusterProfiler::cnetplot(kk(), categorySize="pvalue", colorEdge = TRUE)
    )
  })
}
    
## To be copied in the UI
# mod_KEGG_ui("KEGG_ui_1")
    
## To be copied in the server
# mod_KEGG_server("KEGG_ui_1")
