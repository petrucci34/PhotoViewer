//
//  String+Extension.swift
//  PhotoViewer
//
//  Created by Bircan, Korhan on 5/19/17.
//  Copyright © 2017 Korhan. All rights reserved.
//

import Foundation

extension String {
    /// Method to trim prefix, suffix, and redundant whitespaces in between words eg.
    ///
    /// " hello  " -> "hello"
    ///
    ///
    /// " hello   world  " -> "hello world" etc.
    ///
    /// - Returns: The modified string.
    func trimRedundantWhitespace() -> String {
        var nonEmptyStringsSeparatedByWhitespace = ""
        let tokens = components(separatedBy: " ")
        let nonEmptyTokens = tokens.filter{!$0.onlyWhitespaces && !$0.characters.isEmpty}

        // Tokens can contain multi-whitespace strings which we want to avoid.
        for (index, token) in nonEmptyTokens.enumerated() {
            nonEmptyStringsSeparatedByWhitespace += token

            // Add a whitespace between tokens but not after the last token.
            if index < nonEmptyTokens.count - 1 {
                nonEmptyStringsSeparatedByWhitespace += " "
            }
        }

        return nonEmptyStringsSeparatedByWhitespace
    }
}
