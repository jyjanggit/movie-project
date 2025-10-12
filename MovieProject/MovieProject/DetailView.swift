import SwiftUI

struct DetailView: View {
  
  let movie: MovieModel
  @State var comment: String = ""
  
  var body: some View {
    VStack{
      ScrollView{
        VStack{
          Image("Sample3").resizable().scaledToFit().padding(.vertical, 16)
          
          Text(movie.overview).font(.title2).padding(.bottom, 8)
          Text("개봉일: \(movie.releaseDate)").font(.title2)
          
        }
        
        ZStack(alignment: .topLeading) {
          TextEditor(text: $comment)
            .padding(16)
          
          if comment.isEmpty {
            Text("감상평 내용을 입력하세요")
              .foregroundColor(.gray)
              .padding(20)
          }
          
        }
        .frame(height: 200).padding(16)
        
        
        Button {
          print("작성 버튼")
        } label: {
          Text("감상평 작성").frame(width: 320, height: 42).foregroundStyle(.white).background(.blue).clipShape(RoundedRectangle(cornerRadius: 20))
        }
        
        
        Spacer()
      }.padding(.horizontal, 16)
    }.navigationTitle(movie.title).navigationBarTitleDisplayMode(.inline)
  }
}

#Preview {
  DetailView(movie: MovieModel(id: 1, title: "기생충",
                     posterPath: "Sample3",
                     overview: "가난한 가족이 부유한 집에 침투하면서 벌어지는 이야기",
                     releaseDate: "2019-05-30"))
}
