#' \{designer\} application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'
#' @noRd
appUI <- function(request) {
  ui <- tagList(
    addGolemExternalResources(),

    tags$header(
      h1("{designer} - Design your UI"),
      tags$button(
        id = "help",
        class = "btn btn-outline-dark action-button guide-button",
        "Help"
      )
    ),

    fluidPage(
      title = "Shiny UI Designer",
      theme = bslib::bs_theme(version = 4L),
      lang = "en",

      warningModal(
        id = "warning_modal",
        text = "Changing page type will clear all contents of your design. Do you wish to continue?",
        confirm_id = "confirm_reset",
        confirm_text = "Yes",
        cancel_id = "cancel_reset",
        cancel_text = "No"
      ),
      warningModal(
        id = "clear_modal",
        text = "By confirming you will clear all contents of the page. Do you wish to continue?",
        confirm_id = "confirm_clear",
        confirm_text = "Confrim",
        cancel_id = "cancel_clear",
        cancel_text = "Cancel"
      ),

      SettingsModUI("settings"),

      fluidRow(
        column(
          width = 3L,
          class = "d-flex flex-column justify-content-between px-2",
          SidebarModUI("sidebar")
        ),
        column(
          width = 9L,
          class = "px-2",
          CanvasModUI("canvas")
        )
      )
    )
  )

  attr(ui, "lang") <- "en"
  ui
}

#' Add external Resources to the Application
#'
#' @description
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @return
#' A series of tags that are included in \code{<head></head>}
#'
#' @noRd
addGolemExternalResources <- function() {
  golem::add_resource_path("www", appSys("app/www"))
  golem::add_resource_path("images", appSys("app/images"))

  ui_head <- tags$head(
    golem::favicon(),
    golem::bundle_resources(
      path = appSys("app/www"),
      app_title = "Shiny UI Designer",
      name = "designer",
      version = packageVersion("designer")
    ),
    ionRangeSliderDependency(),
    datePickerDependency(),
    dataTableDependency,
    cicerone::use_cicerone(),

    tags$meta(name = "description", content = "Create Wireframes of the UI of shiny applications"),
    tags$meta(name = "keywords", content = "R, shiny, designer, prototype, wireframe"),
    tags$meta(name = "author", content = "Ashley Baldry")
  )

  htmltools::attachDependencies(
    ui_head,
    list(
      htmltools::htmlDependency(
        name = "Sortable",
        version = "1.14.0",
        src = "srcjs/sortable",
        script = "Sortable.min.js",
        package = "designer"
      ),
      htmltools::htmlDependency(
        name = "bs-custom-file-input",
        version = "1.3.4",
        src = "srcjs/bs-custom-file-input",
        script = "bs-custom-file-input.min.js",
        package = "designer"
      )
    )
  )
}

ionRangeSliderDependency <- getFromNamespace("ionRangeSliderDependency", "shiny")
datePickerDependency <- getFromNamespace("datePickerDependency", "shiny")
dataTableDependency <- getFromNamespace("dataTableDependency", "shiny")
