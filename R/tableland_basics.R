
# tableland_config <- "/Users/christiaanpauw/ceramic/.tablelandrc.json"

getTablelandProfile <- function(file = "~/ceramic/.tablelandrc.json"){
        jsonlite::fromJSON(file)
}
