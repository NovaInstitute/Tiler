#' setupComposedbK8s
#' Set up connection to kubernetes cluster running composedb.
#' Activates port forwarding
#' @param namespace Character. to see all use: Tiler::listK8sNamespaces() or system("kubectl get namespaces")
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
