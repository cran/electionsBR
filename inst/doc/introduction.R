## ---- eval=FALSE--------------------------------------------------------------
#  install.packages("electionsBR")

## ---- eval=FALSE--------------------------------------------------------------
#  if (!require("devtools")) install.packages("devtools")
#  devtools::install_github("silvadenisson/electionsBR")

## ---- eval=FALSE--------------------------------------------------------------
#  install.packages("electionsBR")
#  electionsBR::elections_tse(year = 2010, type = "candidate", export = TRUE)

## ---- eval=FALSE--------------------------------------------------------------
#  # Download electoral results for 2014 federal elections
#  df <- elections_tse(year = 2014, type = "vote_mun_zone")

## ---- eval=FALSE--------------------------------------------------------------
#  df <- elections_cepesp(year = 2018, type = "candidate", position = "President")

## ---- eval=FALSE--------------------------------------------------------------
#  uf_br()

## ---- eval=FALSE--------------------------------------------------------------
#  parties_br(year)

## ---- eval=FALSE--------------------------------------------------------------
#  # Download electoral results for 2014 federal elections
#  df <- elections_tse(year = 2014, type = "vote_mun_zone", br_archive = TRUE)

## ---- eval=FALSE--------------------------------------------------------------
#  # Download candidates' social media information for 2022 elections
#  df <- elections_tse(year = 2014, type = "social_media", readme_pdf = TRUE)

## ---- eval=FALSE--------------------------------------------------------------
#  df <- elections_tse(2010, export = TRUE)

## ---- eval=FALSE--------------------------------------------------------------
#  df <- elections_tse(2010, ascii = TRUE)

## ---- eval=FALSE--------------------------------------------------------------
#  df <- elections_tse(2010, ascii = TRUE, encoding = "Latin-1")

## ---- eval=FALSE--------------------------------------------------------------
#  # Electoral results for the 2010 federal elections in Sao Paulo (SP)
#  df <- elections_tse(2010, uf = "SP")
#  http://www.tse.jus.br/eleicoes/estatisticas/repositorio-de-dados-eleitorais
#  # Electoral results for the 2010 federal elections in Minas Gerais (MS)
#  df <- elections_tse(2010, uf = "mg")
#  
#  # Electoral results for the 2010 federal elections in RS, SC, and PR
#  df <- elections_tse(2010, uf = c("RS", "SC", "PR"))

## -----------------------------------------------------------------------------
citation("electionsBR")

