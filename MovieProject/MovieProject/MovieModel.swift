import Foundation


struct MovieModel: Identifiable {
  let id: Int
  var title: String
  var posterURL: String
  var overview: String
  var releaseDate: String
}

extension MovieModel {
  init(from result: MovieSearchResult) {
    let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    
    self.id = result.id
    self.title = result.title ?? "제목 없음"
    self.overview = result.overview ?? "설명 없음"
    self.posterURL = imageBaseURL + (result.posterPath ?? "")
    self.releaseDate = result.releaseDate ?? "개봉일 미정"
  }
}
