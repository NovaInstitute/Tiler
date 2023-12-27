#' listK8sNamespaces
#' @return Character
#' @export
#' @import dplyr
#' @import purrr
#' @import tidyr
#' @examples
#' listK8sNamespaces()

listK8sNamespaces <- function(){
        system("kubectl get namespaces", intern = TRUE) %>%
                dplyr::tibble() %>%
                purrr::set_names("een") %>%
                tidyr::separate(col = een, into = c("NAME", "STATUS", "AGE"), sep = "[[:space:]]+") %>%
                dplyr::filter(NAME != "NAME")
}
