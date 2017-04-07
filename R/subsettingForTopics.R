#' Subsetting articles for topics


getAllTopicsAndFrequencies <- function(pathToTrainingDataDirectory) {
  M <- list.files(path = pathToTrainingDataDirectory, 
                  pattern = "*.json")
  
  for (i in 1:length(M)) {
    if (i == 1) {
      topics <- freq <- c()
    }
    trainingData <- jsonlite::read_json(path = paste0(pathToTrainingDataDirectory, M[i]))
    for (j in 1:length(trainingData$TrainingData)) {
      newTopics <- unlist(trainingData$TrainingData[[j]]$topics)
      topics <- unique(c(topics, newTopics))
      if (length(newTopics) > 0) {
        for (k in 1:length(newTopics)) {
          mat <- match(newTopics[k], topics)
          if (!is.null(freq[mat])) {
            if (!is.na(freq[mat])) {
              freq[mat] <- freq[mat] + 1
            } else {
              freq[mat] <- 1
            }
          } else {
            freq[mat] <- 1
          }
        }
      }
    }
  }
  df <- data.frame(topics = topics,
                   freq = freq,
                   stringsAsFactors = FALSE)
  return(df)
}


storeArticlesForTopic <- function(pathToTrainingDataDirectory, pathToTopicsDirectory, topic) {
  topicDirectory <- paste0(pathToTopicsDirectory, "/", topic)
  
  if (!dir.exists(topicDirectory)) {
    dir.create(topicDirectory, 
               recursive = TRUE)
  }
  
  M <- list.files(path = pathToTrainingDataDirectory, 
                  pattern = "*.json")
  
  topicArticles <- list()
  
  for (i in 1:length(M)) {
    trainingData <- jsonlite::read_json(path = paste0(pathToTrainingDataDirectory, M[i]))
    for (j in 1:length(trainingData$TrainingData)) {
      articleTopics <- unlist(trainingData$TrainingData[[j]]$topics)
      if (topic %in% articleTopics) {
        topicArticles <- c(topicArticles, 
                           trainingData$TrainingData[[j]])
      }
    }
  }
  
  save(topicArticles,
       file = paste0(topicDirectory, "/", topic, "Data.RData"))
  
  return(topicArticles)
}
