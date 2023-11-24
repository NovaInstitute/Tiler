#' listK8sSecrets
#' @return
#' @param namespace Character. to see all use: system("kubectl get namespaces")
#' @export
#'
#' @examples

listK8sSecrets <- function(namespace = "ceramic"){
        system(sprintf("kubectl get secrets --namespace %s", namespace), intern = TRUE) %>%
                tibble() %>%
                purrr::set_names("een") %>%
                tidyr::separate(col = een, into = c("NAME", "STATUS", "DATA", "AGE"), sep = "[[:space:]]+") %>%
                filter(NAME != "NAME")
}
