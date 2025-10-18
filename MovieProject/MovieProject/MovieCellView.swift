import SwiftUI

struct MovieCellView: View {
  let movie: MovieModel
  
  var body: some View {
    HStack(spacing: 12) {
      
      AsyncImage(url: URL(string: movie.posterURL)) { phase in
        switch phase {
        case .success(let image):
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
        case .failure:
          Image(systemName: "photo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(.gray)
        case .empty:
          ProgressView()
        @unknown default:
          EmptyView()
        }
      }
      .frame(width: 100, height: 130)
      .clipped()
      
      
      VStack(alignment: .leading) {
        Text(movie.title).font(.title2).bold().padding(.bottom, 8)
        Text(movie.overview)
          .font(.callout)
          .padding(.bottom, 8)
          .lineLimit(3)
        Text("개봉일: \(movie.releaseDate)").font(.callout)
      }
      .padding(.leading, 12)
    }
  }
}
