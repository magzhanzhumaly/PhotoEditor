//
//  GlobalMethods.swift
//  AuthorizationAezakmi
//
//  Created by Magzhan Zhumaly on 09.05.2024.
//

import Foundation

struct GlobalMethods {
    static func isValidEmail(_ email: String) -> Bool {
        return email.contains("@")
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8
    }
}
