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
                purrr::set_names("x") %>%
                tidyr::separate(col = x, into = c( "NAME", "TYPE", "CLUSTER_IP", "EXTERNAL_IP", "PORTS", "AGE"), sep = "[[:space:]]+") %>%
                filter(NAME != "NAME")

        if (!is.null(type)) LB <- LB %>%filter(TYPE == type)
        LB

}

