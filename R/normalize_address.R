#' Normalize Japanese address
#'
#' @param address Address to normalize.
#' @param level Level of address normalization. One of `"town"`, `"city"`, or
#' `"pref"` (by default, `"town"`).
#' @param pause Pause time between requests in seconds (by default, `0.1`).
#' @param timeout Timeout for each request in seconds (by default, `10`).
#' @param progress Whether to show progress bar (by default, `FALSE`).
#'
#' @return A tibble with normalized address.
#'
#' @source [@geolonia/normalize-japanese-addresses](https://github.com/geolonia/normalize-japanese-addresses)
#'
#' @export
normalize_address <- function(address,
                              level = "town",
                              pause = 0.1,
                              timeout = 10,
                              progress = FALSE) {
  if (pause < 0.1) {
    rlang::warn("`pause` is too short. Set to 0.1 seconds.")
    pause <- 0.1
  }

  level <- rlang::arg_match(level, c("town", "city", "pref"),
                            multiple = TRUE) |>
    dplyr::case_match("town" ~ 3,
                      "city" ~ 2,
                      "pref" ~ 1)

  data <- tibble::tibble(address = vctrs::vec_cast(address, character()),
                         level = vctrs::vec_cast(level, integer()))

  file <- fs::path(system.file("node", package = "jpaddr"), "normalize_address.json")
  on.exit(if(fs::file_exists(file)) fs::file_delete(file))

  data_unique <- vctrs::vec_unique(data) |>
    dplyr::mutate(data = purrr::map2(
      address, level,
      purrr::slowly(purrr::possibly(\(address, level) {
        processx::run(command = "node",
                      args = c("normalize_address.js", address, level, timeout),
                      wd = system.file("node",
                                       package = "jpaddr"))

        out <- jsonlite::read_json(file)
        out$lat <- out$lat %||% NA_real_
        out$lng <- out$lng %||% NA_real_
        out$error <- FALSE
        out
      },
      otherwise = tibble::tibble(pref = NA_character_,
                                 city = NA_character_,
                                 town = NA_character_,
                                 addr = NA_character_,
                                 level = NA_integer_,
                                 lat = NA_real_,
                                 lng = NA_real_,
                                 error = TRUE)),
      rate = purrr::rate_delay(pause)),
      .progress = progress
    ) |>
      dplyr::bind_rows())

  data |>
    dplyr::left_join(data_unique,
                     by = c("address", "level")) |>
    dplyr::pull("data") |>
    dplyr::mutate(dplyr::across(c("pref", "city", "town", "addr"),
                                \(x) dplyr::na_if(x, "")),
                  level = dplyr::case_match(.data$level,
                                            1 ~ "pref",
                                            2 ~ "city",
                                            3 ~ "town") |>
                    factor(c("pref", "city", "town")))
}
