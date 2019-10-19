library(shiny)
library(pivottabler)
library(pivotable)
library(rlang)

ui <- fluidPage(
  sidebarPanel(
    textInput("table", "Table Name", value = "retail_orders_details"),
    selectInput("columns", "Columns", choices = "", selected = "{none}", multiple = TRUE, size = 10, selectize = FALSE),
    selectInput("rows", "Rows", choices = "", selected = "{none}", multiple = TRUE, size = 10, selectize = FALSE)
  ),
  mainPanel(
    pivottablerOutput("pvt"),
    textOutput("code")
  )
)

server <- function(input, output, session) {

  data_source <- function() retail_orders_details



  output$pvt <- renderPivottabler({
    if(input$rows != "{none}" | input$columns != "{none}") {
      ds <- data_source()
      if(input$rows != "{none}" ) ds <- pivot_rows(ds, !!! syms(input$rows))
      if(input$columns != "{none}") ds <- pivot_columns(ds, !!! syms(input$columns))
      ds <- ds %>%
        pivot_values(sum(sales)) %>%
        pivot_flip() %>%
        to_pivottabler() %>%
        pivottabler()

      ds
    } else {
      NULL
    }
  })

  output$code <- renderText({
   c("test", "test2")
  })

  data_cols <- function() c("{none}", colnames(data_source()))

  updateSelectInput(session, "columns", selected = "{none}", choices = data_cols())
  updateSelectInput(session, "rows", selected = "{none}", choices = data_cols())
}

shinyApp(ui, server)
