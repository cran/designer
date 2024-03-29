test_that("app ui", {
  ui <- appUI()
  golem::expect_shinytaglist(ui)
  # Check that formals have not been removed
  fmls <- formals(appUI)
  for (i in "request") {
    expect_true(i %in% names(fmls))
  }
})

test_that("app server", {
  server <- appServer
  expect_type(server, "closure")
  # Check that formals have not been removed
  fmls <- formals(appServer)
  for (i in c("input", "output", "session")) {
    expect_true(i %in% names(fmls))
  }
})
