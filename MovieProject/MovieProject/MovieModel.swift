import Foundation


struct MovieModel: Identifiable {
  let id: Int
  var title: String
  var posterPath: String
  var overview: String
  var releaseDate: String
}
