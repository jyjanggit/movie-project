import Foundation


final class MovieViewModel: ObservableObject {
  
  @Published var movies: [MovieModel] = [MovieModel(id: 1, title: "기생충",
                                                    posterPath: "Sample3",
                                                    overview: "가난한 가족이 부유한 집에 침투하면서 벌어지는 이야기",
                                                    releaseDate: "2019-05-30"),
                                         MovieModel(id: 2, title: "파묘", posterPath: "Sample3", overview: "영화 파묘의 줄거리", releaseDate: "2020-02-22"),
                                         MovieModel(id: 3, title: "인터스텔라", posterPath: "Sample3", overview: "영화 인터스텔라의 줄거리", releaseDate: "2018-02-22")]
  @Published var searchText: String = ""
  
  func searchButtonTapped() {
    print("검색어 '\(searchText)'로 검색 시작 로직 실행")
  }
  
  
}



