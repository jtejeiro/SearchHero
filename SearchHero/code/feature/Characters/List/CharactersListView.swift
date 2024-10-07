//
//  CharactersListView.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 12/6/24.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI
import SwiftData

struct CharactersListView: View {
    @State var viewModel: CharactersListViewModel
    @State public var hiddenBackButton: Bool = true
    @State public var isShowMenuView: Bool = false
    @State public var isShowSearchView: Bool = false
    @State private var searchText = ""
    
    init(_ viewModel: CharactersListViewModel = CharactersListViewModel()) {
        self._viewModel =  State(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavegationBarView(hiddenBackButton: $hiddenBackButton) {
            ZStack(alignment: .top) {
                
                HeroBackgroundView()
                
                VStack(spacing: 5) {
                    
                    if isShowSearchView {
                        SearchBar(text: $searchText, isShowSearchView: $isShowSearchView)
                            .environment(viewModel)

                    }
                    if viewModel.processState == .emptyDisplay {
                        empyBody
                    } else {
                        contenBody
                            .onAppear{
                                viewModel.isDisplayView = true
                            }
                            .onDisappear{
                                viewModel.isDisplayView = false
                            }
                    }
                }
                
                
                if isShowMenuView {
                    menuBody
                        .transition(.move(edge: .trailing))
                }
                
                
                if viewModel.isLoading {
                    LoadingProgressView()
                }
            }
        }.toolbar {
            
            if viewModel.isDisplayView {
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        if isShowSearchView {
                            viewModel.resetDataListCharacters()
                        }
                        self.isShowSearchView.toggle()
                        if isShowMenuView{
                            isShowMenuView = false
                        }
                    }) {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .resizable()
                            .renderingMode(.template)
                            .colorMultiply(.white)
                            .accentColor(.white)
                            .aspectRatio(contentMode: .fit)
                            .tint(.white)
                            .frame(width: 30, height: 30)
                        
                    }
                }
            }
            if viewModel.isDisplayView {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        self.isShowMenuView.toggle()
                        if  isShowSearchView{
                            isShowSearchView = false
                        }
                    }) {
                        Image("filtre")
                            .resizable()
                            .renderingMode(.template)
                            .colorMultiply(.white)
                            .accentColor(.white)
                            .aspectRatio(contentMode: .fit)
                            .tint(.white)
                            .frame(width: 30, height: 30)
                        
                    }
                }
            }
            
        }
        .task {
            if viewModel.listCharactersLogic.charactersList.count == 0 {
                do {
                    await viewModel.fechlistCharactersData()
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
        CharactersContainerListView()
            .environment(viewModel)
            .environment(viewModel.listCharactersLogic)
    }
    
    var empyBody: some View {
        EmptyView()
    }
    
    var menuBody: some View {
       MenuView()
            .environment(viewModel)
    }

}

#Preview {
    CharactersListView(CharactersListViewModel(listCharactersLogic: ListCharactersLogic(ListCharactersMock())))
}

struct MenuView: View {
    @Environment(CharactersListViewModel.self) var viewModel
    
    var body: some View {
        ZStack(alignment:.topTrailing) {
            Color.marvelRed
                .ignoresSafeArea()
                .frame(width: 60)
                .shadow(radius: 5)
            
            VStack{
                MenuFavoriteView()
                    .environment(viewModel.charactersFavoriteLogic)
                    
                
                Spacer()
                
                Text("orden")
                    .foregroundColor(.marvelRed)
                    .font(.system(size: 12))
                    .background(Color.white)
                    .padding(.all,8)
                Button(action: {
                    viewModel.orderByNamelistCharacters()
                }) {
                    Image(systemName: "character.book.closed.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                        .padding(.all,10)
                }
                
                Button(action: {
                    viewModel.OrderByModifiedListCharacters()
                }) {
                    Image(systemName: "calendar.circle")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                        .padding(.all,10)
                }
                
                Spacer()
                MenuStoryView()
                    .environment(viewModel.charactersReadLogic)
                Spacer()

            }
            .background(Color.marvelRed)
            .frame(minWidth: 0, maxWidth: 60, minHeight: 0, maxHeight: .infinity, alignment: .top)
            .padding(.top,10)
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .trailing)
    }
}

struct CharactersContainerListView: View {
    @Environment(CharactersListViewModel.self) var viewModel
    @Environment(ListCharactersLogic.self) var logic
    @State var id : CharactersListResponse.ID?
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(logic.charactersList){ index in
                        
                        NavigationLink(destination: CharactersDetailsView(idCharacter: index.id)) {
                            CharactersCellView(model: index)
                                .onAppear{
                                    if viewModel.isMoreDataChager {
                                        if logic.charactersList.last?.id == index.id  {
                                            viewModel.moreDataListCharacters()
                                        }
                                    }
                                }
                                .id(index.id)
                                .scrollTransition { content, phase in
                                    content.scaleEffect(phase.isIdentity ? 1.0: 0.8)
                                }
                                .environment(viewModel.charactersFavoriteLogic)
                                .environment(viewModel.charactersReadLogic)
                        }
                    }
                }.onChange(of: viewModel.isScrollTop) { oldState, newState in                    withAnimation {
                    id = logic.charactersList.first?.id
                }
                }
                .safeAreaPadding(.vertical)
                .scrollTargetLayout()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .scrollPosition(id: $id)
            
            ZStack(alignment: .bottomTrailing) {
                Button {
                    id = logic.charactersList.first?.id
                } label: {
                    Image(systemName: "arrowshape.up.circle")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30,alignment: .trailing)
                        .padding(.all,20)
                        .opacity(0.2)
                        .hoverEffect(/*@START_MENU_TOKEN@*/.automatic/*@END_MENU_TOKEN@*/)
                        .shadow(radius: 20)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
    }
    
}


struct CharactersCellView: View {
    @Environment(CharactersFavoriteLogic.self) var logic
    @Environment(CharactersReadLogic.self) var readlogic
    var model:CharactersListResponse
    @State var isFavorite:Bool = false
    @State var isRead:Bool = false
    
    var body: some View {
        HStack(spacing: 20){
            ZStack(alignment: .topLeading ) {
                WebImage(url: URL(string: model.thumbnail?.getTThumbnailUrl ?? "")) { image in
                    image
                        .resizable()
                } placeholder: {
                    Image(.marvelDefault)
                        .resizable()
                }
                .frame(width: 150)
                .clipShape(.rect(cornerRadius: 10))
                VStack {
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
                        }
                        .onAppear{
                            self.isFavorite = logic.isFavoriteCharaCharacters(id: model.id)
                        }
                        .onChange(of: logic.charactersSavedList.count) { oldValue, newValue in
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
                            .frame(width: 20, height: 20)
                            .padding(.all,10)
                            .opacity(self.isRead ? 0.8:0.4)
                    }.onAppear{
                        self.isRead = readlogic.isReadCharaCharacters(id: model.id)
                    }
                    .onChange(of: self.readlogic.charactersReadList.count) { oldValue, newValue in
                        self.isRead = readlogic.isReadCharaCharacters(id: model.id)
                    }
                }
                
            }
            
            VStack(alignment: .leading) {
                Text(model.name)
                    .font(.title2)
                    .foregroundStyle(.white)
                    .hoverEffect(.lift)
                    .frame(alignment: .leading)
                    .padding(.bottom,5)
                Text(model.getModifiedString)
                    .font(.callout)
                    .foregroundStyle(.white)
                    .frame(alignment: .leading)
                Spacer()
                Text(model.resultDescription)
                    .font(.caption)
                    .foregroundStyle(.white)
                    .frame(height: 50,alignment: .leading)
                Spacer()
            }
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/,maxWidth: .infinity,alignment: .leading)
            .padding(.vertical,10)
            Spacer()
        }
        .frame(height: 150)
        .background(.white.opacity(0.2))
        .cornerRadius(10)
        .shadow(radius: 20)
        .padding(.all,20)
        .onAppear{
            readlogic.getCharacterSavedDataModel()
        }
        
    }
    
}

struct SearchBar: View {
    @Environment(CharactersListViewModel.self) var viewModel
    @Binding var text: String
    @Binding var isShowSearchView: Bool

    @State private var isEditing = false
    @State private var searchWorkItem: DispatchWorkItem?


    var body: some View {
        VStack {
            Spacer().frame(height: 5)
            HStack {
                TextField("Search ...", text: $text)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        self.isEditing = true
                    }.onChange(of: text) { oldValue, newValue in
                        
                        searchWorkItem?.cancel()
                        let newSearchWorkItem = DispatchWorkItem {
                            
                            if !viewModel.searchData {
                                viewModel.searchDataListCharacters(nameStartsWith: text.lowercased())
                            }
                        }
                        // Asignar la nueva tarea de búsqueda
                        searchWorkItem = newSearchWorkItem
                        
                        // Ejecutar la tarea de búsqueda después de 0.5 segundos
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: newSearchWorkItem)
                    }
                
                if isEditing {
                    Button(action: {
                        self.isEditing = false
                        self.isShowSearchView.toggle()
                        self.viewModel.resetDataListCharacters()
                        self.text = viewModel.searchText
                    }) {
                        Text("Cancel")
                            .foregroundStyle(.white)
                    }
                    .padding(.trailing, 10)
                    .transition(.move(edge: .trailing))
                    .animation(.easeInOut(duration: 1.0), value: UUID())
                }
            }
            Spacer().frame(height: 10)
        }
        .background(Color.marvelRed)
        .onAppear {
            self.text = viewModel.searchText
        }
    }
}

struct MenuFavoriteView: View {
    @Environment(CharactersFavoriteLogic.self) var logic
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 5.0)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .overlay {
                    Image(systemName: "star.fill")
                        .resizable()
                        .foregroundColor(.marvelRed)
                        .frame(width: 20, height: 20)
                        .padding(.all,10)
                }
            
            
                if !logic.charactersSavedList.isEmpty  {
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(logic.charactersSavedList.reversed()) { index in
                            NavigationLink(destination: CharactersDetailsView(idCharacter: index.id)  ) {
                                WebImage(url: URL(string: index.url)) { image in
                                    image
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .padding(.all,10)
                                        .clipShape(RoundedRectangle(cornerRadius: 5.0))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 5.0)
                                                .stroke(lineWidth: 2.0)
                                                .foregroundColor(.white)
                                                .frame(width: 30, height: 30)
                                        }
                                        .gesture(DragGesture().onEnded{ _ in
                                            logic.removeIdFavoriteCharaCharacters(id: index.id)
                                        })
                                } placeholder: {
                                    Image(systemName: "star")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .frame(width: 20, height: 20)
                                        .padding(.all,10)
                                        .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 5.0)
                                                .stroke(lineWidth: 2.0)
                                                .foregroundColor(.white)
                                                .frame(width: 30, height: 30)
                                        }
                                }
                            }
                        }
                    }.frame(width: 40)
                }  else {
                    Image(systemName: "star")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                        .padding(.all,10)
                        .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5.0)
                                .stroke(lineWidth: 2.0)
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                        }
                }
        }.frame(width: 40,height: 200,alignment: .top)
    }
}

struct MenuStoryView: View {
    @Environment(CharactersReadLogic.self) var logic
    
    var body: some View {
        VStack {
            
            RoundedRectangle(cornerRadius: 5.0)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .overlay {
                    Image(systemName: "bookmark.circle.fill")
                        .resizable()
                        .foregroundColor(.marvelRed)
                        .frame(width: 20, height: 20)
                        .padding(.all,10)
                }
            
            ScrollView {
                if !logic.charactersReadList.isEmpty {
                    ForEach(logic.charactersReadList.reversed()) { index in
                        NavigationLink(destination: CharactersDetailsView(idCharacter: index.id)) {
                            WebImage(url: URL(string: index.url)) { image in
                                image
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .padding(.all,10)
                                    .clipShape(RoundedRectangle(cornerRadius: 5.0))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 5.0)
                                            .stroke(lineWidth: 2.0)
                                            .foregroundColor(.white)
                                            .frame(width: 30, height: 30)
                                    }.gesture(DragGesture().onEnded{ _ in
                                        logic.removeIdReadCharaCharacters(id: index.id)
                                    })
                            } placeholder: {
                                Image(systemName: "bookmark.circle.fill")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20)
                                    .padding(.all,10)
                                    .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/).overlay {
                                        RoundedRectangle(cornerRadius: 5.0)
                                            .stroke(lineWidth: 2.0)
                                            .foregroundColor(.white)
                                            .frame(width: 30, height: 30)
                                    }
                                
                            }
                        }
                    }
                }  else {
                    Image(systemName: "bookmark.circle.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                        .padding(.all,10)
                        .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/).overlay {
                            RoundedRectangle(cornerRadius: 5.0)
                                .stroke(lineWidth: 2.0)
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                        }
                }
            }
            .frame(width: 40,height: 170,alignment: .top)
        }.onAppear{
           logic.getCharacterSavedDataModel()
        }

    }
}
