//
//  Array+Utilities.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 16/01/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation

extension Array {

    func getRandomTwoElements() -> (first: Element, second: Element)? {
        guard self.count >= 2 else {
            return nil
        }

        let randomIndex = self.getRandomIndexInBounds()!
        let firstRandomElement = self[randomIndex]
        let arrayWithoutFirstRandomElement = self.arrayByRemovingElementAtIndex(randomIndex)
        let secondRandomElement = arrayWithoutFirstRandomElement.getRandomElement()!
        return (first: firstRandomElement,second: secondRandomElement)
    }

    func arrayByRemovingElementAtIndex(index: Index) -> Array<Element> {
        var copy = self
        copy.removeAtIndex(index)
        return copy
    }

    func getRandomIndexInBounds() -> Index? {
        guard !self.isEmpty else {
            return nil
        }
        return Int(arc4random_uniform(UInt32(self.count)))
    }

    func getRandomElement() -> Element? {
        guard let index = getRandomIndexInBounds() else {
            return nil
        }
        return self[index]
    }
}