#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic 
    bs4Dash::dashboardPage(
      title = "DSAnno",
      fullscreen = TRUE,
      dark = FALSE,
      header = bs4Dash::dashboardHeader(),
      sidebar = bs4Dash::dashboardSidebar(disable = TRUE),
      #controlbar = bs4Dash::dashboardControlbar(),
      footer = bs4Dash::dashboardFooter(),
      body = bs4Dash::dashboardBody(
        bs4Dash::tabsetPanel(
          id = NULL,
          tabPanel(
            "File upload",
            icon = icon("cloud-upload-alt"),
            mod_fileUpload_ui("fileUpload_ui_1")
          ),
          tabPanel(
            "Gene Info",
            icon = icon("dna"),
            mod_geneInfo_ui("geneInfo_ui_1")
          ),
          tabPanel(
            "KEGG",
            icon = icon("project-diagram"),
            mod_KEGG_ui("KEGG_ui_1")
          ),
          tabPanel(
            "GO",
            icon = icon("chart-bar"),
            mod_GO_ui("GO_ui_1")
          )
        )
      )
    )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'GSAnno'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

