import SwiftUI

struct DetailView: View {
  
  let movie: MovieModel
  @State var comment: String = ""
  
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
            .multilineTextAlignment(.leading) // 텍스트 정렬을 왼쪽으로
            .frame(maxWidth: .infinity, alignment: .leading) // 좌측 정렬을 위해 추가
          
        }
        
        ZStack(alignment: .topLeading) {
          TextEditor(text: $comment)
          
          if comment.isEmpty {
            Text("감상평 내용을 입력하세요")
              .foregroundColor(.gray)
              .padding(10)
          }
          
        }
        .frame(height: 200)
        
        
        Button {
          print("작성 버튼")
        } label: {
          Text("감상평 작성").frame(width: 320, height: 42).foregroundStyle(.white).background(.blue).clipShape(RoundedRectangle(cornerRadius: 20))
        }
        
        
        Spacer()
      }
      .padding(.horizontal, 16)
      
    }
    // NavigationTitle을 사용하여 제목 표시
    .navigationTitle(movie.title)
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  DetailView(movie: MovieModel(
    id: 1,
    title: "기생충",
    posterURL: "https://image.tmdb.org/t/p/w500/k0gU48B77c4yVb6Y710H392Ua3v.jpg",
    overview: "가난한 가족이 부유한 집에 침투하면서 벌어지는 이야기",
    releaseDate: "2019-05-30"
  ))
}
