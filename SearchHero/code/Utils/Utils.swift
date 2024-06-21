//
//  Utils.swift
//  SearchHero
//
//  Created by Jaime Tejeiro on 13/6/24.
//

import Foundation
import UIKit

struct Utils {
    
    static func openUrl(_ url: URL) {
        guard UIApplication.shared.canOpenURL(url) else {
            debugPrint("Can not open this url: \(url)")
            return
        }
        UIApplication.shared.open(url)
    }
    
    static func changeDateString(_ dateString: String) -> String? {
        // Formateador de la fecha de entrada
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // Convertir la cadena de fecha a objeto Date
        guard let date = inputFormatter.date(from: dateString) else {
            return nil
        }
        
        // Formateador de la fecha de salida
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMMM yyyy"
        outputFormatter.locale = Locale(identifier: "es_ES") // Configuración regional para español
        
        // Convertir el objeto Date a cadena de salida
        let formattedDateString = outputFormatter.string(from: date)
        
        return formattedDateString
    }
}
