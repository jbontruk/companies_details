# Libraries ----
library(RCurl)
library(XML)
library(tidyverse)

# Common parts ----
headerFields =
  c(Accept = "text/xml",
    Accept = "multipart/*",
    'Content-Type' = "text/xml; charset=utf-8",
    SOAPAction = "http://tempuri.org/INewDataStoreProvider/GetMigrationDataExtendedAddressInfo")

body_p1 <- '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:tem="http://tempuri.org/"
  xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
  <soapenv:Body>
  <tem:GetMigrationDataExtendedAddressInfo>
  <tem:AuthToken>'

input_in <- '\n  <arr:string>'
input_out <- '</arr:string>'

token <- 'your_token_hash'

# Body NIP ----
body_p2 <- '</tem:AuthToken>
  <tem:NIP>'

body_p3 <- '</tem:NIP>
  </tem:GetMigrationDataExtendedAddressInfo>
  </soapenv:Body>
  </soapenv:Envelope>'

input_nips <- c('5221234567', '1131234567')

body <- paste0(body_p1, token, body_p2, paste0(input_in, input_nips, input_out, collapse = ''), body_p3)

# Body kod pocztowy ----
body_p2 <- '</tem:AuthToken>
  <tem:Postcode>'

body_p3 <- '</tem:Postcode>
  </tem:GetMigrationDataExtendedAddressInfo>
  </soapenv:Body>
  </soapenv:Envelope>'

input_postals <- c('01-364', '04-005')

body <- paste0(body_p1, token, body_p2, paste0(input_in, input_postals, input_out, collapse = ''), body_p3)

# Body PKD i status dzialalnosci (1 = Aktywny) ----
body_p2 <- '</tem:AuthToken>
  <tem:PKD>'

body_p3 <- '</tem:PKD>
  <tem:status>
  <arr:string>1</arr:string>
  </tem:status>
  </tem:GetMigrationDataExtendedAddressInfo>
  </soapenv:Body>
  </soapenv:Envelope>'

input_pkds <- c('4789Z', '8559B')

body <- paste0(body_p1, token, body_p2, paste0(input_in, input_pkds, input_out, collapse = ''), body_p3)

# Body with Migration date ----
body_p2 <- '</tem:AuthToken>
  <tem:Postcode>'

body_p3 <- '</tem:Postcode>
  <tem:MigrationDateFrom>2015-01-05</tem:MigrationDateFrom>
  <tem:MigrationDateTo>2017-01-05</tem:MigrationDateTo>
  </tem:GetMigrationDataExtendedAddressInfo>
  </soapenv:Body>
  </soapenv:Envelope>'

input_postals <- c('01-364', '04-005')

body <- paste0(body_p1, token, body_p2, paste0(input_in, input_postals, input_out, collapse = ''), body_p3)

# Call ----
h <- basicTextGatherer()
curlPerform(url = "https://datastore.ceidg.gov.pl/CEIDG.DataStore/Services/NewDataStoreProvider.svc",
            httpheader = headerFields,
            postfields = body,
            writefunction = h$update)
y <- xmlToList(h$value())$Body$GetMigrationDataExtendedAddressInfoResponse$GetMigrationDataExtendedAddressInfoResult
substr(y, 1, 2000)
nchar(y)

t <- xmlParse(y)
t