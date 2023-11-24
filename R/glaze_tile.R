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
        x <- read_file_raw(fn) %>% rawToChar()
        x <- gsub("\033\\[[0-9;]*m|\n", " ", x)
        x <- gsub("[[:space:]]+|'", " ", x)
        streamID <- gsub("streamID:  ", "", str_extract(x, "streamID:  [a-z0-9]+"))
        message("streamID: ", streamID)
        streamID
}

# tile:content        show the contents of a Tile stream

#' glaze_tile_content
#'
#' @param STREAMID Character.
#' @param CERAMIC_URL Character.
#' @param k Character.
#' @param returnJSON Logical. Return JSON or not
#'
#' @return tibble
#' @export
#'
#' @examples
glaze_tile_content <- function(STREAMID, CERAMIC_URL = NULL, k = NULL, returnJSON = FALSE){
        contextString <- ifelse(is.null(CERAMIC_URL), "", glue("-c {CERAMIC_URL}"))
        keyString <- ifelse(is.null(key), "", glue("-k={key}"))
        fn <- tempfile()
        system(glue("glaze tile:content {STREAMID} {contextString} {keyString} &> {fn}"))
        x <- read_file_raw(fn) %>% rawToChar()
        x <- gsub("\033\\[[0-9;]*m|\n|_", "", x)
        json_start <- regexpr("\\[\\s*\\{.*\\}\\s*\\]", x)
        json_data <- substr(x, json_start, attr(json_start, "match.length") + json_start - 1)
        json_data_valid <- gsub("([[:alnum:]]+):", "\"\\1\":", json_data)
        json_data_valid <- gsub("\'", "\"", json_data_valid)
        if (returnJSON) return(json_data_valid)
        parsed_json <- jsonlite::fromJSON(json_data_valid)
        tibble(parsed_json) %>% select(matches("row"), everything())
}

# tile:deterministic  load a deterministic Tile stream
# tile:show           show the contents of a Tile stream
# tile:update         Update a stream
