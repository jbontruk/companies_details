library(curl)  
library(jsonlite)
library(dplyr)

token = "your_token_hash"

h <- new_handle()
handle_setheaders(h, "Authorization" = token)

requests <- c('wedel', 'wist', 'amica', 'anna')

results <- data.frame(request = integer(),
                      result = character(),
                      stringsAsFactors = F)

for (i in 1:4) {
  request <- requests[i]
  req <- curl_fetch_memory(paste0("https://rejestr.io/api/v1/krs?name=", request), handle = h)
  results[i,1] <- request
  results[i,2] <- prettify(rawToChar(req$content))
}