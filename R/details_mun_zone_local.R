#' Download data on the verification of local elections in Brazil
#'
#' \code{details_mun_zone_local()} downloads and aggregates the data on the verification of local elections in Brazil,
#' disaggregated by electoral zone. The function returns a \code{data.frame} where each observation
#' corresponds to a town/zone.
#'
#' @note For the elections prior to 2000, some information can be incomplete.
#'
#' @param year Election year. For this function, only the years 1996, 2000, 2004, 2008, 2012, 2016 and 2020
#' are available.
#' 
#' @param uf Federation Unit acronym (\code{character vector}).
#'
#' @param ascii (\code{logical}). Should the text be transformed from Latin-1 to ASCII format?
#'
#' @param encoding Data original encoding (defaults to 'Latin-1'). This can be changed to avoid errors
#' when \code{ascii = TRUE}.
#' 
#' @param export (\code{logical}). Should the downloaded data be saved in .dta and .sav in the current directory?
#'
#' @param temp (\code{logical}). elections_rda
#' 
#' @details If export is set to \code{TRUE}, the downloaded data is saved as .dta and .sav
#'  files in the current directory.
#'
#' @return \code{details_mun_zone_local()} returns a \code{data.frame} with the following variables:
#'
#' \itemize{
#'   \item DATA_GERACAO: Generation date of the file (when the data was collected).
#'   \item HORA_GERACAO: Generation time of the file (when the data was collected), Brasilia Time.
#'   \item ANO_ELEICAO: Election year.
#'   \item NUM_TURNO: Round number.
#'   \item DESCRICAO_ELEICAO: Description of the election.
#'   \item SIGLA_UF: Units of the Federation's acronym in which occurred the election.
#'   \item SIGLA_UE: Units of the Federation's acronym (In case of major election is the FU's
#'   acronym in which the candidate runs for (text) and in case of municipal election is the
#'   municipal's Supreme Electoral Court code (number)). Assume the special values BR, ZZ and
#'   VT to designate, respectively, Brazil, Overseas and Absentee Ballot.
#'   \item CODIGO_MUNICIPIO: Supreme Electoral code from the city where occurred the election.
#'   \item NOME_MUNICIPIO: Name of the city where occurred the election.
#'   \item CODIGO_CARGO: Code of the position that the candidate runs for.
#'   \item DESCRICAO_CARGO: Description of the position that the candidate runs for.
#'   \item QTD_APTOS: Number of eligible voters to vote in that city and zone.
#'   \item QTD_SECOES: Number of existing polling stations in that city and zone. It only considers main sections.
#'   \item QTD_SECOES_AGREGADAS: Number of polling stations that have been aggregated for the voting the same ballot box in that city and area. To add sections means to unite polling stations in a single receiving table votes, in order to meet the Electoral Code, which establishes, as a rule, a minimum of 50 voters in a section election, and to optimize the use of resources for the polls electronic and poll workers.
#'   \item QTD_APTOS_TOT: Number of eligible voters in the total sections.
#'   \item QTD_SECOES_TOT: Total number of polling stations in that city and area.
#'   \item QTD_COMPARECIMENTO: Number of voters who attended the elections in city and district in that position.
#'   \item QTD_ABSTENCOES: Number of voters who did not attend the elections in city and area.
#'   \item QTD_VOTOS_NOMINAIS: Total number of nominal votes in that city and zone.
#'   \item QTD_VOTOS_BRANCOS: Total number of blank votes in that city and zone.
#'   \item QTD_VOTOS_NULOS: Total number of spoilt votes in that city and zone.
#'   \item QTD_VOTOS_LEGENDA: Total number of votes in coalitions in that city and zone.
#'   \item QTD_VOTOS_ANULADOS_APU_SEP: Amount of canceled votes and votes counted separately in that city and zone. This number reflects the votes coming from some ballot box that is sub-judice. They are not yet valid votes or null until the decision of the electoral court.
#'   \item DATA_ULT_TOTALIZACAO: Date of the last totalization in that city and zone.
#'   \item HORA_ULT_TOTALIZACAO: Time of the last totalization in that city and zone.
#'   \item TRANSITO: Electoral result outside the candidates' district? (N for no).
#'   \item QTD_VOTOS_ANULADOS: Total number of votes invalidated by Brazilian Electoral Supreme Court.
#' }
#'
#' @seealso \code{\link{details_mun_zone_fed}} for federal elections in Brazil.
#'
#' @import utils
#' @importFrom magrittr "%>%"
#' @export
#' @examples
#' \dontrun{
#' df <- details_mun_zone_local(2000)
#' }

details_mun_zone_local <- function(year, uf = "all", 
                                   ascii = FALSE, 
                                   encoding = "latin1",
                                   export = FALSE,
                                   temp = TRUE){


  # Input tests
  test_encoding(encoding)
  test_local_year(year)
  uf <- test_uf(uf)

  filenames  <- paste0("/detalhe_votacao_munzona_", year, ".zip")
  dados <- paste0(file.path(tempdir()), filenames)
  url <- "https://cdn.tse.jus.br/estatistica/sead/odsele/detalhe_votacao_munzona%s"
  
  # Downloads the data
  download_unzip(url, dados, filenames, year)
  
  # remover temp file
  if(temp == FALSE){
    unlink(dados)
  }

  # Cleans the data
  setwd(as.character(year))
  banco <- juntaDados(uf, encoding, FALSE)
  setwd("..")
  unlink(as.character(year), recursive = T)

  # Changes variables names
  if(year <= 2012){
     names(banco) <- c("DATA_GERACAO", "HORA_GERACAO", "ANO_ELEICAO", "NUM_TURNO", "DESCRICAO_ELEICAO",
                       "SIGLA_UF", "SIGLA_UE", "CODIGO_MUNICIPIO", "NOME_MUNICIPIO", "NUMERO_ZONA",
                       "CODIGO_CARGO", "DESCRICAO_CARGO", "QTD_APTOS", "QTD_SECOES", "QTD_SECOES_AGREGADAS",
                       "QTD_APTOS_TOT", "QTD_SECOES_TOT", "QTD_COMPARECIMENTO", "QTD_ABSTENCOES",
                       "QTD_VOTOS_NOMINAIS", "QTD_VOTOS_BRANCOS", "QTD_VOTOS_NULOS", "QTD_VOTOS_LEGENDA",
                       "QTD_VOTOS_ANULADOS_APU_SEP", "DATA_ULT_TOTALIZACAO", "HORA_ULT_TOTALIZACAO")

  } else {
    
    names(banco) <- c("DATA_GERACAO", "HORA_GERACAO", "ANO_ELEICAO", "COD_TIPO_ELEICAO", "NOME_TIPO_ELEICAO",     
                      "NUM_TURNO", "COD_ELEICAO", "DESCRICAO_ELEICAO", "DATA_ELEICAO", "ABRANGENCIA", "SIGLA_UF",
                      "SIGLA_UE", "NOME_UE", "CODIGO_MUNICIPIO", "NOME_MUNICIPIO", "NUMERO_ZONA", "CODIGO_CARGO",
                      "DESCRICAO_CARGO", "QTD_APTOS", "QTD_SECOES", "QTD_SECOES_AGREGADAS", "QTD_APTOS_TOT",
                      "QTD_SECOES_TOT", "QTD_COMPARECIMENTO", "QTD_ABSTENCOES", "TRANSITO", "QTD_VOTOS_NOMINAIS",
                      "QTD_VOTOS_BRANCOS", "QTD_VOTOS_NULOS", "QTD_VOTOS_LEGENDA", "QTD_VOTOS_PENDENTES",
                      "QTD_VOTOS_ANULADOS", "HORA_ULT_TOTALIZACAO", "DATA_ULT_TOTALIZACAO")
  }
  
  # Change to ascii
  if(ascii == T) banco <- to_ascii(banco, encoding)
  
  # Export
  if(export) export_data(banco)

  message("Done.\n")
  return(banco)
}
