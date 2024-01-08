#' setupComposedbK8s
#' Set up connection to kubernetes cluster running composedb.
#' Activates port forwarding
#'
#' @param namespace Character. to see all use: Tiler::listK8sNamespaces() or system("kubectl get namespaces")
#' @param localport Character or numeric . local port used by composedb cli
#' @param k8sport Character or numeric . remote port used by composedb
#' @param secretname Character. Default "ceramic-admin"
#' @param DID Character
#' @param pk Character
#' @param URL Character
#' @param returnlist Logical. If FALSE (default), returns the CERAMIC_URL. If TRUE returns a list with DID_PRIVATE_KEY and CERAMIC_URL
#' @import dplyr
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
                              URL = NULL,
                              returnlist = FALSE){

        if (!namespace %in% listK8sNamespaces()$NAME) {
                stop(namespace, " not in available namespaces.
                     \nUse listK8sNamespaces() to see valid values.
                     \nOptions are: ", paste(listK8sNamespaces()$NAME, " "))
        }
        port_forward <- sprintf("kubectl port-forward --namespace %s composedb-0 %s:%s",
                                namespace,
                                localport,
                                k8sport)

        system(port_forward)

        exportPort <- sprintf("http://localhost:%s", localport)
        URL <- getK8sServices()$EXTERNAL_IP
        if (is.null(pk)) pk <- getK8sSecrets(namespace = namespace, name = secretname, field = "data", subfield = "private-key")

        Sys.setenv(
                COMPOSEDB_API_ENDPOINT = exportPort,
                DID_PRIVATE_KEY = pk,
                CERAMIC_URL = URL
        )

        set_bash_env_variable_list(l = list(COMPOSEDB_API_ENDPOINT = exportPort,
                                            DID_PRIVATE_KEY = pk,
                                            CERAMIC_URL = URL))

        if (returnlist)  return(list(DID_PRIVATE_KEY = pk, CERAMIC_URL = URL))
        URL

}

set_bash_env_variable_list <- function(l = list(COMPOSEDB_API_ENDPOINT=url,
                                                DID_PRIVATE_KEY =key) ) {
        map2(names(l), l, ~set_bash_env_variable(name =  ..1, var = ..2))
}

set_bash_env_variable <- function(name = "COMPOSEDB_API_ENDPOINT", var = url){
        fn <- tempfile(fileext = ".sh")
        insides <- sprintf("export %s=%s" , name, var)
        script <- sprintf("echo '%s' >> ~/.bashrc", insides)
        cat(script, file = fn)
        system(glue::glue("chmod +x {fn}"))   # Ensure the script is executable
        system(fn)        # Execute the script to set the environment variable
        system("source ~/.bashrc")
        unlink(fn)
}


