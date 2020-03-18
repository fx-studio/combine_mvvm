//
//  User.swift
//  CombineMVVM
//
//  Created by Le Phuong Tien on 3/13/20.
//  Copyright © 2020 Fx Studio. All rights reserved.
//

import Foundation

final class User {
  var username: String
  var password: String
  var isLogin = false
  var about = "n/a"
  
  init(username: String, password: String) {
    self.username = username
    self.password = password
  }
}
