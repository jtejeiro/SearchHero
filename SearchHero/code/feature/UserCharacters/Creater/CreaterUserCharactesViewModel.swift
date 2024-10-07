//
//  CreaterUserCharactesViewModel.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 1/7/24.
//

import Foundation

@Observable
final class CreaterUserCharactesViewModel:BaseViewModel {
    
    let typePowerLogic : TypePowerLogic
    let countriesLogic : CountriesLogic
    let userCharactersLogic : UserCharactersLogic
    var isDisplayView:Bool = false
    
    var characteristicsList: [FormDataModel]  = []
    
    init(countriesLogic: CountriesLogic = CountriesLogic.sharer,userCharactersLogic : UserCharactersLogic = UserCharactersLogic.sharer,typePowerLogic : TypePowerLogic = TypePowerLogic.sharer ) {
        self.countriesLogic = countriesLogic
        self.userCharactersLogic = userCharactersLogic
        self.typePowerLogic = typePowerLogic
    }

    // MARK: - Config
    func configViewModel() {
        Task {
            do {
                await setCharacteristicsList()
            }
        }
    }
    
    // MARK: - Set Data
    
    private func setCharacteristicsList() async {
        if characteristicsList.count != 0 {
            return
        }
        
        characteristicsList.append(FormDataModel(id: .originalName, titleBox: "original name", isRequire: true))
        characteristicsList.append(FormDataModel(id: .heroName, titleBox: "superhero name", isRequire: true))
        await characteristicsList.append(FormDataModel(id: .cityDefeder, titleBox: "city ​​that defends",isRequire: true,listFormString: countriesLogic.getCountriesList()))
        await characteristicsList.append(FormDataModel(id: .typePower, titleBox: "type of power",isRequire: true,listFormString: typePowerLogic.getTypePower()))
    }
    
    func getCharacteristicsList(_ type:FormDataTypes)-> FormDataModel{
        guard let list = characteristicsList.first(where: {$0.id == type}) else {
            return FormDataModel(id: Optional.none, titleBox: "", isRequire: false)
        }
        
        return list
    }
    // MARK: - Load Data
    func loadCharacteristicsList(_ id:Int) async {
        if let userCharactersModel = userCharactersLogic.userCharactersModel.first(where: ({$0.id == id })) {
            self.getCharacteristicsList(.heroName).inputText = userCharactersModel.heroName
            self.getCharacteristicsList(.originalName).inputText = userCharactersModel.originalName
            self.getCharacteristicsList(.cityDefeder).inputText = userCharactersModel.cityDefeder
        }
    }
    
    // MARK: - Validate
    
    func ValideCharacteristicsList() async -> Bool {
        var isValidate:Bool = true
        
        characteristicsList.forEach { model in
            if !model.getValide() {
                debugPrint(model.errorMsg)
                self.displayAlertMessage(title:"Characteristics", mesg: model.errorMsg)
                isValidate = false
                return
            }
        }
        
        return isValidate
    }
    
    // MARK: - Fech Save dat
    func insertCharacteristicsList() async {
        let id = Int.random(in: 1000...9999)
        let heroName =  self.getCharacteristicsList(.heroName).inputText
        let originalName =  self.getCharacteristicsList(.originalName).inputText
        let cityDefeder = self.getCharacteristicsList(.cityDefeder).inputText
        let typePower = self.getCharacteristicsList(.typePower).inputText
        
        let userCharactersModel: UserCharactersModel = UserCharactersModel(id: id, heroName: heroName, originalName: originalName, cityDefeder: cityDefeder, typePower: typePower)
        await userCharactersLogic.insert(model: userCharactersModel)
    }
    
    @MainActor
    func fechSaveData(){
        Task {
            do {
                self.displayLoading(true)
                if await ValideCharacteristicsList() {
                    await insertCharacteristicsList()
                    removeCharacteristicsList()
                }
                self.displayLoading()
            }
        }
    }
    
    func removeCharacteristicsList(){
        DispatchQueue.main.async {
            self.characteristicsList.forEach { model in
                model.resetInputData()
            }
        }
    }
}
