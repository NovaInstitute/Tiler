

key <- CDBgenerateKey()
acc <- CDBgenerateAcc(key = key)
save(key, acc, file = "data/inteken.Rda")

makeCeramicMNaccess <- function(DID = NULL){
        if (is.null(DID)) stop("DID cannotbe NULL")
}


verifyEmail <- function(email = NULL,
                        threeboxurl = "https://cas.3boxlabs.com/api/v0/auth/verification",
                        headerstring = 'Content-Type: application/json'){
        if (is.null(email)) stop("email cannot be NULL")
        emailjson = sprintf('{"email": "%s"}', email)
        h <- curl::new_handle()
        handle_setopt(h, customrequest = "POST")
        handle_setopt(h, url = threeboxurl)
        handle_setopt(h, httpheader = c(headerstring))
        handle_setopt(h, postfields = emailjson)

        # Make the request and capture the response
        response <- curl_fetch_memory(url = threeboxurl, handle = h)

        # Print the response body
        cat(rawToChar(response$content))
}

registerDID <- function(email,
                        DID = NULL,
                        configfile = NULL,
                        OTP,
                        threeboxurl = "https://cas.3boxlabs.com/api/v0/auth/did",
                        headerstring = 'Content-Type: application/json'){
        if (is.null(email)) stop("email cannot be null")
        if (is.null(OTP))   stop("OTP cannot be null")

        if (is.null(DID) & !is.null(configfile)){
                if (!file.exists(configfile)) stop("No such file as ", configfile , " exists")
                DID = readr::read_lines(configfile)
        }

        payload = sprintf('{
    "email": "%s",
      "otp": "%s",
      "dids": [
          "%s"
      ]
  }', email, OTP, DID)

        h <- curl::new_handle()
        handle_setopt(h, customrequest = "POST")
        handle_setopt(h, url = threeboxurl)
        handle_setopt(h, httpheader = c(headerstring))
        handle_setopt(h, postfields = payload)
        response <- curl_fetch_memory(url = threeboxurl, handle = h)
        cat(rawToChar(response$content))
}
