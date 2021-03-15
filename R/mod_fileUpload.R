#' fileUpload UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_fileUpload_ui <- function(id){
  ns <- NS(id)
  tagList(
 	bs4Dash::bs4Card(
      title = "Gene ID Upload",
      width = NULL,
      maximizable = TRUE,
      boxToolSize = "xs",
      elevation = 3,
      headerBorder = FALSE,
      downloadButton(ns("downloadFiles"),"example file",icon=icon("download")),
      fileInput(ns("idFile"), "Upload your Gene ID ONLY IN txt format", accept = ".txt"),
      helpText("Or you can Input Your Gene ID Directory below"),
      helpText("Please Split Your Gene ID by ; ONLY, e.g. GENE1;GENE2"),
      textInput(ns("idInput"),"Enter Your Gene ID"),
      shinyWidgets::prettyRadioButtons(
        inputId = ns("idType"),
        label = "Choices Gene ID type: ",
        choices = c("SYMBOL" = "SYMBOL", "ENSEMBL" = "ENSEMBL"),
        icon = icon("eye-dropper"),
        bigger = TRUE,
        inline = TRUE,
        fill = TRUE,
        plain = TRUE,
        status = "success",
        animation = "pulse"
      )
    ),
    bs4Dash::bs4Card(
      title = "Glimpse of Data Uploaded",
      width = NULL,
      maximizable = TRUE,
      boxToolSize = "xs",
      elevation = 3,
      headerBorder = FALSE,
      DT::DTOutput(ns("contents"))
    )
  )
}
    
#' fileUpload Server Functions
#'
#' @noRd 
mod_fileUpload_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
 	  geneID <- reactive({
      if (nchar(input$idInput)==0) {
        file <- input$idFile
        ext <- tools::file_ext(file$datapath)
        req(file)
        validate(need(ext == "txt", "Please upload your Gene ID in txt format file"))
        read.table(file$datapath,col.names= "GeneID")
      } else {
        text <- input$idInput
        text %>%
          strsplit(";") %>%
          unlist() %>%
          as.data.frame(col.names = "GeneID")
      }
    })
    
    output$contents <- DT::renderDT({
      DT::datatable(geneID(),
                rownames = FALSE,
                editable = list(target = "cell")
      )
    })
    
    output$downloadFiles <- downloadHandler(
      filename = "genelist.txt",
      content = function(file) {
        file.copy('inst/app/www/genelist.txt',file)
      },
      contentType = "text"
    )
    
    return(
      list(
        geneID = reactive({
          geneID()
        }),
        idType = reactive({
          input$idType
        })))
  })
}
    
## To be copied in the UI
# mod_fileUpload_ui("fileUpload_ui_1")
    
## To be copied in the server
# mod_fileUpload_server("fileUpload_ui_1")
