#' Install npm package
#'
#' @source [@geolonia/normalize-japanese-addresses](https://github.com/geolonia/normalize-japanese-addresses)
#'
#' @export
jpaddr_npm_install <- function() {
  processx::run(command = if (Sys.info()[["sysname"]] == "Windows") "npm.cmd" else "npm",
                args = c("install", "@geolonia/normalize-japanese-addresses"),
                wd = system.file("node", package = "jpaddr"))
  invisible()
}
