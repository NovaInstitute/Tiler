#' CDBModelCreate
#' @title CDBModelCreate
#' @param content !!!!!!!! Figure uit hoe die model gemaak word - vanuit GraphQL ????
#' @param ceramic_url Character. Ceramic URL
#' @param did_private_key Character. Private key that will control model ??
#' @references  https://composedb.js.org/docs/0.3.x/api/commands/cli.model
#' @description Most of the time you shouldn't be using this command directly.
#' Instead, you should first check if a model you need already exists, using Composites Discovery
#' and only if you can't find a model that you need, you should create one indirectly by
#' creating a Composite from a GraphQL Composite Schema.
#' @return NULL
#' @export
#'
#' @examples

CDBModelCreate <- function(content = NULL,
                           ceramic_url = "http://localhost:7007" ,
                           did_private_key = NULL){
        # composedb model:create CONTENT [-c <value>] [-k <value>]
        if (any(is.null(content), is.null(ceramic_url), is.null(did_private_key))) stop("content, ceramic_url or did_private_key cannot be NULL")
        system( sprintf("composedb model:create %s --ceramic_url=%s --did_private_key=%s",
                        content,
                        ceramic_url,
                        did_private_key),
                intern = TRUE)
}
