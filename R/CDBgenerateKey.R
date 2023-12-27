#' CDBgenerateKey
#' @title CDBgenerateKey
#' @return Character
#' @export
#' @examples key <- CDBgenerateKey()

CDBgenerateKey <- function(){
        system("composedb did:generate-private-key", intern = TRUE)
}
