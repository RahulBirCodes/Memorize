//
//  UtilityExtensions.swift
//  Memorize
//
//  Created by Rahul Bir on 7/23/22.
//

import Foundation

extension String {
    var removingDuplicateCharacters: String {
        reduce(into: "") { sofar, element in
            if !sofar.contains(element) {
                sofar.append(element)
            }
        }
    }
}
