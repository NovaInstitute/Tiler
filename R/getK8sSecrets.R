#' getK8sSecrets
#'
#' @param namespace Character
#' @param name Character. Default: "ceramic-admin" . Use listK8sSecrets()$NAME to see all
#' @param field Character. Default "data"
#' @param subfield Character. Default "private-key"
#'
#' @return Character
#' @export
#'
#' @examples getK8sSecrets()

getK8sSecrets <- function(namespace = "ceramic",
                          name = "ceramic-admin",
                          field = "data",
                          subfield = "private-key"){

        # namespace check
        if (!namespace %in% listK8sNamespaces()$NAME) {
                stop(namespace, " not in available namespaces.
                     \nUse listK8sNamespaces() to see valid values.
                     \nOptions are: ", paste(listK8sNamespaces()$NAME, " "))
        }
        # name in kubectl get secrets --namespace ceramic
        if (!name %in% listK8sSecrets()$NAME) {
                stop(name, " not available
                     \nUse listK8sSecrets() to see valid values.
                     \nOptions are: ", paste(listK8sSecrets()$NAME, " "))
        }

        pkj <- jsonlite::fromJSON(system(sprintf("kubectl get secrets --namespace %s %s -o json", namespace, name), intern = TRUE)) %>%
                `[[`(field) %>%
                `[[`(subfield)
        pk64 <- base64enc::base64decode(pkj) %>% rawToChar()
        pk64
}
