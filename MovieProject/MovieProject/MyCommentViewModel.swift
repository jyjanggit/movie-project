import SwiftUI
import SwiftData


final class MyCommentViewModel: ObservableObject {
  
  private let repository: CommentRepository
  
  @Published var comments: [Comment] = []
  
  init(repository: CommentRepository) {
    self.repository = repository
  }
  
  func loadComments() {
    self.comments = repository.fetchAllComments()
  }
}

//#Preview {
//  MyCommentView()
//}
