# Startup message
.onAttach <- 
  function(libname, pkgname) {
    packageStartupMessage("\nTo cite electionsBR in publications, use: citation('electionsBR')")
    packageStartupMessage("To learn more, visit: http://electionsbr.com\n")
  }


#' Returns a vector with the abbreviations of all Brazilian states
#'
#' @export 

uf_br <- function() {
  
  c("AC", "AL", "AM", "AP", "BA", "CE", "DF", "ES", "GO", "MA", 
    "MG", "MS", "MT", "PA", "PB", "PE", "PI", "PR", "RJ", "RN", 
    "RO", "RR", "RS", "SC", "SE", "SP", "TO")
}


#' Returns a vector with the abbreviations of all Brazilian parties
#'
#' The character vector includes only parties that ran in elections in 2016.
#' 
#' @export

parties_br <- function() {
  
  c("AVANTE", "CIDADANIA", "DC", "DEM", "MDB", "NOVO", "PATRIOTA", 
    "PC do B", "PCB", "PCO", "PDT", "PEN", "PHS", "PMB", "PMN", "PODE", 
    "PP", "PPL", "PPS", "PR", "PRB", "PROS", "PRP", "PRTB", "PSB", 
    "PSC", "PSD", "PSDB", "PSDC", "PSL", "PSOL", "PSTU", "PT", "PT do B", 
    "PTB", "PTC", "PTN", "PV", "REDE", "REPUBLICANOS", "SD", "SOLIEDARIEDADE", 
    "UP")
}


# Reads and rbinds multiple data.frames in the same directory
#' @import dplyr
juntaDados <- function(uf, encoding, br_archive){

   archive <- Sys.glob("*")[grepl(".pdf", Sys.glob("*")) == FALSE] %>%
      .[grepl(uf, .)] %>%
      file.info() %>%
      .[.$size > 200, ] %>%
      row.names()
   
   if(!br_archive){
     
     archive <- archive[grepl("BR", archive) == FALSE]
     
   } else {
     
     archive <- archive[grepl("BR", archive) == TRUE]
   }
   
   if(grepl(".csv", archive[1])){
     test_col_names <- TRUE
   }else{
     test_col_names <- FALSE
   }
   
  lapply(archive, function(x) tryCatch(
    suppressWarnings(readr::read_delim(x, col_names = test_col_names, 
                                       delim = ";",
                                       locale = readr::locale(encoding = encoding), 
                                       col_types = readr::cols(), progress = F,
                                       escape_double = F)), 
                                error = function(e) NULL)) %>%
  data.table::rbindlist() %>%
  dplyr::as_tibble()

}


# Converts electoral data from Latin-1 to ASCII
#' @import dplyr
to_ascii <- function(banco, encoding){
  
  if(encoding == "Latin-1") encoding <- "latin1"
  dplyr::mutate_if(banco, is.character, dplyr::funs(iconv(., from = encoding, to = "ASCII//TRANSLIT")))
}


# Tests federal election year inputs
test_fed_year <- function(year){

  if(!is.numeric(year) | length(year) != 1 | !year %in% seq(1994, 2018, 4)) stop("Invalid input. Please, check the documentation and try again.")
}


# Tests federal election year inputs
test_local_year <- function(year){

  if(!is.numeric(year) | length(year) != 1 | !year %in% seq(1996, 2020, 4)) stop("Invalid input. Please, check the documentation and try again.")
}


# Test federal positions
#test_fed_position <- function(position){
#  position <- tolower(position)
#  if(!is.character(position) | length(position) != 1 | !position %in% c("presidente",
#                                                                        "governador",
#                                                                        "senador",
#                                                                        "deputado federal",
#                                                                        "deputado estadual",
#                                                                        "deputado distrital")) stop("Invalid input. Please, check the documentation and try again.")
#}


# Test federal positions
#test_local_position <- function(position){
#  position <- tolower(position)
#  if(!is.character(position) | length(position) != 1 | !position %in% c("prefeito",
#                                                                        "vereador")) stop("Invalid input. Please, check the documentation and try again.")
#}


# Converts electoral data from Latin-1 to ASCII
test_encoding <- function(encoding){
  if(encoding == "Latin-1") encoding <- "latin1"
  
  if(!encoding %in% tolower(iconvlist())) stop("Invalid encoding. Check iconvlist() to view a list with all valid encodings.")
}


# Test br types
test_br <- function(br_archive){
  
  if(!is.logical(br_archive)) message("'br_archive' must be logical (TRUE or FALSE).")
}


# Tests state acronyms
test_uf <- function(uf) {
  
  uf <- gsub(" ", "", uf) %>%
    toupper()
  
  uf <- match.arg(uf, c("AC", "AL", "AM", "AP", "BA", "CE", "DF", "ES", "GO", "MA", 
                        "MG", "MS", "MT", "PA", "PB", "PE", "PI", "PR", "RJ", "RN", 
                        "RO", "RR", "RS", "SC", "SE", "SP", "TO", "ALL"), several.ok = T)
  
  if("ALL" %in% uf) return(".")
  else return(paste(uf, collapse = "|"))
}

# Replace position by cod position
# replace_position_cod <- function(position){
#  position <- tolower(position)
#  return(switch(position, "presidente" = 1,
#         "governador" = 3,
#         "senador" = 5,
#         "deputado federal" = 6,
#         "deputado estadual" = 7,
#         "deputado distrital" = 8,
#         "prefeito" = 11,
#         "vereador" = 13))
# }

# Function to export data to .dta and .sav
export_data <- function(df) {
  
  haven::write_dta(df, "electoral_data.dta")
  haven::write_sav(df, "electoral_data.sav")
  message(paste0("Electoral data files were saved on: ", getwd(), ".\n"))
}


# Data download
download_unzip <- function(url, dados, filenames, year){
  
  if(!file.exists(dados)){
    
    sprintf(url, filenames) %>%
      download.file(dados)
    
    message("Processing the data...")
    unzip(dados, exdir = paste0("./", year))
    
  } else{
    
    message("Processing the data...")
    unzip(dados, exdir = paste0("./", year))
  }
}


# Avoid the R CMD check note about magrittr's dot
utils::globalVariables(".")

