//
//  TypePowerLogic.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 7/7/24.
//

import Foundation

@Observable
final class TypePowerLogic {
    static let sharer = TypePowerLogic()
    let interactor : TypePowerInteractor
    var typePower:[TypePowerModel]
    
    
    init(_ interactor: TypePowerInteractor = TypePowerProvider()) {
        self.interactor = interactor
        do {
            self.typePower = try  interactor.loadTypePowerData()
        } catch {
            debugPrint(error)
            self.typePower = []
        }
    }
    
    func getTypePower() async -> [ListFormString] {
        return typePower.map { item in
            ListFormString(id: item.id , name: item.poder,icono: item.icono)
        }
    }
    
    func getTypePowerIcono(poder:String) -> String {
        return typePower.first(where: (({$0.poder == poder})))?.icono ?? ""
    }
    
}



