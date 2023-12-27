#' updateCeramicConfig
#' @title updateCeramicConfig
#' @param file Character  Path to daemon.config.json file. Default:  "~/.ceramic/daemon.config.json"
#' @param variable Character . One of variable = c("anchor", "http-api", "ipfs", "logger",
#' "metrics", "network", "node", "state-store", "indexing"). Default "http-api"
#' @param subvariable Character. Name of subvariable to change or NULL. One off:
#'  list(anchor = "auth-method",
#'      http-api = c("cors-allowed-origins", "admin-dids"),
#'      ipfs = "mode", logger = c("log-level", "log-to-files"),
#'      metrics = "metrics-exporter-enabled",
#'      network = "name",
#'      node = "privateSeedUrl",
#'      state-store = c("mode", "local-directory"),
#'      indexing = c("db", "allow-queries-before-historical-sync", "disable-composedb", "enable-historical-sync"))
#' @param value. Character. Value to set variable[[subvariable]] to.
#' @param outpath Character. Filepath to write output to. If NULL file is written to original location (file)
#' @return json
#' @export
#' @examples updateCeramicConfig(variable = "http-api", subvariable = "admin-dids", value = acc)

updateCeramicConfig <- function(file = "~/.ceramic/daemon.config.json",
                                variable = c("anchor", "http-api", "ipfs", "logger",
                                             "metrics", "network", "node", "state-store",
                                             "indexing")[2],
                                subvariable = NULL, # `admin-dids`
                                value = NULL,
                                outpath = NULL){
        if (!file.exists(file)) stop("file: ", file, " does not exist")
        if (is.null(value)) stop("Value cannot be NULL")
        profile <- getCeramicProfile(file = file)
        if (!variable %in% names(profile)) stop("No such name as ", variable, " in profile")
        if (!is.null(subvariable)){
                if (!subvariable %in% names(profile[[variable]])) stop("No such name as ", subvariable, " in ",
                                                                       variable, " item of profile")
                profile[[variable]][[subvariable]] <- value
        } else {
                if (length(profile[[variable]]) != 1 ) stop("No subvariable given and ", variable,  " has multiple items, namely:\n ",
                                                            paste(names(profile[[variable]]), " "), "\nChoose one as subvariable")
                profile[[variable]] <- value
        }
        if (is.null(outpath)) outpath = file

        jsonlite::write_json(profile, path = outpath)
        message("file written")
        jsonlite::toJSON(profile)
}
