//
//  CharactersDetailsView.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 13/6/24.
//

import SwiftUI
import SDWebImageSwiftUI
import SwiftData

struct CharactersDetailsView: View {
    @State var viewModel: CharactersDetailsViewModel
    @State public var hiddenBackButton: Bool = false
    
    init(idCharacter: Int) {
        let viewModel = CharactersDetailsViewModel(idCharacter: idCharacter)
        self._viewModel =  State(wrappedValue: viewModel)
    }
    
    
    var body: some View {
        
        NavegationBarView(hiddenBackButton: $hiddenBackButton) {
            ZStack {
                
                HeroBackgroundView()
                
                if viewModel.processState == .emptyDisplay {
                    empyBody
                } else {
                    contenBody
                }
                
                if viewModel.isLoading {
                    LoadingProgressView()
                }
            }
            .task {
                do {
                    await viewModel.fechCharactersData()
                }
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
        ScrollView {
            VStack(alignment: .center,spacing: 0) {
                if let model = viewModel.charactersData {
                    CharactersDetailsHeadView(model: model)
                        .environment(viewModel.charactersFavoriteLogic)
                        .environment(viewModel.charactersReadLogic)
                        .onAppear{
                            Task {
                                await  viewModel.charactersReadLogic.savedReadCharaCharacters(model: model)
                            }
                        }
                }
                ZStack {
                    Color
                        .marvelRed
                    Text(viewModel.charactersData?.name ?? "Heroe")
                        .font(.title)
                        .foregroundStyle(.white)
                }
               
                VStack(alignment: .center,spacing: 20) {
                    Spacer()
                Text(viewModel.charactersData?.getModifiedString ?? "")
                    .font(.callout)
                    .foregroundStyle(.white)
                Text(viewModel.charactersData?.resultDescription ?? "" )
                    .font(.body)
                    .foregroundStyle(.white)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                .padding(.all,20)
                
                
                ExtraInfoView()
                    .environment(viewModel)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        }
    }
    
    var empyBody: some View {
        EmptyView()
    }
}

#Preview {
    CharactersDetailsView(idCharacter: 1017100)
}

struct ListComicsView: View {
    @Environment(CharactersDetailsViewModel.self) var viewModel
    
    
    var body: some View {
        if let listComics = viewModel.charactersData?.comics?.items, listComics.count != 0 {
            VStack(spacing: 20) {
                Text("Comics")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal,40)
                    .background(.marvelRed)
                Spacer()
                ScrollView(.horizontal) {
                    HStack(alignment: .center, spacing: 30) {
            
                        ForEach(0..<(viewModel.ComicsList?.count ?? listComics.count), id: \.self){ index in
                            let cell = listComics[index]
                            VStack(alignment: .center) {
                                let urlString = viewModel.ComicsList?[index].images?.first?.getTThumbnailUrl
                                WebImage(url: URL(string: urlString ?? "")) { image in
                                    image
                                        .resizable()
                                   
                                } placeholder: {
                                    RoundedRectangle(cornerRadius: 5.0)
                                        .foregroundColor(.white)
                                        .frame(width: 90, height: 140)
                                        .opacity(0.4)
                                        .overlay {
                                            Image(systemName: "book.circle")
                                                .resizable()
                                                .foregroundColor(.gray)
                                                .frame(width: 60, height: 60, alignment: .center)
                                        }
                                }
                                .frame(width: 90,height: 140)
                                .padding(.all,10)
                                    
                                Text(cell.name ?? "")
                                    .font(.caption2)
                                    .foregroundStyle(.white)
                                    .frame(width: 90, height: 80, alignment: .center)
                                
                            }
                            .background(.white.opacity(0.2))
                            .cornerRadius(10)
                            .shadow(radius: 20)
                            .frame(width: 100, height: 300, alignment: .center)
                            .scrollTransition { content, phase in
                                content.scaleEffect(phase.isIdentity ? 1.0: 0.8)
                            }
                        }
                    }
                    .safeAreaPadding(.horizontal)
                }
                .scrollDisabled(listComics.count < 4 ? true:false)
            }.onAppear {
                Task {
                    do {
                        await viewModel.fechComicsListData()
                    }
                }
            }
        }
    }
}

struct ListUrlView: View {
    @Environment(CharactersDetailsViewModel.self) var viewModel
    
    
    var body: some View {
        if let listUrl = viewModel.charactersData?.urls {
            VStack(spacing: 20) {
                Text("URL")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal,40)
                    .background(.marvelRed)
                Spacer()
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 30) {
                        ForEach(0..<listUrl.count, id: \.self){ index in
                            let cell = listUrl[index]
                            NavigationLink(destination: WebViewUI(uRLString: cell.url ?? ""))
                            {
                                VStack(alignment: .center) {
                                    Image(systemName: "link.circle.fill")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .frame(width: 30,height: 30)
                                    Text(cell.type)
                                        .font(.caption)
                                        .foregroundStyle(.white)
                                        .padding(.all,10)
                                }
                                .frame(width: 100, height: 100, alignment: .center)
                                .background(.white.opacity(0.2))
                                .cornerRadius(10)
                                .shadow(radius: 20)
                                
                                
                            }
                        }
                    }
                    .padding(.horizontal,20)
                }
                .scrollDisabled(listUrl.count < 4 ? true:false)
            }
            Spacer()
        }
    }
}

struct CharactersDetailsHeadView: View {
    @Environment(CharactersFavoriteLogic.self) var logic
    @Environment(CharactersReadLogic.self) var readlogic
    var model:CharactersListResponse
    @State var isFavorite:Bool = false
    @State var isRead:Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            HStack {
                Button {
                    self.isFavorite.toggle()
                    self.logic.savedFavoriteCharaCharacters(model: model)
                } label: {
                    Image(systemName: "star.fill")
                        .resizable()
                        .foregroundColor(self.isFavorite ? .yellow:.white)
                        .frame(width: 20, height: 20)
                        .padding(.all,10)
                        .opacity(self.isFavorite ? 1.0:0.5)
                }.onAppear{
                    self.isFavorite = logic.isFavoriteCharaCharacters(id: model.id)
                }
            }
            let urlImage = model.thumbnail?.getTThumbnailUrl ?? ""
            WebImage(url: URL(string: urlImage)) { image in
                image
                    .resizable()
                
            } placeholder: {
                Image(.marvelDefault)
                    .resizable()
            }
            .frame(height: 350)
            
            HStack {
                Button {
                    self.isFavorite.toggle()
                    self.logic.savedFavoriteCharaCharacters(model: model)
                } label: {
                    Image(systemName: "star.fill")
                        .resizable()
                        .foregroundColor(self.isFavorite ? .yellow:.white)
                        .frame(width: 30, height: 30)
                        .padding(.all,10)
                        .opacity(self.isFavorite ? 1.0:0.5)
                }.onAppear{
                    self.isFavorite = logic.isFavoriteCharaCharacters(id: model.id)
                }
                
                Spacer()
                
                Button {
                    isRead.toggle()
                    self.readlogic.clickSavedReadCharaCharacters(model: model)
                    debugPrint(model.id)
                } label: {
                    Image(systemName: "bookmark.circle.fill")
                        .resizable()
                        .foregroundColor(self.isRead ? .blue:.white)
                        .frame(width: 30, height: 30)
                        .padding(.all,10)
                        .opacity(self.isRead ? 0.8:0.4)
                }.onAppear{
                    readlogic.getCharacterSavedDataModel()
                    self.isRead = readlogic.isReadCharaCharacters(id: model.id)
                }
            }.padding(.all, 10)
            
        }
    }
    
}

struct ExtraInfoView: View {
    @Environment(CharactersDetailsViewModel.self) var viewModel
    
    var body: some View {
        VStack(spacing:20) {
            Spacer()
            ListComicsView()
                .environment(viewModel)
            Spacer()
            ListUrlView()
                .environment(viewModel)
        }
    }
}
