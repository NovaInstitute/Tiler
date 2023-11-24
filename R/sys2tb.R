
#' sys2tb
#' @description
#' System output to tibble
#'
#' @param x
#'
#' @return
#' @export
#'
#' @examples

sys2tb <- function(x){
        suppressWarnings(
                as.data.frame(x) %>%
                        purrr::set_names("value") %>%
                        splitstackshape::cSplit( sep = "[[:space:]]{2,200}", splitCols = "value", fixed = FALSE, direction = "wide") %>%
                        dplyr::as_tibble() %>%
                        purrr::set_names(gsub(" ", "_", .[1,])) %>%
                        `[`(-1,)
        )
}
