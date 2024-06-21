//
//  CharactersListView.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 12/6/24.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI
import Combine

struct CharactersListView: View {
    @State var viewModel: CharactersListViewModel
    @State public var hiddenBackButton: Bool = true
    @State public var isShowMenuView: Bool = true
    @State public var isShowSearchView: Bool = false
    @State private var searchText = ""
    
    init() {
        let viewModel = CharactersListViewModel()
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
                    }
                }
                
                
                if isShowMenuView {
                    menuBody
                        .transition(.move(edge: .trailing))
                }
                
                NavigationStack {
                    
                }
                
                if viewModel.isLoading {
                    LoadingProgressView()
                }
            }
        }.toolbar {
            
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
        .task {
            if viewModel.charactersList.count == 0 {
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
    CharactersListView()
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
                Spacer()

            }
            .frame(minWidth: 0, maxWidth: 60, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .trailing)
    }
}

struct CharactersContainerListView: View {
    @Environment(CharactersListViewModel.self) var viewModel
    @State var id : CharactersListResponse.ID?
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(viewModel.charactersList){ index in
                        
                        NavigationLink(destination: CharactersDetailsView(idCharacter: index.id)  ) {
                            CharactersCellView(model: index)
                                .onAppear{
                                    if viewModel.isMoreDataChager {
                                        if viewModel.charactersList.last?.id == index.id  {
                                            viewModel.moreDataListCharacters()
                                        }
                                    }
                                }
                                .id(index.id)
                                .scrollTransition { content, phase in
                                    content.scaleEffect(phase.isIdentity ? 1.0: 0.8)
                                }
                        }
                    }
                }.onChange(of: viewModel.isScrollTop) { oldState, newState in                    withAnimation {
                    id = viewModel.charactersList.first?.id
                }
                }
                .safeAreaPadding(.vertical)
                .scrollTargetLayout()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .scrollPosition(id: $id)
            
            ZStack(alignment: .bottomTrailing) {
                Button {
                    id = viewModel.charactersList.first?.id
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
    var model:CharactersListResponse
    
    var body: some View {
        HStack(spacing: 20){
            WebImage(url: URL(string: model.thumbnail?.getTThumbnailUrl ?? "")) { image in
                image
                    .resizable()
            } placeholder: {
                Image(.marvelDefault)
                    .resizable()
            }
             .frame(width: 150)
             .clipShape(.rect(cornerRadius: 10))
           
            
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
    var body: some View {
        VStack {
            Text("me gusta")
                .foregroundColor(.marvelRed)
                .font(.system(size: 12))
                .background(Color.white)
                .padding(.all,8)
            
            ScrollView {
                Image(systemName: "star")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .padding(.all,10)
                    .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                
                Image(systemName: "star")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .padding(.all,10)
                    .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                
                Image(systemName: "star")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .padding(.all,10)
                    .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
            }.frame(height: 170)
            
        }
    }
}

struct MenuStoryView: View {
    var body: some View {
        VStack {
            Text("last")
                .foregroundColor(.marvelRed)
                .font(.system(size: 12))
                .background(Color.white)
                .padding(.all,8)
            
            
            Image(systemName: "clock.fill")
                .resizable()
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .padding(.all,10)
                .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
            
            Image(systemName: "clock.fill")
                .resizable()
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .padding(.all,10)
                .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
            
            Image(systemName: "clock.fill")
                .resizable()
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .padding(.all,10)
                .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
        }
    }
}
