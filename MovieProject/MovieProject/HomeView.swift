import SwiftUI
import SwiftData

struct HomeView: View {
  @Environment(\.modelContext) private var modelContext
  
  @State var tabIndex = 0
  
  private var myCommentViewModel: MyCommentViewModel {
    let repository = CommentFetchAllRepositoryImpl(modelContext: modelContext)
    return MyCommentViewModel(repository: repository)
  }
  
  var body: some View {
    TabView(selection: $tabIndex){
      SearchView(tabIndex: $tabIndex).tabItem{Image(systemName: "list.bullet")}.tag(0)
      
      MyCommentView(viewModel: myCommentViewModel)
        .tabItem{Image(systemName: "person.circle")}.tag(1)
      
    }.tint(Color.black)
  }
}

#Preview {
  HomeView()
}
