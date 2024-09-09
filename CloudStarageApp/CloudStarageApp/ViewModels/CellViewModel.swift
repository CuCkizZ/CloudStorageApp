//
//  CellViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 05.09.2024.
//

import Foundation

protocol CellViewModelProtocol {
    func sizeFormatter(bytes: Int) -> String
    func setMaxCharacters(text: String) -> NSMutableAttributedString
    func optionalRemove(sizeString: String) -> String
    func dateFormatter(dateString: String) -> String
}

final class CellViewModel: CellViewModelProtocol {

    func sizeFormatter(bytes: Int) -> String {
        let kilobytes = Double(bytes) / 1024
        let megabytes = kilobytes / 1024
        
        if megabytes >= 1 {
            let roundedMegabytes = String(format: "%.2f", megabytes)
            return ", \(roundedMegabytes) МБ"
        } else {
            let roundedKilobytes = String(format: "%.2f", kilobytes)
            return ", \(roundedKilobytes) КБ"
        }
    }
    
    func setMaxCharacters(text: String) -> NSMutableAttributedString {
        let maxCharacters = 25
        let truncatedText = String(text.prefix(maxCharacters))
        let attributedText = NSMutableAttributedString(string: truncatedText)
        if text.count > maxCharacters {
            attributedText.append(NSAttributedString(string: "..."))
        }
        return attributedText
    }
    
    func optionalRemove(sizeString: String) -> String {
            let cleanedSizeString = sizeString
                .replacingOccurrences(of: "Optional(", with: "")
                .replacingOccurrences(of: ")", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
        return cleanedSizeString
    }
    
    func dateFormatter(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
            return dateFormatter.string(from: date)
        }
        return ""
    }
}
