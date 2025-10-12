import SwiftUI

struct HomeView: View {
  @State var tabIndex = 0
  
  var body: some View {
    TabView(selection: $tabIndex){
      SearchView(tabIndex: $tabIndex).tabItem{Image(systemName: "list.bullet")}.tag(0)
      MyCommentView().tabItem{Image(systemName: "person.circle")}.tag(1)
    }.tint(Color.black)
  }
}

#Preview {
  HomeView()
}
