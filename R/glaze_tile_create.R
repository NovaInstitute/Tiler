# tile --------------------------------------------------------------------
# COMMANDS
# tile:create         create a new Tile stream

#' glaze_tile_create
#'
#' @param URL Character. Ceramic URL
#' @param k Character. Key
#' @param content Character. JSON with data
#'
#' @return
#' @export
#'
#' @examples
#' k <- "451c064691fe121292d2eaa05f552de8aeb2e4136c03c546c209f89e96263510"
#' een <- jsonlite::fromJSON("Data/Een.json")
#' twee <- '{"Foo":"Bar"}'
#' tweeSID <- glaze_tile_create(k = k, content = twee)
#' mtcarSID <- glaze_tile_create(k = k, content = jsonlite::toJSON(mtcars[1:2,]))

glaze_tile_create <- function(CERAMIC_URL = NULL, k = NULL, content = NULL){
        contextString <- ifelse(is.null(CERAMIC_URL), "", glue("-c {CERAMIC_URL}"))
        keyString <- ifelse(is.null(key), "", glue("-k={key}"))
        if (is.null(content)) content = '{"ID":"0"}'
        fn <- tempfile()
        s <- glue::glue("glaze tile:create {contextString} {keyString} --content '{content}' &> {fn} ")
        system(s, intern = TRUE)
        x <- readr::read_file_raw(fn) %>% rawToChar()
        x <- gsub("\033\\[[0-9;]*m|\n", " ", x)
        x <- gsub("[[:space:]]+|'", " ", x)
        streamID <- gsub("streamID:  ", "", stringr::str_extract(x, "streamID:  [a-z0-9]+"))
        message("streamID: ", streamID)
        streamID
}
