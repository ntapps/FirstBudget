//
//  BudgetRepository.swift
//  FirstBudget
//
//  Created by Nicholas Tallents on 4/9/16.
//  Copyright © 2016 Nicholas Tallents. All rights reserved.
//

import Foundation
import RealmSwift

// Errors
enum BudgetError: Swift.Error {
    case notFound
}

class BudgetRepository {
    
    // Queries
    class func getCurrentMonthBudget() throws -> Budget {
        let realm   = try! Realm()
        let date    = HelperFunctions.getCurrentDate()
        let budgets = realm.objects(Budget.self).filter("month = \"\(date.month)\" AND year = \(date.year)")
        
        if budgets.count == 0 {
            throw BudgetError.notFound
        } else {
            return budgets[0]
        }
    }
    
    class func getMasterBudget() throws -> Budget {
        let realm   = try! Realm()
        let budgets = realm.objects(Budget.self).filter("year = -1 AND month = -1")
        
        if budgets.count == 0 {
            throw BudgetError.notFound
        } else {
            return budgets[0]
        }
    }
    
    // Modify
    class func addSave(_ obj : Budget) {
        let realm = try! Realm()
        let pkc   = Repository.getPrimaryKeyCounter("Budget")
        
        obj.genericModel!.id  = pkc.value
        try! realm.write {
            pkc.value += 1
            realm.add(obj)
        }
    }
}
