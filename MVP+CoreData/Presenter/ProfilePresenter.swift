//
//  ProfilePresenter.swift
//  MVP+CoreData
//
//  Created by Umang on 17/06/23.
//

import Foundation
import CoreData

protocol ProfilePresenterDelegate: AnyObject {
    func didAddedUser(success: Bool)
    func didUpdateUser(success: Bool)
}

class ProfilePresenter {
    weak var delegate: ProfilePresenterDelegate?
    
    func setViewDelegate(delegate: ProfilePresenterDelegate) {
        self.delegate = delegate
    }
    
    func addNewUser(params: [String: Any]) {
        let image = params["image"] as? Data ?? Data()
        let fname = params["fname"] as? String ?? ""
        let lname = params["lname"] as? String ?? ""
        guard let entity = CoreDataManager.getEntityDescription(entityName: .AddedUsers) else { return }
        
        let obj = CoreDataManager.insertData(in: entity) as! AddedUsers
        obj.id = Date().currentTimeMillis()
        obj.profile = image
        obj.fname = fname
        obj.lname = lname
        obj.addedBy = loggedInUser
        
        CoreDataManager.saveToMainContext()
         
        delegate?.didAddedUser(success: true)
    }
    
    func updateUser(params: [String: Any]) {
        let image = params["image"] as? Data ?? Data()
        let fname = params["fname"] as? String ?? ""
        let lname = params["lname"] as? String ?? ""
        let userToUpdate = params["userId"] as? Int64 ?? 0

        let request = NSFetchRequest<AddedUsers>(entityName: Entity.AddedUsers.rawValue)
        let predicate = NSPredicate(format: "id == %@", "\(userToUpdate)")
        
        request.predicate = predicate
        request.fetchLimit = 1
        
        do {
            let result = try CoreDataManager.objectContext.fetch(request)[0]
            result.setValue(image, forKey: "profile")
            result.setValue(fname, forKey: "fname")
            result.setValue(lname, forKey: "lname")
            
            CoreDataManager.saveToMainContext()
            
            delegate?.didUpdateUser(success: true)
        } catch (let error as NSError) {
            delegate?.didUpdateUser(success: false)
            appPrint(error.userInfo)
        }
    }
}
