import SwiftUI

struct SearchView: View {
  @StateObject var viewModel = MovieViewModel()
  @Binding var tabIndex: Int
  var items: [MovieModel] = [MovieModel(id: 1, title: "기생충",
                                        posterPath: "Sample3",
                                        overview: "가난한 가족이 부유한 집에 침투하면서 벌어지는 이야기",
                                        releaseDate: "2019-05-30"),
                             MovieModel(id: 2, title: "파묘", posterPath: "Sample3", overview: "영화 파묘의 줄거리", releaseDate: "2020-02-22"),
                             MovieModel(id: 3, title: "인터스텔라", posterPath: "Sample3", overview: "영화 인터스텔라의 줄거리", releaseDate: "2018-02-22")]
  
  
  
  
  var body: some View {
    
    
    NavigationStack{
      List {
        ForEach(viewModel.movies) { item in
          NavigationLink {
            DetailView(movie: item)
          } label: {
            MovieCellView(movie: item)
          }.listRowSeparator(.hidden)
        }
      }.listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .principal) {
            VStack(spacing: 0) {
              Text("영화 검색").font(.system(size: 24, weight: .bold))
                .minimumScaleFactor(0.9)
            }
          }
          
          
        }.searchable(text: $viewModel.searchText,
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
