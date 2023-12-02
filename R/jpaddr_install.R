#' Install packages
#'
#' @source [geolonia/normalize-japanese-addresses](https://github.com/geolonia/normalize-japanese-addresses)
#' @source [geolonia/japanese-addresses](https://github.com/geolonia/japanese-addresses)
#'
#' @export
jpaddr_install <- function() {
  # Install normalize-japanese-addresses
  processx::run(command = if (Sys.info()[["sysname"]] == "Windows") "npm.cmd" else "npm",
                args = c("install", "@geolonia/normalize-japanese-addresses"),
                wd = system.file("normalize-japanese-addresses", package = "jpaddr"),
                echo_cmd = TRUE,
                echo = TRUE)

  # Clone japanese-addresses
  exdir <- fs::path(system.file("normalize-japanese-addresses", package = "jpaddr"), "japanese-addresses")
  if (fs::dir_exists(exdir)) {
    git2r::pull(exdir)
  } else {
    git2r::clone(url = "https://github.com/geolonia/japanese-addresses",
                 local_path = exdir,
                 progress = TRUE)
  }
  invisible()
}
