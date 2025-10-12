//
//  MovieCellView.swift
//  MovieProject
//
//  Created by JY Jang on 10/12/25.
//

import SwiftUI

struct MovieCellView: View {
  let movie: MovieModel
  
  var body: some View {
    HStack(spacing: 12) {
      Image(movie.posterPath).resizable().frame(width: 100, height: 130)
      VStack(alignment: .leading) {
        Text(movie.title).font(.title2).bold().padding(.bottom, 8)
        Text(movie.overview).font(.callout).padding(.bottom, 8)
        Text("개봉일: \(movie.releaseDate)").font(.callout)
      }.padding(.leading, 12)
    }.padding(12).lineLimit(1)
  }
}

#Preview {
  MovieCellView(movie: MovieModel(id: 1, title: "파묘", posterPath: "poster", overview: "ddd", releaseDate: "2023-11-11"))
}
