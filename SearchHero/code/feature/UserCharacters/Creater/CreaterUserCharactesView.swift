//
//  CreaterUserCharactesView.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 1/7/24.
//

import SwiftUI

struct CreaterUserCharactesView: View {
    @State var viewModel: CreaterUserCharactesViewModel
    @State public var hiddenBackButton: Bool = true
    
    init() {
        let viewModel = CreaterUserCharactesViewModel()
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
                            .onAppear{
                                viewModel.isDisplayView = true
                            }
                            .onDisappear{
                                viewModel.isDisplayView = false
                                viewModel.removeCharacteristicsList()
                            }
                    }
                }
                
                
                
                if viewModel.isLoading {
                    LoadingProgressView()
                }
            }
        }
        .toolbar {
            
            if viewModel.isDisplayView {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        viewModel.fechSaveData()
                    }) {
                        Image(systemName: "person.crop.rectangle.badge.plus.fill")
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
        .alert(isPresented: $viewModel.isAlertbox) {
            Alert(
                title: Text(viewModel.alertTitle),
                message: Text(viewModel.alertMessage),
                dismissButton: .cancel(Text(viewModel.alertButton)))
        }.onAppear{
            viewModel.configViewModel()
        }
    }
    
    var contenBody: some View {
        VStack {
            ScrollView {
                CreaterUserListView()
                    .environment(viewModel)
                
                CreaterUserHeaderView()
                CreaterUserFormView()
                    .environment(viewModel)
                    .onAppear{
                        Task {
                            do {
                                await viewModel.userCharactersLogic.getUserCharactersModel()
                            }
                        }
                    }
            }
        }
    }
    
    var empyBody: some View {
        EmptyView()
    }
    

}


#Preview {
    CreaterUserCharactesView()
}

struct CreaterUserHeaderView: View {
    var body: some View {
        VStack(alignment: .center,spacing: 0) {
            //headerPhoto
            
            ZStack(alignment: .center) {
                Color
                    .marvelRed
                Text("create a hero")
                    .font(.title)
                    .foregroundStyle(.white)
                    .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
            }.frame(height: 50)
        }
    }
    
    var headerPhoto: some View {
        Button {
            
        } label: {
            ZStack(alignment: .center) {
                Color.gray.opacity(0.5)
                Circle()
                    .fill(Color.gray.opacity(0.6))
                    .frame(width: 105,height: 105,alignment: .center)
                    .overlay {
                        Image(systemName: "person.crop.square.badge.camera.fill")
                            .resizable()
                            .frame(width: 45,height: 40,alignment: .center)
                            .foregroundStyle(.white)
                            .padding(.leading,10)
                            .padding(.top,5)
                    }
            }
        }.frame(height: 140)
    }
    
    
}


struct CreaterUserListView: View {
    @Environment(CreaterUserCharactesViewModel.self) var viewModel
    
    var body: some View {
        let userList = viewModel.userCharactersLogic.userCharactersModel
        if userList.count != 0 {
            VStack(alignment: .center,spacing: 10) {
                header
                
                ZStack(alignment: .center) {
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(userList) { index in
                                CreaterUserCellView(model: index)
                                    .environment(viewModel.typePowerLogic)
                                    .onLongPressGesture {
                                        withAnimation {
                                            viewModel.userCharactersLogic.removeIdUserCharactersModel(id: index.id)
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal,10)
                        .frame(height: 140)
                    }
                }
            }
        }
    }
    
    var header: some View {
        ZStack(alignment: .center) {
            Color
                .mavelGray
            
            Text("New a hero")
                .font(.title)
                .foregroundStyle(.white)
                .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
        }.frame(height: 50)
    }
        
    
    
}

struct CreaterUserCellView: View {
    @Environment(TypePowerLogic.self) var typePower
    let model:UserCharactersModel
    @State var isClick:Bool = false
    
    var body: some View {
        HStack{
            Text(typePower.getTypePowerIcono(poder: model.typePower))
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .frame(width: 62,height: 100)
            VStack(alignment: .leading) {
                Spacer()
                Text(model.heroName)
                    .font(.title2)
                    .foregroundStyle(Color.white)
                Spacer()
                Text(model.originalName)
                    .font(.caption)
                    .foregroundStyle(Color.white)
                
                Text(model.cityDefeder)
                    .font(.caption)
                    .foregroundStyle(Color.white)
                Spacer()
            }
            .frame(width: 105,height: 100,alignment: .leading)
        }
        .padding(.all,5)
        .background {
            RoundedRectangle(cornerRadius: 5.0)
                .foregroundColor(.white.opacity(self.isClick ? 1.0:0.2))
        }.simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    withAnimation {
                        self.isClick.toggle()
                    }
                    self.isClick.toggle()
                })
    }
}

struct CreaterUserFormView: View {
    @Environment(CreaterUserCharactesViewModel.self) var viewModel
    
    var body: some View {
        FormContentView(titleBox: "Characteristics") {
            VStack(spacing: 20) {
                FormDataTextCamp()
                    .environmentObject(viewModel.getCharacteristicsList(.heroName))
                FormDataTextCamp()
                    .environmentObject(viewModel.getCharacteristicsList(.originalName))
                FormSpinnerCamp()
                    .environmentObject(viewModel.getCharacteristicsList(.cityDefeder))
                FormGridCamp()
                    .environmentObject(viewModel.getCharacteristicsList(.typePower))
                Spacer()
            }
        }
    }
}
