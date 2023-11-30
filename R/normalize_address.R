#' Normalize Japanese address
#'
#' @param address Address to normalize.
#' @param level Level of address normalization. One of `"town"`, `"city"`, or
#' `"pref"` (by default, `"town"`).
#'
#' @return A tibble with normalized address.
#'
#' @source [@geolonia/normalize-japanese-addresses](https://github.com/geolonia/normalize-japanese-addresses)
#'
#' @export
normalize_address <- function(address,
                              level = "town") {
  level <- rlang::arg_match(level, c("town", "city", "pref"),
                            multiple = TRUE) |>
    dplyr::case_match("town" ~ 3,
                      "city" ~ 2,
                      "pref" ~ 1)

  data <- vctrs::data_frame(address = vctrs::vec_cast(address, character()),
                            level = vctrs::vec_cast(level, integer()))
  data_unique <- vctrs::vec_unique(data)

  file <- fs::path(system.file("node", package = "jpaddr"), "normalize_address.json")
  jsonlite::write_json(data_unique, file)
  on.exit(fs::file_delete(file))

  processx::run(
    command = "node",
    args = c("normalize_address.js"),
    wd = system.file("node",
                     package = "jpaddr")
  )

  out <- dplyr::as_tibble(jsonlite::fromJSON(file))
  data |>
    dplyr::left_join(dplyr::tibble(data_unique,
                                   out = out),
                     by = c("address", "level")) |>
    dplyr::pull("out") |>
    dplyr::mutate(dplyr::across(c("pref", "city", "town", "addr"),
                                \(x) dplyr::na_if(x, "")),
                  level = dplyr::case_match(.data$level,
                                            1 ~ "pref",
                                            2 ~ "city",
                                            3 ~ "town") |>
                    factor(c("pref", "city", "town")),
                  dplyr::across(c("lat", "lng"),
                                as.double))
}
