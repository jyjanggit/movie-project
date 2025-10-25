import SwiftUI
import SwiftData

struct DetailView: View {
  
  @Environment(\.modelContext) private var modelContext
  
  let movie: MovieModel
  
  @StateObject private var viewModel: CommentInputViewModel
  
  init(movie: MovieModel, viewModel: CommentInputViewModel) {
    self.movie = movie
    _viewModel = StateObject(wrappedValue: viewModel)
  }
  
  var body: some View {
    VStack{
      
      ScrollView{
        VStack{
          AsyncImage(url: URL(string: movie.posterURL)) { phase in
            switch phase {
            case .success(let image):
              image
                .resizable()
                .aspectRatio(contentMode: .fit)
            case .failure:
              Image(systemName: "photo").resizable().scaledToFit().foregroundStyle(.gray)
            case .empty:
              ProgressView()
            @unknown default:
              EmptyView()
            }
          }
          .scaledToFit()
          .padding(.vertical, 16)
          
          Text(movie.overview)
            .font(.title2)
            .padding(.bottom, 8)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
          
          Text("개봉일: \(movie.releaseDate)")
            .font(.title2)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
          
        }
        
        ZStack(alignment: .topLeading) {
          TextEditor(text: $viewModel.commentText)
            .scrollContentBackground(.hidden)
            .background(.clear)
          
          
          if viewModel.commentText.isEmpty {
            Text("감상평 내용을 입력하세요")
              .foregroundColor(.gray)
              .padding(8)
              .font(.body)
          }
          
        }
        .frame(height: 200)
        
        
        Button {
          viewModel.save(movie: movie)
        } label: {
          if viewModel.isSaving {
            ProgressView().progressViewStyle(.circular).frame(width: 320, height: 42)
          } else {
            Text("감상평 작성").frame(width: 320, height: 42).foregroundStyle(.white).background(.blue).clipShape(RoundedRectangle(cornerRadius: 20))
          }
        }
        
        .alert("알림", isPresented: $viewModel.saveSuccess) {
          Button("확인", role: .cancel) { }
        } message: {
          Text("감상평이 성공적으로 저장되었습니다.")
        }
        
        if let error = viewModel.saveError {
          Text(error).foregroundColor(.red)
        }
        
        Spacer()
      }
      .padding(.horizontal, 16)
      
      .onAppear {
        
        viewModel.loadComment(movieID: movie.id)
        
        
      }
    }
    .navigationTitle(movie.title)
    .navigationBarTitleDisplayMode(.inline)
  }
}

//#Preview {
//  DetailView(movie: MovieModel(
//    id: 1,
//    title: "기생충",
//    posterURL: "https://image.tmdb.org/t/p/w500/k0gU48B77c4yVb6Y710H392Ua3v.jpg",
//    overview: "가난한 가족이 부유한 집에 침투하면서 벌어지는 이야기",
//    releaseDate: "2019-05-30"
//  ))
//}
