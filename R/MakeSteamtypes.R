
#' MakeStreamtype
#' @description
#' Convenience function to creat table of streamtypes
#' @references https://github.com/ceramicnetwork/CIPs/tree/main/tables
#' @return
#' @export
#'
#' @examples
#' dfTypes <- makeStreamtype()
makeStreamtype <- function() {tibble::tribble(
        ~name,                   ~code,    ~description,                                                     ~specification,
        "Tile",                   "0x00",      "A stream type representing a json document",                     "https://cips.ceramic.network/CIPs/cip-8",
        "CAIP-10 Link",           "0x01",      "Link blockchain accounts to DIDs",                                "https://cips.ceramic.network/CIPs/cip-7",
        "Model",                  "0x02",      "Defines a schema shared by group of documents in ComposeDB",      "https://github.com/ceramicnetwork/js-ceramic/tree/main/packages/stream-model",
        "Model Instance Document","0x03",      "Represents a json document in ComposeDB",                         "https://github.com/ceramicnetwork/js-ceramic/tree/main/packages/stream-model-instance",
        "UNLOADABLE",             "0x04",      "A stream that is not meant to be loaded",                         "https://github.com/ceramicnetwork/js-ceramic/blob/main/packages/stream-model/src/model.ts",
        "EventId",                "0x05",      "An event id encoded as a cip-124 EventID",                        "https://cips.ceramic.network/CIPs/cip-124"
)}


#' makeNetworkIds
#' @description
#' make a tibble with Network IDs
#' @references https://github.com/ceramicnetwork/CIPs/tree/main/tables
#' @return
#' @export
#'
#' @examples
#' dfIDs <- makeNetworkIds()

makeNetworkIds <- function(){
        tibble::tribble(
                ~name,                    ~code,
                "mainnet",                 "0x00",
                "testnet-clay",            "0x01",
                "dev-unstable",            "0x02",
                "inmemory",                "0xFF",
                "local",                   "0x01_0000_0000 - 0x01_FFFF_FFFF"
        )
}
