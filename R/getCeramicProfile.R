#' @title getCeramicProfile
#' @param file Character. Location of daemon.config.json. Default ~/.ceramic/daemon.config.json
#' @return list
#' @export
#' @examples profile <- getCeramicProfile(file = "~/.ceramic/daemon.config.json")

getCeramicProfile <- function(file = "~/.ceramic/daemon.config.json"){
        jsonlite::fromJSON(file)
}
