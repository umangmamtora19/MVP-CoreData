//
//  AuthPresenter.swift
//  MVP+CoreData
//
//  Created by Umang on 17/06/23.
//

import Foundation
import CoreData

protocol AuthPresenterDelegate: AnyObject {
    func signin(success: Bool, message: String)
    func signup(success: Bool, message: String)
}

class AuthPresenter {
    weak var delegate: AuthPresenterDelegate?
    
    func setViewDelegate(delegate: AuthPresenterDelegate) {
        self.delegate = delegate
    }
    
    func signinWith(params: [String: Any]) {
        let email = params["email"] as? String ?? ""
        let password = params["password"] as? String ?? ""
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.Users.rawValue)
        let predicate = NSPredicate(format: "email == %@", email)
        
        request.predicate = predicate
        request.fetchLimit = 1
        do{
            let count = try CoreDataManager.objectContext.count(for: request)
            if (count == 0){
                delegate?.signin(success: false, message: "Account not found please sign up")
                
            } else {
                let request2 = NSFetchRequest<Users>(entityName: "Users")
                let predicate2 = NSPredicate(format: "email == %@ AND password == %@", email, password)
                
                request2.predicate = predicate2
                request2.fetchLimit = 1
                
                do {
                    let count = try CoreDataManager.objectContext.count(for: request2)
                    let fetchUser = try CoreDataManager.objectContext.fetch(request2)
                    
                    if count == 0 {
                        delegate?.signin(success: false, message: "Password doesn't match please try again")
                    } else {
                        UserDefaults.standard.set(true, forKey: Keys.isLoggedIn)
                        UserDefaults.standard.set(fetchUser.first?.id ?? 0, forKey: Keys.userId)
                      
                        loggedInUser = fetchUser.first?.id ?? 0
                        delegate?.signin(success: true, message: "Success")
                    }
                    
                } catch let error as NSError {
                    appPrint("Could not fetch 2 \(error), \(error.userInfo)")
                }
                // at least one matching object exists
            }
        }
        catch let error as NSError {
            appPrint("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func signupWith(params: [String: Any]) {
        let email = params["email"] as? String ?? ""
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.Users.rawValue)
        let predicate = NSPredicate(format: "email == %@", email)
        
        request.predicate = predicate
        request.fetchLimit = 1
        
        do {
            let count = try CoreDataManager.objectContext.count(for: request)
            
            if count == 0 {
                guard let entity = CoreDataManager.getEntityDescription(entityName: .Users) else { return }

                let obj = CoreDataManager.insertData(in: entity) as! Users
                obj.email = params["email"] as? String ?? ""
                obj.password = params["password"] as? String ?? ""
                obj.id = Date().currentTimeMillis()
                
                CoreDataManager.saveToMainContext()
                
                UserDefaults.standard.set(true, forKey: Keys.isLoggedIn)
                UserDefaults.standard.set(obj.id, forKey: Keys.userId)
                
                loggedInUser = obj.id
                
                delegate?.signup(success: true, message: "Success")
            } else {
                delegate?.signup(success: false, message: "Account already exist, try signing in")
            }
            
        } catch let error as NSError {
            appPrint("Could not fetch 2 \(error), \(error.userInfo)")
        }
        
        
    }
}
