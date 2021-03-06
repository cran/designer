TEXT_TAGS <- c(
  "Paragraph <p>" = "p",
  "Ordered List <ol>" = "ol",
  "Unordered List <ul>" = "ul"
)

INPUT_TYPES <- c(
  "Text" = "text",
  "Text Area" = "textArea",
  "Numeric" = "numeric",
  "Password" = "password"
)

SLIDER_TYPES <- c(
  "Numeric" = "number",
  "Date" = "date",
  "Timestamp" = "datetime"
)

RADIO_BUTTON_TYPES <- c(
  "Radio" = "radio",
  "Checkbox" = "checkbox"
)

OUTPUT_TYPES <- c(
  "Text" = "text",
  "Verbatim Text" = "verbatimText",
  "Plot" = "plot",
  "Image" = "image",
  "Table" = "table",
  "HTML" = "html"
)

PLOT_TYPES <- c(
  "random", "point", "bar", "boxplot", "col", "tile", "line",
  "bin2d", "contour", "density", "density_2d", "dotplot", "hex", "freqpoly", "histogram",
  "ribbon", "raster", "tile", "violin"
)

BUTTON_TYPES <- c(
  "default", "primary", "secondary", "success", "danger", "warning", "info", "light", "dark"
)

#' Input Label
#'
#' @description
#' Standard label that is used for inputs, but with the added inclusion of a help tooltip icon
#'
#' @param label String to see in the UI
#' @param ... HTML to include in the tooltip
#'
#' @return HTML of the label
#'
#' @noRd
inputLabel <- function(label, ...) {
  tagList(
    label,
    a(
      class = "help-icon",
      href = "#",
      "data-toggle" = "tooltip",
      "data-html" = "true",
      "?",
      title = paste(...)
    )
  )
}

idInput <- function(id) {
  textInput(
    inputId = id,
    label = inputLabel(
      "Input ID",
      "<p>ID attribute given to the component, used to get the input value on the server side</p>",
      "<p>Leave blank for a randomly generated ID</p>"
    ),
    value = "",
    placeholder = "Optional"
  )
}

labelInput <- function(id) {
  textInput(
    id,
    label = "Label",
    value = "Label"
  )
}

widthInput <- function(id, value = "", placeholder = "Optional") {
  textInput(
    inputId = id,
    label = inputLabel(
      "Width",
      "<p>Either use a specific width (e.g. 400px) or a percentage (e.g. 100%).</p>",
      "<p>If just a number is used, then it will be treated as pixels (px)</p>"
    ),
    value = value,
    placeholder = placeholder
  )
}

heightInput <- function(id, value = "") {
  textInput(
    inputId = id,
    label = inputLabel(
      "Height",
      "<p>Either use a specific width (e.g. 400px) or a percentage (e.g. 100%).</p>",
      "<p>If just a number is used, then it will be treated as pixels (px)</p>"
    ),
    value = value
  )
}

#' Component Settings
#'
#' @noRd
componentSettings <- function(id, settings_func, ns = NS(NULL)) {
  div(
    class = "component-settings",
    `data-component` = id,
    settings_func(ns(id))
  )
}

#' Bootstrap Component Settings
#'
#' @description
#' A way to be able to adjust components so that can more easily visualise how the shiny application will look.
#'
#' @param id The character vector to use for the namespace.
#'
#' @return A \code{shiny.tag.list} of settings specific to the selected component
#'
#' @noRd
columnSettings <- function(id) {
  ns <- NS(id)

  tagList(
    h2("Column Settings"),
    numericInput(
      ns("width"),
      "Width",
      value = 3,
      min = 1,
      max = 12
    ),
    numericInput(
      ns("offset"),
      inputLabel(
        "Offset",
        "The gap between the window/previous column and this column"
      ),
      value = 0,
      min = 0,
      max = 11
    ),

    tags$br(),
    h3("Notes"),
    tags$ul(
      tags$li("Columns can only be included in", tags$b("rows")),
      tags$li(
        "Rows are split into 12 column units, if the sum of columns' width exceeds 12, they get wrapped onto a new line"
      )
    )
  )
}

rowSettings <- function(id) {
  tagList(
    h3("Notes:"),
    tags$ul(
      tags$li("The only component that can be a direct child of a row are columns"),
      tags$li(
        "By default, a row will have no height and is determined by the contents inside.",
        "To easily drop elements into the rows, they have a minimum height of 50px in this app"
      )
    )
  )
}

tabSettings <- function(id) {
  ns <- NS(id)

  tagList(
    h2("Tab Panel Settings"),
    textInput(
      ns("name"),
      label = "Name",
      value = "Tab 1"
    ),
    textInput(
      ns("value"),
      label = inputLabel(
        "Value",
        "Used to reference switching the tab, or changing visibility of the tab on the server"
      ),
      placeholder = "Keep blank to copy name"
    ),
    actionButton(
      ns("add"),
      label = "Add Tab",
      class = "btn-success"
    ),
    actionButton(
      ns("delete"),
      label = "Delete Tab",
      class = "btn-error"
    ),
    div(
      id = ns("alert"),
      class = "tab-alert"
    )
  )
}

headerSettings <- function(id) {
  ns <- NS(id)

  tagList(
    h2("Header Settings"),
    selectInput(
      ns("tag"),
      inputLabel(
        "HTML Tag",
        "The size of the header will reduce as the number increases. Use sequentially for best user experience."
      ),
      c(paste0("h", 1:6), "div")
    ),
    textInput(
      ns("value"),
      "Contents",
      "Header"
    )
  )
}

textSettings <- function(id) {
  ns <- NS(id)

  tagList(
    h2("Text Settings"),
    selectInput(
      ns("type"),
      label = "HTML Tag",
      choices = TEXT_TAGS
    ),
    textAreaInput(
      ns("contents"),
      label = inputLabel(
        "Contents",
        "Add individual list items on separate lines"
      ),
      value = "",
      height = "5rem"
    )
  )
}

inputPanelSettings <- function(id) {
  tagList(
    h3("Notes:"),
    tags$ul(
      tags$li("By default inputs will be aligned vertically, input panels enable the inputs to be aligned horizontally")
    )
  )
}

inputSettings <- function(id) {
  ns <- NS(id)

  tagList(
    h2("Input Settings"),
    selectInput(
      ns("type"),
      label = "Input Type",
      choices = INPUT_TYPES
    ),
    labelInput(ns("label")),
    idInput(ns("id")),
    widthInput(ns("width")),

    tags$br(),
    h3("Notes:"),
    tags$ul(
      tags$li("To position several inputs horizontally, they must be put within an input panel")
    )
  )
}

fileSettings <- function(id) {
  ns <- NS(id)

  tagList(
    h2("File Input Settings"),
    labelInput(ns("label")),
    idInput(ns("id")),
    widthInput(ns("width")),

    tags$br(),
    h3("Notes:"),
    tags$ul(
      tags$li("To position several inputs horizontally, they must be put within an input panel")
    )
  )
}

sliderSettings <- function(id) {
  ns <- NS(id)

  tagList(
    h2("Slider Settings"),
    labelInput(ns("label")),
    idInput(ns("id")),
    selectInput(
      ns("type"),
      label = "Input Type",
      choices = SLIDER_TYPES,
      selected = "number"
    ),
    checkboxInput(
      ns("range"),
      "Ranged Slider"
    ),
    widthInput(ns("width")),

    tags$br(),
    h3("Notes:"),
    tags$ul(
      tags$li("To position several inputs horizontally, they must be put within an input panel")
    )
  )
}

dateSettings <- function(id) {
  ns <- NS(id)

  tagList(
    h2("Date Settings"),
    labelInput(ns("label")),
    idInput(ns("id")),
    checkboxInput(
      ns("range"),
      "Date Range"
    ),
    widthInput(ns("width")),

    tags$br(),
    h3("Notes:"),
    tags$ul(
      tags$li("To position several inputs horizontally, they must be put within an input panel")
    )
  )
}

checkboxSettings <- function(id) {
  ns <- NS(id)

  tagList(
    h2("Checkbox Settings"),
    labelInput(ns("label")),
    idInput(ns("id")),
    checkboxInput(
      ns("checked"),
      label = "Checked"
    ),
    widthInput(ns("width"))
  )
}

radioSettings <- function(id) {
  ns <- NS(id)

  tagList(
    h2("Radio Button Settings"),
    radioButtons(
      ns("type"),
      label = "Button Type",
      choices = RADIO_BUTTON_TYPES,
      selected = "radio",
      inline = TRUE
    ),
    labelInput(ns("label")),
    idInput(ns("id")),
    textAreaInput(
      ns("choices"),
      label = "Choices (One Per Line)",
      value = "Choice 1\nChoice 2",
      height = "5rem"
    ),
    checkboxInput(
      ns("inline"),
      label = "Inline"
    ),
    widthInput(ns("width"))
  )
}

dropdownSettings <- function(id) {
  ns <- NS(id)

  tagList(
    h2("Dropdown Settings"),
    labelInput(ns("label")),
    idInput(ns("id")),
    widthInput(ns("width")),

    tags$br(),
    h3("Notes:"),
    tags$ul(
      tags$li("To position several inputs horizontally, they must be put within an input panel")
    )
  )
}

buttonSettings <- function(id) {
  ns <- NS(id)

  tagList(
    h2("Button Settings"),
    selectInput(
      ns("class"),
      "Button Type",
      setNames(BUTTON_TYPES, tools::toTitleCase(BUTTON_TYPES))
    ),
    labelInput(ns("label")),
    idInput(ns("id")),
    checkboxInput(
      ns("download"),
      "Download Button"
    ),
    widthInput(ns("width"))
  )
}

outputSettings <- function(id) {
  ns <- NS(id)

  tagList(
    h2("Output Settings"),
    selectInput(
      ns("type"),
      "Output Type",
      OUTPUT_TYPES
    ),
    conditionalPanel(
      "input.type === 'plot'",
      ns = ns,
      selectInput(
        ns("plot"),
        "Plot Type",
        PLOT_TYPES
      )
    ),
    conditionalPanel(
      "!['table', 'verbatimText'].includes(input.type)",
      ns = ns,
      checkboxInput(
        ns("inline"),
        "Inline Output"
      )
    ),
    textInput(
      ns("id"),
      "Output ID",
      ""
    ),
    conditionalPanel(
      "['text', 'verbatimText', 'html'].includes(input.type)",
      ns = ns,
      textAreaInput(
        ns("contents"),
        label = "Contents",
        value = "",
        height = "5rem"
      )
    ),
    conditionalPanel(
      "['plot', 'image'].includes(input.type)",
      ns = ns,
      heightInput(
        ns("height"),
        value = "400px"
      ),
      widthInput(
        ns("width"),
        value = "100%",
        placeholder = ""
      )
    ),

    tags$br(),
    h3("Notes"),
    tags$ul(
      tags$li("Plot and image output will show area of plot, but image will not stretch to fit")
    )
  )
}
