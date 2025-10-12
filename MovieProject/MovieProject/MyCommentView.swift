import SwiftUI

struct MyCommentView: View {
  
  var items: [Item] = [Item(title: "케이팝데몬헌터스",
                            comment: "재미있는 영화였다 어쩌구 저쩌구 줄이 길게 나올때는 이렇게 된다"),
                       Item(title: "케이팝데몬헌터스",
                            comment: "재미있는 영화였다 어쩌구 저쩌구 줄이 길게 나올때는 이렇게 된다"),
                       Item(title: "케이팝데몬헌터스",
                            comment: "재미있는 영화였다 어쩌구 저쩌구 줄이 길게 나올때는 이렇게 된다재미있는 영화였다 어쩌구 저쩌구 줄이 길게 나올때는 이렇게 된다재미있는 영화였다 어쩌구 저쩌구 줄이 길게 나올때는 이렇게 된다재미있는 영화였다 어쩌구 저쩌구 줄이 길게 나올때는 이렇게 된다"),
                       Item(title: "케이팝데몬헌터스",
                            comment: "재미있는 영화였다 어쩌구 저쩌구 줄이 길게 나올때는 이렇게 된다"),
                       Item(title: "케이팝데몬헌터스",
                            comment: "재미있는 영화였다 어쩌구 저쩌구 줄이 길게 나올때는 이렇게 된다재미있는 영화였다 어쩌구 저쩌구 줄이 길게 나올때는 이렇게 된다재미있는 영화였다 어쩌구 저쩌구 줄이 길게 나올때는 이렇게 된다재미있는 영화였다 어쩌구 저쩌구 줄이 길게 나올때는 이렇게 된다"),
                       Item(title: "케이팝데몬헌터스",
                            comment: "재미있는 영화였다 어쩌구 저쩌구 줄이 길게 나올때는 이렇게 된다"),
  ]
  
  
  struct Item: Identifiable {
    let id = UUID()
    var title: String
    var comment: String
  }
  
  var body: some View {
    NavigationStack{
      List {
        ForEach(items) { item in
          HStack(spacing: 12) {
            VStack(alignment: .leading) {
              Text(item.title).font(.title2).bold().padding(.bottom, 8)
              Text(item.comment).font(.callout).padding(.bottom, 8)
            }.padding(.horizontal, 12)
          }
        }
      }.listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .principal) {
            VStack(spacing: 0) {
              Text("나의 감상평").font(.system(size: 24, weight: .bold))
                .minimumScaleFactor(0.9)
            }
          }
          
          
        }
    }
    
  }
}

#Preview {
  MyCommentView()
}
