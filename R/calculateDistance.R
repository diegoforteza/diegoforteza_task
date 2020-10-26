#' @title calculateDistance
#' @description The maximun distance between two consecutive observations (measured within three minutes)
#' @param myData data.frame with ship registers
#' @return data.frame with ids of the observations (start and end), distance and difftime
#' @export
calculateDistance=function(myData){
  
  myData$DATETIME <- as.POSIXct(myData$DATETIME);
  myData <- myData[order(myData$DATETIME, decreasing=FALSE), ];
  result <- list();
  for(i in 1:(nrow(myData)-1)){
    
    result[[i]] <- c(start=i, end=i+1, time=myData$DATETIME[i],
                     difftime=difftime(myData$DATETIME[i+1], myData$DATETIME[i], units = "mins"),
                     distance=geosphere::distm(myData[i, c("LON", "LAT")], 
                                               myData[i+1, c("LON", "LAT")], 
                                               fun = geosphere::distHaversine)); # default is meters
    
  }
  result <- dplyr::bind_rows(result);
  is.na(result$difftime) <- which(result$difftime > 3);
  result <- result[complete.cases(result), ];
  result <- result[order(result$time, decreasing = TRUE), ];
  result[which.max(result$distance)[1], ];
  
}