
#' glaze_tile_content
#' @description
#' tile:content        show the contents of a Tile stream
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
#' glaze_tile_content(STREAMID = "kjzl6cwe1jw14blkfyymlen4d48ljm1dxl9tijy975b6n8v62m1uwbiy1lz00vn", CERAMIC_URL = "http://146.190.6.248:7007", k = DID_PRIVATE_KEY, returnJSON = FALSE)

glaze_tile_content <- function(STREAMID, CERAMIC_URL = NULL, k = NULL, returnJSON = FALSE){
        contextString <- ifelse(is.null(CERAMIC_URL), "", glue("-c {CERAMIC_URL}"))
        keyString <- ifelse(is.null(key), "", glue("-k={key}"))
        fn <- tempfile()
        system(glue("glaze tile:content {STREAMID} {contextString} {keyString} &> {fn}"))
        x <- readr::read_file_raw(fn) %>% rawToChar()
        x <- gsub("\033\\[[0-9;]*m|\n|_", "", x)
        json_start <- regexpr("\\[\\s*\\{.*\\}\\s*\\]", x)
        json_data <- substr(x, json_start, attr(json_start, "match.length") + json_start - 1)
        json_data_valid <- gsub("([[:alnum:]]+):", "\"\\1\":", json_data)
        json_data_valid <- gsub("\'", "\"", json_data_valid)
        if (returnJSON) return(json_data_valid)
        parsed_json <- jsonlite::fromJSON(json_data_valid)
        tibble(parsed_json) %>% select(matches("row"), everything())
}
