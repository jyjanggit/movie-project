import Foundation
import SwiftData

@Model
final class CommentModel {
  var movieID: Int
  var movieTitle: String
  var moviePosterURL: String
  var releaseDate: String
  
  var userComment: String
  
  var timestamp: Date
  
  init(movieID: Int, movieTitle: String, moviePosterURL: String, releaseDate: String, userComment: String, timestamp: Date) {
    self.movieID = movieID
    self.movieTitle = movieTitle
    self.moviePosterURL = moviePosterURL
    self.releaseDate = releaseDate
    self.userComment = userComment
    self.timestamp = timestamp
  }
}
