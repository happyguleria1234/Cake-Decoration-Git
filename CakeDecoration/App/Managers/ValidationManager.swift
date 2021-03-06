//
//  ValidationManager.swift
//  SessionControl
//
//  Created by Dharmesh Avaiya on 22/08/20.
//  Copyright © 2020 dharmesh. All rights reserved.
//

import UIKit

enum RegularExpressions: String {
    case url = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//    case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
//    case phone =  "^\\d{3}\\d{3}\\d{5}$"
    case phone =  "[0-11]"
    case accountNumber = "[0-9]{9,18}"
    case cardNumber = "[0-20]"
    case routingNumber = "[0-9]"
//    case ssnNumber = "^(?!(000|666|9))\\d{3}-(?!00)\\d{2}-(?!0000)\\d{4}$"
    case ssnNumber = "^\\d{3}-\\d{2}-\\d{4}$"
    case cvv = "[0-3]"
    case expiryDate = "[0-5]"
    case password8AS = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
    case password82US2N3L = "^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$"
}

class ValidationManager: NSObject {
    
    let kNameMinLimit = 2
    let kPasswordMinLimit = 8
    let kPasswordMaxLimit = 20
    
    //------------------------------------------------------
           
    //MARK: Shared
              
    static let shared = ValidationManager()
   
    //------------------------------------------------------
    
    //MARK: Private
    
    private func isValid(input: String, matchesWith regex: String) -> Bool {
        let matches = input.range(of: regex, options: .regularExpression)
        return matches != nil
    }
    
    //------------------------------------------------------
    
    //MARK: Public
    
    func isEmpty(text : String?) -> Bool {
        return text?.toTrim().isEmpty ?? true
    }
    
    func isValid(text: String, for regex: RegularExpressions) -> Bool {
        
        return isValid(input: text, matchesWith: regex.rawValue)
    }
    
    func isValidConfirm(password : String, confirmPassword : String) -> Bool{
        if password == confirmPassword {
            return true
        } else {
            return false
        }
    }
    
    func isValidSsn(_ ssn: String) -> Bool {
      let ssnRegext = "^(?!(000|666|9))\\d{3}-(?!00)\\d{2}-(?!0000)\\d{4}$"
      return ssn.range(of: ssnRegext, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    
    //------------------------------------------------------
}

