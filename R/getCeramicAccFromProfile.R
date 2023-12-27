#' getCeramicAccFromProfile
#' @title getCeramicAccFromProfile
#' @param file Character. Location of daemon.config.json. Default ~/.ceramic/daemon.config.json
#' @return Character. DID
#' @export
#' @examples acc1 <- getCeramicAccFromProfile()

getCeramicAccFromProfile <- function(file = "~/.ceramic/daemon.config.json"){
        profile <- jsonlite::fromJSON(file)
        profile$`http-api`$`admin-dids`
}
