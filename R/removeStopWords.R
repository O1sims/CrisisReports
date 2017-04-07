#' @title A function to remove a library of stop words
#' @param location the project location on local machine
#' @param articleString the article text to be parsed

removeStopWords <- function(location ="~/", articleString = 'test string') {

  stopWords <- read.csv(paste0(location, "crisisReports/data/stopwords.csv"), header=F, stringsAsFactors = FALSE)  
  resultString <- tolower(articleString)
  for (i in 1:length(stopWords[[1]])) {
    resultString <- gsub(pattern = paste0(" ", stopWords[[1]][i], " "), replacement = ' ', x = resultString)
  }
  
  return(resultString)
  
}
