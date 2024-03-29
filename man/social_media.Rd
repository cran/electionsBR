% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/social_media.R
\name{social_media}
\alias{social_media}
\title{Download data on the candidates' social media links in federal elections}
\usage{
social_media(year, encoding = "latin1", temp = TRUE, readme_pdf = FALSE)
}
\arguments{
\item{year}{Election year (\code{integer}). For this function, only the years 2020 and 2022
are available.}

\item{encoding}{Data original encoding (defaults to 'latin1'). This can be changed to avoid errors
when \code{ascii = TRUE}.}

\item{temp}{(\code{logical}). Whether to keep the temporary data files for future use (recommended).}

\item{readme_pdf}{should the original README file be saved as a PDF in the working directory? Defaults to FALSE.}
}
\value{
\code{social_media()} returns a \code{tbl, data.frame}.
}
\description{
\code{social_media()} is a function that allows you to download data on the social media handles of candidates participating in federal and municipal elections in Brazil. The function returns a \code{data.frame} where each observation corresponds to a candidate's social media handles (i.e., usernames).
}
\details{
If export is set to \code{TRUE}, the downloaded data is saved as .dta and .sav
 files in the current directory.
}
\examples{
\dontrun{
df <- social_media(2022)
}
}
