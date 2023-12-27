#' CDBcompositeFromModelId
#' @title compositeFromModelId
#' @param modelID Character.
#' @param ceramic_url Character. Ceramic URL
#' @param did_private_key Character. Private key that will control composite ??
#' @param output name of output file. Default "composite.json"
#' @return Side effect
#' @export
#' @examples compositeFromModelId(modelID = "kjzl6hvfrbw6c5yi3kx386312dpll69hi87xjlhm2t7m6cn7p1y4ojld1e9srgp", did_private_key= acc)

CDBcompositeFromModelId <- function(modelID = NULL,
                                 ceramic_url = "http://localhost:7007",
                                 did_private_key = NULL,
                                 output = "composite.json"){
        if (is.null(modelID)) stop("modelID cannot be NULL")
        string <- sprintf("composedb composite:from-model %s --ceramic-url=%s %s%s, output=%s",
                          modelID,
                          ceramic_url,
                          ifelse(is.null(did_private_key), "", "--did-private-key="),
                          ifelse(is.null(did_private_key), "", did_private_key),
                          output)
        message(string)
        system(string, intern = TRUE)
}
