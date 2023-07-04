//
//  Constant.swift
//  MVP+CoreData
//
//  Created by Umang on 16/06/23.
//

import Foundation

var loggedInUser: Int64 = 0

struct Keys {
    static let isLoggedIn = "isLoggedIn"
    static let userId = "UserID"
}

enum Entity: String {
    case Users, AddedUsers
}

enum UserType: Int16 {
    case SignIn = 1
    case Added = 2
}

func appPrint(_ data: Any) {
    print(data)
}
