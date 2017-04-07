#' @title insert some JSON object into ES
#' @param inputJSON a standard format for JSON which is inserted into an ES Document

install.packages("elastic")
library("elastic")
library("rjson")

insertDocumentInES <- function(inputJSON) {
  elastic::connect()
  
  # Need to create some index (probably elsewhere)
  elastic::index_create(index="article-db")

  # create a `Document` with meta tags _index, _type, _id, and _version
  suppress <- capture.output(elastic::docs_create(index = "article-db", 
                                                  type = "line", 
                                                  id = 0,
                                                  body = list(article="article text can go here..") ) )
  someDocument <- elastic::docs_get(index = "article-db", 
                                    type = "line", 
                                    id = 0)
  
  # Need to append an _id tag to the whole data set and need to be more comfortable of the schema.
  dataSet <- "~/Desktop/project/CrisisReports/testdata/TestData.json"
  jsonData <- fromJSON(paste(readLines(dataSet), collapse=""))
  elastic::docs_bulk(x = jsonData)
}

