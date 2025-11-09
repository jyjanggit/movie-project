import SwiftUI
import SwiftData

protocol CommentFetchAllRepository: AnyObject {
  func fetchAllComments() -> [CommentModel]
}

final class CommentFetchAllRepositoryImpl: CommentFetchAllRepository {
  
  private let modelContext: ModelContext
  
  init(modelContext: ModelContext) {
    self.modelContext = modelContext
  }
  
  func fetchAllComments() -> [CommentModel] {
    do {
      let predicate = #Predicate<CommentModel> { movie in !movie.userComment.isEmpty }
      let descriptor = FetchDescriptor(predicate: predicate, sortBy: [SortDescriptor(\.timestamp, order: .reverse)])
      return try modelContext.fetch(descriptor)
    } catch {
      print("모든 감상평 조회 실패: \(error)")
      return []
    }
  }
  
}


final class MyCommentViewModel: ObservableObject {
  
  private let repository: CommentFetchAllRepository
  
  @Published var comments: [CommentModel] = []
  
  init(repository: CommentFetchAllRepository) {
    self.repository = repository
  }
  

  func loadComments() {
    self.comments = repository.fetchAllComments()
  }
}

//#Preview {
//  MyCommentView()
//}
