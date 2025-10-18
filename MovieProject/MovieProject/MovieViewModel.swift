import Foundation
import Alamofire
import SwiftUI

struct MovieSearchResult: Codable {
  let id: Int
  let title: String?
  let overview: String?
  let posterPath: String?
  let releaseDate: String?
  
  enum CodingKeys: String, CodingKey {
    case id, title, overview
    case posterPath = "poster_path"
    case releaseDate = "release_date"
  }
}

struct MovieResponse: Codable {
  let page: Int
  let totalResults: Int
  let totalPages: Int
  let results: [MovieSearchResult]
  
  enum CodingKeys: String, CodingKey {
    case page
    case totalResults = "total_results"
    case totalPages = "total_pages"
    case results
  }
}

enum NetworkError: Error {
  case networkingError
  case dataError
  case parseError
  
  var localizedDescription: String {
    switch self {
    case .networkingError: return "네트워크 연결에 문제가 있습니다."
    case .dataError: return "데이터를 불러오는 데 실패했습니다."
    case .parseError: return "데이터 형식을 해석하는 데 실패했습니다."
    }
  }
}

protocol MovieSearchRepository: AnyObject {
  func searchMovies<T: Decodable>(query: String, completion: @escaping (Result<T, NetworkError>) -> Void)
}



final class MovieNetworking: MovieSearchRepository {
  
  static let shared = MovieNetworking()
  private init() {}
  
  func searchMovies<T: Decodable>(query: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
    
    guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
      return completion(.failure(.networkingError))
    }
    
    let parameters: [String: Any] = [
      "api_key": MovieApi.apiKey,
      "query": encodedQuery,
      "language": "ko-KR"
    ]
    
    AF.request(MovieApi.url, method: .get, parameters: parameters)
      .responseDecodable(of: T.self) { response in
        
        if let error = response.error {
          print("Alamofire Request Error: \(error.localizedDescription)")
          return completion(.failure(.networkingError))
        }
        
        switch response.result {
        case .success(let decodedData):
          completion(.success(decodedData))
        case .failure(_):
          completion(.failure(.parseError))
        }
      }
  }
}



final class MovieViewModel: ObservableObject {
  
  private let repository: any MovieSearchRepository
  
  
  
  @Published var movies: [MovieModel] = []
  @Published var searchText: String = ""
  @Published var isLoading = false
  @Published var errorMessage: String?
  
  init(repository: any MovieSearchRepository = MovieNetworking.shared) {
    self.repository = repository
  }
  
  func searchButtonTapped() {
    let query = self.searchText
    
    guard !query.isEmpty else {
      movies = []
      errorMessage = nil
      return
    }
    
    isLoading = true
    errorMessage = nil
    
    repository.searchMovies(query: query) { [weak self] (result: Result<MovieResponse, NetworkError>) in
      DispatchQueue.main.async {
        guard let self = self else { return }
        
        self.isLoading = false
        
        switch result {
        case .success(let response):
          self.movies = response.results.map { MovieModel(from: $0) }
          
          if self.movies.isEmpty {
            self.errorMessage = "검색 결과가 없습니다."
          } else {
            self.errorMessage = nil
          }
          
        case .failure(let error):
          print("검색 실패: \(error.localizedDescription)")
          self.errorMessage = "검색 실패: \(error.localizedDescription)"
          self.movies = []
        }
      }
    }
  }
}



