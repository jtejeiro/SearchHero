//
//  ReadCharactersView.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 1/7/24.
//

import SwiftUI
import SDWebImageSwiftUI
import SwiftData


struct ReadCharactersView: View {
    @State var viewModel: ReadCharactersViewModel
    @State public var hiddenBackButton: Bool = true
    @State public var isShowSearchView: Bool = false
    @State private var searchText = ""
    
    init() {
        let viewModel = ReadCharactersViewModel()
        self._viewModel =  State(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavegationBarView(hiddenBackButton: $hiddenBackButton) {
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
        }
        .toolbar {
            
        }
        .task {
                do {
                    await viewModel.fechReadData()
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
        ReadContainView()
            .environment(viewModel.readLogic)
    }
    
    var empyBody: some View {
        EmptyView()
    }
    

}

#Preview {
    ReadCharactersView()
}


struct ReadContainView: View {
    @Environment(CharactersReadLogic.self) var logic
    
    let columns = [
            GridItem(.adaptive(minimum: 90))
        ]
    
    var body: some View {
        Spacer()
        ScrollView {
            if !logic.charactersReadList.isEmpty {
                Text("READ")
                    .font(.title)
                    .foregroundStyle(.white)
                
                Spacer()
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(logic.charactersReadList.reversed()) { index in
                        NavigationLink(destination: CharactersDetailsView(idCharacter: index.id)) {
                           ReadCellView(model: index)
                                .gesture(DragGesture().onEnded{ _ in
                                    withAnimation {
                                        logic.removeIdReadCharaCharacters(id: index.id)
                                    }
                                })
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear{
           logic.getCharacterSavedDataModel()
        }
    }
}
    
struct ReadCellView: View {
    let model: CharacterSavedDataModel
    
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
