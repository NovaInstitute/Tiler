
#' getCeramicStream
#'
#' @param URL Ceramic URL . Default CERAMIC_URL http://146.190.193.80:7007
#' @param SID StreamID like "kjzl6cwe1jw146ct4uzdlismretwt0o5alh3brpelfc49klnq3xwd610r61mrox"
#' @param contentAsTibble Logical. If TRUE return content - seems to be equivalent to glaze_tile_content()
#'
#' @return
#' @export
#'
#' @examples
#' getCeramicStream(URL = "http://146.190.6.248:7007", SID = "kjzl6cwe1jw14blkfyymlen4d48ljm1dxl9tijy975b6n8v62m1uwbiy1lz00vn", contentAsTibble = TRUE)

getCeramicStream <- function(URL = CERAMIC_URL,
                             SID = mtcarSID,
                             contentAsTibble = FALSE){
        res <- httr::GET(glue("{URL}/api/v0/streams/:{SID}"))
        resc <- httr::content(res)
        if (contentAsTibble) return(
                map_df(map(resc$state$content, ~t(.) %>% as.data.frame()), ~.) %>%
                        purrr::set_names(gsub("_", "", names(.))) %>%
                        select(matches("row"), everything())
                )
        resc$state


}

