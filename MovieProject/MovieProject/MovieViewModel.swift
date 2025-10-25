import Foundation
import Alamofire
import SwiftUI
import SwiftData

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

protocol CommentRepository: AnyObject {
  func saveComment(comment: Comment, completion: @escaping (Result<Void, Error>) -> Void)
  func fetchComment(by movieID: Int) -> Comment?
  func fetchAllComments() -> [Comment]
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



final class CommentRepositoryImpl: CommentRepository {
  
  private let modelContext: ModelContext
  
  init(modelContext: ModelContext) {
    self.modelContext = modelContext
  }
  
  func saveComment(comment: Comment, completion: @escaping (Result<Void, Error>) -> Void) {
    Task { @MainActor in
      do {
        let existingComment = self.fetchComment(by: comment.movieID)
        
        if comment.userComment.isEmpty {
          if let target = existingComment {
            self.modelContext.delete(target)
            try self.modelContext.save()
          }
          return completion(.success(()))
        }
        
        if let target = existingComment {
          target.userComment = comment.userComment
          target.timestamp = Date()
        } else {
          self.modelContext.insert(comment)
        }
        
        try self.modelContext.save()
        completion(.success(()))
      } catch {
        completion(.failure(error))
      }
    }
  }
  
  func fetchComment(by movieID: Int) -> Comment? {
    do {
      let predicate = #Predicate<Comment> { $0.movieID == movieID }
      var descriptor = FetchDescriptor(predicate: predicate)
      descriptor.sortBy = [SortDescriptor(\Comment.timestamp, order: .reverse)]
      
      let comments = try modelContext.fetch(descriptor)
      return comments.first
    } catch {
      print("감상평 조회 실패: \(error)")
      return nil
    }
  }
  
  func fetchAllComments() -> [Comment] {
    do {
      let predicate = #Predicate<Comment> { !$0.userComment.isEmpty }
      let descriptor = FetchDescriptor(predicate: predicate, sortBy: [SortDescriptor(\.timestamp, order: .reverse)])
      return try modelContext.fetch(descriptor)
    } catch {
      print("모든 감상평 조회 실패: \(error)")
      return []
    }
  }
  
}
//enum CommentError: Error {
//  case contextError
//  case saveError
//}
final class CommentInputViewModel: ObservableObject {
  
  private let repository: CommentRepository
  
  @Published var isSaving = false
  @Published var saveSuccess = false
  @Published var saveError: String?
  @Published var commentText: String = ""
  
  
  init(repository: CommentRepository) {
    self.repository = repository
  }
  
  func save(movie: MovieModel) {
    guard !self.commentText.isEmpty else {
      self.saveError = "감상평 내용을 입력해주세요."
      return
    }
    
    isSaving = true
    saveSuccess = false
    saveError = nil
    
    let newComment = Comment(
      movieID: movie.id,
      movieTitle: movie.title,
      moviePosterURL: movie.posterURL,
      releaseDate: movie.releaseDate,
      userComment: self.commentText,
      timestamp: Date()
    )
    

    
    repository.saveComment(comment: newComment) { [weak self] result in
      DispatchQueue.main.async {
        guard let self = self else { return }
        self.isSaving = false
        
        switch result {
        case .success:
          self.saveSuccess = true
          
        case .failure(let error):
          self.saveError = "저장 실패: \(error.localizedDescription)"
        }
      }
    }
  }
  
  func loadComment(movieID: Int) {
    
    if let commentData = repository.fetchComment(by: movieID) {
      self.commentText = commentData.userComment
    } else {
      self.commentText = ""
    }
  }
}
