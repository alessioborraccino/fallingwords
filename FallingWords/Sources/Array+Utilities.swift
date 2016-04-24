//
//  Array+Utilities.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 16/01/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation

extension RangeReplaceableCollectionType where Index : RandomAccessIndexType {

    func arrayByRemovingElementAtIndex(index: Index) -> Self  {
        var copy = self
        copy.removeAtIndex(index)
        return copy
    }

    func getRandomIndexInBounds() -> Index? {
        guard !self.isEmpty else {
            return nil
        }
     
      let randomDistance = Index.Distance(arc4random_uniform(UInt32(count.toIntMax())).toIntMax())
      return startIndex.advancedBy(randomDistance)
    }

    func getRandomElement() -> Generator.Element? {
        guard let index = getRandomIndexInBounds() else {
            return nil
        }
        return self[index]
    }
}