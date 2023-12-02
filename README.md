
<!-- README.md is generated from README.Rmd. Please edit that file -->

# jpaddr

<!-- badges: start -->
<!-- badges: end -->

jpaddr is a R package for Japanese address normalization.

## Credits

This package is based on the following projects:

### [geolonia/normalize-japanese-addresses](https://github.com/geolonia/normalize-japanese-addresses)

- Author: [Geolonia](https://www.geolonia.com)
- License: MIT License

### [geolonia/japanese-addresses](https://github.com/geolonia/japanese-addresses)

- Author: [Geolonia](https://www.geolonia.com)
- License: [CC BY
  4.0](https://creativecommons.org/licenses/by/4.0/deed.ja)

## Installation

You can install the development version of jpaddr from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("UchidaMizuki/jpaddr")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(jpaddr)
```

You need to install the dependent packages first.

``` r
jpaddr_install()
```

``` r
normalize_address(c("東京都千代田区千代田1-1", "大阪府大阪市北区梅田2-2-2"))
#> # A tibble: 2 × 7
#>   pref   city       town       addr  level   lat   lng
#>   <chr>  <chr>      <chr>      <chr> <fct> <dbl> <dbl>
#> 1 東京都 千代田区   千代田     1-1   town   35.7  140.
#> 2 大阪府 大阪市北区 梅田二丁目 2-2   town   34.7  135.
```
