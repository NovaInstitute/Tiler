

# tile:deterministic  load a deterministic Tile stream
# tile:show           show the contents of a Tile stream
# tile:update         Update a stream

#' glaze_tile_update
#'
#' @param STREAMID Character.
#' @param CERAMIC_URL Character.
#' @param k Character.
#' @param m Character.
#' @param content Character. JSON of some kind
#'
#' @return Character. streamID
#' @export
#'
#' @examples
#' glaze_tile_update(STREAMID = mtcarSID, CERAMIC_URL = REMOTE_URL, k = DID_PRIVATE_KEY, content = jsonlite::toJSON(mtcars[3:4,]))


glaze_tile_update <- function(STREAMID, CERAMIC_URL = NULL, k = NULL, m = NULL, content = NULL){
        if (is.null(STREAMID)) stop("STREAMID cannot be NULL")
        contextString <- ifelse(is.null(CERAMIC_URL), "", glue("-c {CERAMIC_URL}"))
        keyString <- ifelse(is.null(key), "", glue("-k={key}"))
        metaString <- ifelse(is.null(m), "", glue("-m={m}"))
        if (is.null(content)) content = '{"ID":"0"}'
        fn <- tempfile()
        s <- glue::glue("glaze tile:update {STREAMID} {contextString} {keyString} {metaString} --content '{content}' &> {fn} ")
        system(s, intern = TRUE)
        x <- readr::read_file_raw(fn) %>% rawToChar()
        x <- gsub("\033\\[[0-9;]*m|\n", " ", x)
        x <- gsub("[[:space:]]+|'", " ", x)
        streamID <- gsub("streamID:  ", "", stringr::str_extract(x, "streamID:  [a-z0-9]+"))
        message("streamID: ", streamID)
        streamID
}
