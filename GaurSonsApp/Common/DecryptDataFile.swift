//
//  DecryptDataFile.swift
//  GaurSonsApp
//
//  Created by Sakshi on 15/05/26.
//  Copyright © 2026 GaurSonsAppOrganizationName. All rights reserved.
//

import Foundation

class DecryptDataFile {
    static func decryptValue(_ value: String?) -> String? {

        guard let value = value, !value.isEmpty else {
            return value
        }

        let capsMapping: [Character: Character] = [
            "A":"Q", "B":"W", "C":"E", "D":"R", "E":"T", "F":"Y",
            "G":"U", "H":"I", "I":"O", "J":"P", "K":"A", "L":"S",
            "M":"D", "N":"F", "O":"G", "P":"H", "Q":"J", "R":"K",
            "S":"L", "T":"Z", "U":"X", "V":"C", "W":"V", "X":"B",
            "Y":"N", "Z":"M"
        ]

        let smallMapping: [Character: Character] = [
            "a":"q", "b":"w", "c":"e", "d":"r", "e":"t", "f":"y",
            "g":"u", "h":"i", "i":"o", "j":"p", "k":"a", "l":"s",
            "m":"d", "n":"f", "o":"g", "p":"h", "q":"j", "r":"k",
            "s":"l", "t":"z", "u":"x", "v":"c", "w":"v", "x":"b",
            "y":"n", "z":"m"
        ]

        let numMapping: [Character: Character] = [
            "0":"9", "1":"8", "2":"7", "3":"6", "4":"5",
            "5":"4", "6":"3", "7":"2", "8":"1", "9":"0"
        ]

        // Reverse mappings
        let reverseCaps = Dictionary(uniqueKeysWithValues: capsMapping.map { ($1, $0) })
        let reverseSmall = Dictionary(uniqueKeysWithValues: smallMapping.map { ($1, $0) })
        let reverseNum = Dictionary(uniqueKeysWithValues: numMapping.map { ($1, $0) })

        var decrypted = ""

        for char in value {

            if let mapped = reverseCaps[char] {
                decrypted.append(mapped)

            } else if let mapped = reverseSmall[char] {
                decrypted.append(mapped)

            } else if let mapped = reverseNum[char] {
                decrypted.append(mapped)

            } else {
                decrypted.append(char)
            }
        }

        return decrypted
    }
}
