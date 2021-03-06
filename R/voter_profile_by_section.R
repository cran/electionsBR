#' Download data on the voters' profile by vote section
#'
#' \code{voter_profile_by_section()} downloads and cleans data on the voters' profile aggregated by voting section (i.e., voting stations).
#' The function returns a \code{data.frame} where each observation corresponds to a voter profile type.
#'
#' @param year Election year (\code{integer}). For this function, the following years are available: 1994, 1996, 1998,
#' 2000, 2002, 2004, 2006, 2008, 2010, 2012, 2014, 2016, 2018 and 2020.
#' 
#' @param ascii (\code{logical}). Should the text be transformed from Latin-1 to ASCII format?
#'
#' @param encoding Data original encoding (defaults to 'windows-1252'). This can be changed to avoid errors
#' when \code{ascii = TRUE}.
#' 
#' @param export (\code{logical}). Should the downloaded data be saved in .dta and .sav in the current directory?
#' 
#' @param temp (\code{logical}). If \code{TRUE}, keep the temporary compressed file for future use (recommended)
#'
#' @details If export is set to \code{TRUE}, the downloaded data is saved as .dta and .sav
#'  files in the current directory.
#'
#' @return \code{voter_profile()} returns a \code{data.frame} with the following variables:
#'
#' \itemize{
#'   \item  DT_GERACAO The date when the file was created.
#'   \item  HH_GERACAO The time when the file was created, Brasilia Timezone (GMT-3).
#'   \item  AA_ELEICAO Election year.    
#'   \item  DT_ELEICAO Election date.          
#'   \item  DS_ELEICAO Election description (i.e., indicates electoral round or supplementary elections).
#'   \item  SG_UF Brazilian state acronym.             
#'   \item  CD_MUNICIPIO Brazilian municipality identification code (created by the TSE).      
#'   \item  NM_MUNICIPIO Brazilian municipality name.         
#'   \item  NR_ZONA Electoral zone number.       
#'   \item  NR_SECAO Voting section number.            
#'   \item  CD_TIPO_SECAO_AGREGADA Voting section type code.
#'   \item  DS_TIPO_SECAO_AGREGADA Voting section type (i.e., main section or aggregated).
#'   \item  NR_LOCAL_VOTACAO Voting station number.
#'   \item  NM_LOCAL_VOTACAO Voting station name.   
#'   \item  CD_TIPO_LOCAL Type of voting station code.   
#'   \item  DS_TIPO_LOCAL Type of voting station.       
#'   \item  DS_ENDERECO Address of voting station.   
#'   \item  NM_BAIRRO Voting station neighborhood name.       
#'   \item  NR_CEP Voting station zip code.             
#'   \item  NR_TELEFONE_LOCAL Voting station local phone number.  
#'   \item  NR_LATITUDE Voting station latitude (might be missing).
#'   \item  NR_LONGITUDE Voting station longitude (might be missing).        
#'   \item  CD_SITU_LOCAL_VOTACAO Voting station situation code.
#'   \item  DS_SITU_LOCAL_VOTACAO Voting station situation.
#'   \item  CD_SITU_ZONA Electoral zone situation code.     
#'   \item  DS_SITU_ZONA Electoral zone situation.       
#'   \item  CD_SITU_SECAO Voting section situation code. 
#'   \item  DS_SITU_SECAO Voting section situation.     
#'   \item  CD_SITU_LOCALIDADE Locality situation code.
#'   \item  DS_SITU_LOCALIDADE Locality situation.   
#'   \item  QT_ELEITOR Total number of registered voters.
#'   \item  QT_ELEITOR_ELEICAO Total number of registered voters in the given electoral.   
#'   
#' }
#'
#' @import utils
#' @importFrom magrittr "%>%"
#' @export
#' @examples
#' \dontrun{
#' df <- voter_profile_by_section(2016)
#' }

voter_profile_by_section <- function(year, ascii = FALSE, 
                                     encoding = "windows-1252",
                                     export = FALSE,
                                     temp = TRUE){
  
  
  # Inputs
  if(!year %in% seq(2016, 2020, by = 2)) stop("Invalid 'year'. Please check the documentation and try again.")
  test_encoding(encoding)
  
  #if(year == 2020){
  #  urldir <- "http://agencia.tse.jus.br/estatistica/sead/odsele/perfil_eleitorado/perfil_eleitorado_ATUAL.zip"
  #} else{
  #   urldir <- sprintf("http://agencia.tse.jus.br/estatistica/sead/odsele/perfil_eleitorado/perfil_eleitorado_%s.zip", year) 
  #  }

  filenames  <- paste0("/eleitorado_local_votacao_", year, ".zip")
  dados <- paste0(file.path(tempdir()), filenames)
  url <- "https://cdn.tse.jus.br/estatistica/sead/odsele/eleitorado_locais_votacao%s"
  
  # Downloads the data
  download_unzip(url, dados, filenames, year)
  
  # remover temp file
  if(temp == FALSE){
    unlink(dados)
  }
  
  setwd(as.character(year))
  
  archive <- Sys.glob("*")[grepl(".pdf", Sys.glob("*")) == FALSE] %>%
    file.info() %>%
    .[.$size > 200, ] %>%
    row.names()
  
  if(grepl(".csv", archive[1])){
    test_col_names <- TRUE
  }else{
    test_col_names <- FALSE
  }
  
  banco <- readr::read_delim(archive, col_names = test_col_names, delim = ";", 
                             locale = readr::locale(encoding = encoding), 
                             col_types = readr::cols(), progress = F, escape_double = F) %>%
    dplyr::as_tibble()
  
  setwd("..")
  unlink(as.character(year), recursive = T)
  
  
  # Change to ascii
  if(ascii) banco <- to_ascii(banco, encoding)
  
  # Export
  if(export) export_data(banco)
  
  message("Done.\n")
  banco
}

