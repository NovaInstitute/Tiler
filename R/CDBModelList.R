#' CDBModelList
#' @title CDBModelList
#' @description
#'  !!! does thos work correctly with a remote server??
#'
#' @param remoteURL Character or NULL
#' @param tab Logical
#' @return Charachter
#' @export
#' @examples CDBModelList()

CDBModelList <- function(tab = TRUE,
                         remoteURL = "http://46.101.111.94/",
                         port = "7007"){
        if (is.numeric(port)) port = as.character(port)

        s <- sprintf("composedb model:list %s", ifelse(tab, "--table", ""))

        if (is.null(remoteURL)) system(s ,intern = TRUE)
        else curl::curl(url = remoteURL)
}
