//
//  WelcomeViewController.swift
//  CombineMVVM
//
//  Created by Le Phuong Tien on 3/13/20.
//  Copyright © 2020 Fx Studio. All rights reserved.
//

import UIKit
import Combine

class WelcomeViewController: UIViewController {
  
  //MARK: Outlets
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var aboutLabel: UILabel!
  @IBOutlet weak var homeButton: UIButton!
  @IBOutlet weak var loginButton: UIButton!
  
  //MARK: Properties
  let viewModel = WelcomeViewModel(user: .init(name: "Fx", about: "Admin", isLogin: false))
  
  var subscriptions = Set<AnyCancellable>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // title
    title = App.Text.titleWelcomeVC
    
    // subscriptions
    // name
    viewModel.name
      .assign(to: \.text, on: nameLabel)
      .store(in: &subscriptions)
    
    // about
    viewModel.about
    .assign(to: \.text, on: aboutLabel)
    .store(in: &subscriptions)
    
    // buttons
    viewModel.loginEnabled
      .sink { isLogin in
        self.loginButton.isEnabled = !isLogin
        self.homeButton.isEnabled = isLogin
      }
    .store(in: &subscriptions)
    
  }
  
  //MARK: IBActions
  @IBAction func loginButtonTourchUpInside(_ sender: Any) {
    viewModel.action.send(.gotoLogin)
  }
  
  @IBAction func homeButtonTourchUpInside(_ sender: Any) {
    viewModel.action.send(.gotoHome)
   }
  
}
