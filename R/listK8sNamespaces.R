#' listK8sNamespaces
#' @return Character
#' @export
#' @import dplyr
#' @examples
#' @import dplyr
#' @import tidyr
#' listK8sNamespaces()

listK8sNamespaces <- function(){
        system("kubectl get namespaces", intern = TRUE) %>%
                tibble() %>%
                purrr::set_names("een") %>%
                tidyr::separate(col = een, into = c("NAME", "STATUS", "AGE"), sep = "[[:space:]]+") %>%
                filter(NAME != "NAME")
}
