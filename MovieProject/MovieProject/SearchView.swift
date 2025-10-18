import SwiftUI

struct SearchView: View {
  
  @StateObject var viewModel = MovieViewModel()
  @Binding var tabIndex: Int
  
  var body: some View {
    
    NavigationStack{
      List {
        
        if viewModel.isLoading {
          ProgressView("영화 검색 중...")
            .listRowSeparator(.hidden)
        } else if let error = viewModel.errorMessage {
          VStack(alignment: .center) {
            Text(error)
              .foregroundColor(.gray)
              .font(.title3)
              .frame(maxWidth: .infinity)
          }.listRowSeparator(.hidden)
        }
        
        ForEach(viewModel.movies) { item in
          
          
          NavigationLink {
            DetailView(movie: item)
          } label: {
            MovieCellView(movie: item)
          }
          .listRowSeparator(.hidden)
        }
      }
      .listStyle(.plain)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .principal) {
          VStack(spacing: 0) {
            Text("영화 검색").font(.system(size: 24, weight: .bold))
              .minimumScaleFactor(0.9)
          }
        }
      }
      .searchable(text: $viewModel.searchText,
                  placement: .navigationBarDrawer(displayMode: .always) ,
                  prompt: "영화제목을 입력하세요").onSubmit(of: .search) {
        viewModel.searchButtonTapped()
      }
    }
  }
}

#Preview {
  SearchView(tabIndex: .constant(0))
}
