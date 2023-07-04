//
//  DashboardPresenter.swift
//  MVP+CoreData
//
//  Created by Umang on 17/06/23.
//

import Foundation
import CoreData

protocol DashboardPresenterDelegate: AnyObject {
    func userFetched(userList: [AddedUsers], message: String)
}

class DashboardPresenter {
    weak var delegate: DashboardPresenterDelegate?
    
    func setViewDelegate(delegate: DashboardPresenterDelegate) {
        self.delegate = delegate
    }
    
    func fetchUsers() {
        let request = NSFetchRequest<AddedUsers>(entityName: Entity.AddedUsers.rawValue)
        let predicate = NSPredicate(format: "addedBy == %@", "\(loggedInUser)")
        request.predicate = predicate
        
        do {
            let result = try CoreDataManager.objectContext.fetch(request)
            if result.count > 0 {
                delegate?.userFetched(userList: result, message: "Users Found")
            } else {
                delegate?.userFetched(userList: [], message: "No user found")
            }
            
        } catch let error as NSError {
            appPrint("Could not fetch \(error), \(error.userInfo)")
        }
    }
}
