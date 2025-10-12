import SwiftUI

struct SearchView: View {
  @State var searchText = ""
  @Binding var tabIndex: Int
  var items: [Item] = [Item(title: "기생충",
                            poster: "parasite",
                            overView: "가난한 가족이 부유한 집에 침투하면서 벌어지는 이야기",
                            releaseDate: "2019-05-30"),
                       Item(title: "인터스텔라",
                            poster: "interstellar",
                            overView: "인류의 생존을 위한 시간과 공간을 초월한 여정",
                            releaseDate: "2014-11-07"),
                       Item(title: "인셉션",
                            poster: "inception",
                            overView: "타인의 꿈에 침입해 생각을 심는 요원들의 이야기",
                            releaseDate: "2010-07-16"),
                       Item(title: "기생충",
                            poster: "parasite",
                            overView: "가난한 가족이 부유한 집에 침투하면서 벌어지는 이야기",
                            releaseDate: "2019-05-30"),
                       Item(title: "인터스텔라",
                            poster: "interstellar",
                            overView: "인류의 생존을 위한 시간과 공간을 초월한 여정",
                            releaseDate: "2014-11-07"),
                       Item(title: "기생충",
                            poster: "parasite",
                            overView: "가난한 가족이 부유한 집에 침투하면서 벌어지는 이야기",
                            releaseDate: "2019-05-30"),
                       Item(title: "인터스텔라",
                            poster: "interstellar",
                            overView: "인류의 생존을 위한 시간과 공간을 초월한 여정",
                            releaseDate: "2014-11-07")]
  
  
  struct Item: Identifiable {
    let id = UUID()
    var title: String
    var poster: String
    var overView: String
    var releaseDate: String
  }
  
  var body: some View {
    
    
    NavigationStack{
      List {
        ForEach(items) { item in
          HStack(spacing: 12) {
            Image("Sample3").resizable().frame(width: 100, height: 130)
            VStack(alignment: .leading) {
              Text(item.title).font(.title2).bold().padding(.bottom, 8)
              Text(item.overView).font(.callout).padding(.bottom, 8)
              Text("개봉일: \(item.releaseDate)").font(.callout)
            }.padding(.leading, 12)
          }.lineLimit(1)
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
          
          
        }.searchable(text: $searchText,
                     placement: .navigationBarDrawer(displayMode: .always) ,
                     prompt: "영화제목을 입력하세요")
    }
    
    
  }
}

#Preview {
  SearchView(tabIndex: .constant(0))
}
