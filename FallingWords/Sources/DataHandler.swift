//
//  DataHandler.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 16/01/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation
import SwiftyJSON

enum DataHandlerError: ErrorType {
    case PathNotFound
    case DataNotParsed
}

protocol DataHandlerType {
    func jsonDataFromFileNamed(name: String) throws -> JSON
}

class DataHandler : DataHandlerType {

    func jsonDataFromFileNamed(name: String) throws -> JSON {
        do {
            guard let path = NSBundle.mainBundle().pathForResource(name, ofType: "json") else {
                throw DataHandlerError.PathNotFound
            }
            let jsonData = try NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
            return JSON(data: jsonData)
        } catch {
            throw DataHandlerError.DataNotParsed
        } 
    }
}