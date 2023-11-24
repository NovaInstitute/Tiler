

#' setupComposedbK8s
#' Set up connection to kubernetes cluster running composedb.
#' Activates port forwarding
#' @param namespace Character. to see all use: system("kubectl get namespaces")
#' @param localport Character or numeric . local port used by composedb cli
#' @param k8sport Character or numeric . remote port used by composedb
#'
#' @return NULL
#' @export
#'
#' @examples setupComposedbK8s()

setupComposedbK8s <- function(namespace = "ceramic",
                              localport = "7007",
                              k8sport = "7007",
                              secretname = "ceramic-admin",
                              DID = NULL,
                              pk = NULL,
                              URL = NULL){

        if (!namespace %in% listK8sNamespaces()$NAME) {
                stop(namespace, " not in available namespaces.
                     \nUse listK8sNamespaces() to see valid values.
                     \nOptions are: ", paste(listK8sNamespaces()$NAME, " "))
                }
  port_forward <- sprintf("kubectl port-forward --namespace %s composedb-0 %s:%s",
                namespace,
                localport,
                k8sport)

  exportPort <- sprintf("export COMPOSEDB_API_ENDPOINT=http://localhost:%s", localport)

  URL <- getK8sServices()$EXTERNAL_IP
  exportURL <- sprintf('export CERAMIC_URL="http://%s:7007"', URL)

  if (is.null(pk)) pk <- getK8sSecrets(namespace = namespace, name = secretname, field = "data", subfield = "private-key")
  exportDID <- sprintf('export DID_PRIVATE_KEY=$"%s"', pk)

  system(exportPort)
  message("Port fowarded:\n", exportPort)
  system(exportURL)
  message("URL exported:\n", exportURL)
  system(exportDID)
  message("DID exported:\n", exportDID)

  return(invisible(NULL))

}



#' listK8sNamespaces
#' @return
#' @param namespace Character. to see all use: system("kubectl get namespaces")
#' @export
#'
#' @examples

listK8sSecrets <- function(namespace = "ceramic"){
        system(sprintf("kubectl get secrets --namespace %s", namespace), intern = TRUE) %>%
                tibble() %>%
                set_names("een") %>%
                separate(col = een, into = c("NAME", "STATUS", "DATA", "AGE"), sep = "[[:space:]]+") %>%
                filter(NAME != "NAME")
}


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

#' getK8sServices
#'
#' @param namespace Character. K8s namespace. Use listK8sNamespaces()$NAME to see options
#' @param type Character. Service type. Posibly: "NodePort", "LoadBalancer", "ClusterIP"
#'
#' @return tibble with "NAME", "TYPE", "CLUSTER_IP", "EXTERNAL_IP", "PORTS", "AGE"
#' @export
#'
#' @examples
#' getK8sServices()$NAME
#' getK8sServices()$EXTERNAL_IP
#' getK8sServices(type = NULL) # Alles

getK8sServices <-function(namespace = "ceramic", type = c("NodePort", "LoadBalancer", "ClusterIP")[2] ){

        LB <- system(sprintf("kubectl get service --namespace %s", namespace), intern = TRUE) %>%
                tibble() %>%
                set_names("x") %>%
                separate(col = x, into = c( "NAME", "TYPE", "CLUSTER_IP", "EXTERNAL_IP", "PORTS", "AGE"), sep = "[[:space:]]+") %>%
                filter(NAME != "NAME")

        if (!is.null(type)) LB <- LB %>%filter(TYPE == type)
        LB

}

