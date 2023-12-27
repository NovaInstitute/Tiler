#' getCeramicStatus
#'
#' @param key Character.
#' @param url Character.
#'
#' @return
#' @export
#'
#' @examples
#' getCeramicStatus()

getCeramicStatus <- function(key, url = "http://localhost:7007/"){
        system(sprintf("curl -H 'Authorization: Bearer %s' %sapi/v0/admin/status",
                       key, url))
}
