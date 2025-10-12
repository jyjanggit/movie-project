import SwiftUI

struct DetailView: View {
  
  @State var comment: String = ""
  
  var body: some View {
    VStack{
      
      HStack{
        Button(action: {
          
        }) {
          Image(systemName: "chevron.left").tint(.black)
        }
        Spacer()
        Text("파묘").font(.title2).fontWeight(.semibold)
        Spacer()
      }.padding(.horizontal)
      ScrollView{
        VStack{
          Image("Sample3").resizable().scaledToFit().padding(.vertical, 16)
          
          Text("소개글소개글소개글소개글소개글소개글소개글소개글소개글소개글소개글소개글소개글소개글소개글").font(.title2).padding(.bottom, 8)
          Text("개봉일: 2020-02-11").font(.title2)
          
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
    }
  }
}

#Preview {
  DetailView()
}
