//
//  WelcomeViewModel.swift
//  CombineMVVM
//
//  Created by Le Phuong Tien on 3/13/20.
//  Copyright © 2020 Fx Studio. All rights reserved.
//

import Foundation
import Combine

final class WelcomeViewModel {
  
  //MARK: State
  enum State {
    case initial
    case error(message: String)
  }
  
  let state = CurrentValueSubject<State, Never>(.initial)
  
  //MARK: Actions
  enum Action {
    case gotoLogin
    case gotoHome
  }
  
  let action = PassthroughSubject<Action, Never>()
  
  var subscriptions = Set<AnyCancellable>()
  
  //MARK: Properties
  let name            = CurrentValueSubject<String?, Never>(nil)
  let about           = CurrentValueSubject<String?, Never>(nil)
  let loginEnabled    = CurrentValueSubject<Bool, Never>(false)
  let errorText       = CurrentValueSubject<String?, Never>(nil)
  
  var user: User
  
  //MARK: init
  init(user: User) {
    self.user = user
    
    //subscriptions
    state
      .sink(receiveValue: { [weak self] state in
        self?.processState(state)
      })
      .store(in: &subscriptions)
    
    action
      .sink(receiveValue: { [weak self] action in
        self?.processAction(action)
      })
      .store(in: &subscriptions)
  }
  
  deinit {
    subscriptions.removeAll()
  }
  
  //MARK: Private function
  // STATE
  private func processState(_ state: State) {
    switch state {
    case .initial:
      name.value = user.name
      about.value = user.about
      loginEnabled.value = user.isLogin
      errorText.value = nil
      
    case .error(let message):
      errorText.value = message
      
    }
  }
  
  //ACTION
  private func processAction(_ action: Action) {
    switch action {
    case .gotoHome:
      print("goto HomeVC")
    case .gotoLogin:
      print("goto LoginVC")
    }
  }
  
}
