
#' MakeGenesisCommit
#' @description
#' Create a Genesis commit
#'
#' @param type Character. see MakeStreamtype(). Remember to use as.integer(code, base = 16)
#' @param family Character.
#' @param controllers Character. DID
#' @param returnJSON Logical. Return JSON (default) or R list
#'
#' @return
#' @export
#'
#' @examples
MakeGenesisCommit <- function(type = "0",
                              family = "test",
                              controllers = c("did:key:z6MkfZ6S4NVVTEuts8o5xFzRMR8eC6Y1bngoBQNnXiCvhH8H"),
                              returnJSON = TRUE){

        t1 <- list(type = type)

        h1 <- list(family = family,
                   controllers = c(controllers, controllers))

        g1 <- list(genesis = list(h1))

        l <- c(t1, g1) %>% purrr::flatten()

        if (returnJSON) return(jsonlite::toJSON(l, auto_unbox = TRUE))

        l

}
