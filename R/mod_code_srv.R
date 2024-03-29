#' @param ui_code Reactive object containing JSON string of the UI in the "App UI" tab
#'
#' @noRd
CodeModuleServer <- function(id, ui_code) {
  moduleServer(id, function(input, output, session) {
    setBookmarkExclude(c("save", "download", "file_type", "file_name", "options"))

    observeEvent(input$file_type, {
      updateTextInput(
        session = session,
        inputId = "file_name",
        label = switch(input$file_type, "ui" = "File Name", "module" = "Module Name"),
        value = switch(input$file_type, "ui" = "ui.R", "module" = "Template"),
      )
    })

    observeEvent(input$save, ignoreInit = TRUE, {
      writeToUI(ui_code(), input$file_type, input$file_name, input$app_type)
    })

    output$download <- downloadHandler(
      filename = function() {
        if (input$file_type == "ui") {
          input$file_name
        } else {
          paste0("mod_", tolower(gsub("\\W", "_", input$file_name)), "_ui.R")
        }
      },
      content = function(file) {
        module_name <- if (input$file_type == "ui") NULL else input$file_name
        r_code <- jsonToRScript(ui_code(), module_name = module_name)
        writeLines(r_code, file)
      }
    )

    r_code <- reactive({
      module_name <- if (input$file_type == "ui") NULL else input$file_name
      jsonToRScript(ui_code(), module_name = module_name, app_type = input$app_type)
    })

    output$code <- renderPrint(cat(r_code()))
  })
}

writeToUI <- function(code, file_type = c("ui", "module"), module_name = NULL,
                      app_type = c("app", "golem", "rhino")) {
  file_type <- match.arg(file_type)
  app_type <- match.arg(app_type)

  r_dir <- switch(app_type, "app" = ".", "golem" = "R", "rhino" = "app/view")
  if (!file.exists(r_dir)) dir.create(r_dir, recursive = TRUE)

  if (file_type == "ui") {
    r_code <- jsonToRScript(code)
    file_name <- file.path(r_dir, module_name)
  } else {
    r_code <- jsonToRScript(code, module_name = module_name)
    file_name <- file.path(r_dir, paste0("mod_", tolower(gsub(" ", "_", module_name)), "_ui.R"))
  }

  sink(file = file_name, append = FALSE)
  cat(r_code)
  sink()
}
