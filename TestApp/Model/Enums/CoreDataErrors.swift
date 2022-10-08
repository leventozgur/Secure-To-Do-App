//
//  CoreDataErrors.swift
//  TestApp
//
//  Created by Levent ÖZGÜR on 5.10.2022.
//

import Foundation

public enum CoreDataErrors: Error {
    case contextIsNil
    case attributeIsNil
    case parseError
    case coreDataSaveError
    case notFound
}
