import SwiftUI
import SwiftData

struct MyCommentView: View {
  
  @Environment(\.modelContext) private var modelContext
  
  @StateObject private var viewModel: MyCommentViewModel
  
  init(viewModel: MyCommentViewModel) {
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    NavigationStack{
      List {
        ForEach(viewModel.comments) { comment in
          
          VStack(alignment: .leading, spacing: 12) {
            Text(comment.movieTitle).font(.title2).bold().accessibilityAddTraits(.isHeader)
            Text(comment.userComment).font(.callout).accessibilityLabel("감상평 내용: \(comment.userComment)")
          }.padding(.vertical, 12).alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
            return -viewDimensions.width
          }.accessibilityElement(children: .combine)
        }
      }.listStyle(.plain).listRowSeparator(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .principal) {
            VStack(spacing: 0) {
              Text("나의 감상평").font(.system(size: 24, weight: .bold))
                .minimumScaleFactor(0.9)
            }
          }
        }
        .onAppear {
          viewModel.loadComments()
        }
    }
  }
}

//#Preview {
//  MyCommentView()
//}
