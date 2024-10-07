//
//  FavoriteCharactersView.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 28/6/24.
//

import SwiftUI
import SDWebImageSwiftUI

struct FavoriteCharactersView: View {
    @State var viewModel: FavoriteCharactersViewModel
    @State public var hiddenBackButton: Bool = true
    @State public var isShowSearchView: Bool = false
    @State private var searchText = ""
    
    init() {
        let viewModel = FavoriteCharactersViewModel()
        self._viewModel =  State(wrappedValue: viewModel)
    }
    
    var body: some View {
//        NavegationBarView(hiddenBackButton: $hiddenBackButton) {
            ZStack(alignment: .top) {
                HeroBackgroundView()
                
                VStack(spacing: 5) {
                    
                    if viewModel.processState == .emptyDisplay {
                        empyBody
                    } else {
                        contenBody
                    }
                }
                
                
                if viewModel.isLoading {
                    LoadingProgressView()
                }
            }
//        }
        .task {
                do {
                    await viewModel.fechFavoriteData()
                }
        }
        .alert(isPresented: $viewModel.isAlertbox) {
            Alert(
                title: Text(viewModel.alertTitle),
                message: Text(viewModel.alertMessage),
                dismissButton: .cancel(Text(viewModel.alertButton)))
        }
    }
    
    var contenBody: some View {
        let logic = viewModel.favoriteLogic
        return FavoriteContainView()
            .environment(logic)
    }
    
    var empyBody: some View {
        EmptyView()
    }
    

}

#Preview {
    FavoriteCharactersView()
}


struct FavoriteContainView: View {
    @Environment(CharactersFavoriteLogic.self) var logic
    
    let columns = [
            GridItem(.adaptive(minimum: 90))
        ]
    
    var body: some View {
        Spacer()
        ScrollView {
            Text("FAVORITE")
                .font(.title)
                .foregroundStyle(.white)
            
            Spacer()
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(logic.charactersSavedList.reversed()) { index in
                    NavigationLink(destination: CharactersDetailsView(idCharacter: index.id)) {
                        FavoriteCellView(model: index)
                            .gesture(DragGesture().onEnded{ _ in
                                withAnimation {
                                    logic.removeIdFavoriteCharaCharacters(id: index.id)
                                }
                            })
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
    
struct FavoriteCellView: View {
    let model: CharacterSavedModel
    
    var body: some View {
        VStack(spacing: 0) {
            WebImage(url: URL(string: model.url)) { image in
                image
                    .resizable()
                
            } placeholder: {
                RoundedRectangle(cornerRadius: 5.0)
                    .foregroundColor(.white)
                    .frame(width: 90, height: 90)
                    .opacity(0.4)
                    .overlay {
                        Image(systemName: "book.circle")
                            .resizable()
                            .foregroundColor(.gray)
                            .frame(width: 60, height: 60, alignment: .center)
                    }
            }
            .frame(width: 90,height: 90)
            .padding(.all,10)
            
            Text(model.name)
                .font(.caption)
                .foregroundStyle(.white)
                .frame(height: 50)
                .padding(.all,10)
        }
        .background {
            RoundedRectangle(cornerRadius: 5.0)
                .foregroundColor(.white.opacity(0.2))
        }
    }
}
