#' runCeramic
#' @title runCeramic
#' @param network Character. Network name
#' @return Runs Ceramic deamon as side effect
#' @export
#' @examples runCeramic()

runCeramic <- function(network = "testnet-clay"){
        system(sprintf('ceramic daemon --network=%s', network), intern = FALSE, wait = FALSE)
}

#' createStream
#'
#' @param did Character
#' @param baseurl Character. Default: "http://localhost:7007/"
#' @param api_version Character. Default "v0"
#' @param type Numeric. Default: 0
#' @param family Character. !!!  Figure out what this is
#'
#' @return
#' @export
#'
#' @examples
createStream <- function(did,
                         baseurl = "http://localhost:7007/",
                         api_version = "v0",
                         type = 0,
                         family = "test2"){

        URL <- glue::glue("{baseurl}api/{api_version}/streams")

        JSON <- jsonlite::toJSON(list(type = type,
                                      genesis = list(
                                              header = list(
                                                      family = family,
                                                      controllers = c(did)
                                              ))), auto_unbox = TRUE)

        system(glue::glue("curl {URL} -X POST -d {JSON} -H Content-Type: application/json"))
}
