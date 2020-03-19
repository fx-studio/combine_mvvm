//
//  LoginViewModel.swift
//  DemoMVVMCombine
//
//  Created by Le Phuong Tien on 2/18/20.
//  Copyright © 2020 Fx Studio. All rights reserved.
//
import Foundation
import Combine

final class LoginViewModel {
  
  //MARK: - Define
  // State
  enum State {
    case initial
    case logined
    case error(message: String)
  }
  
  // Action
  enum Action {
    case login
    case clear
  }
  
  //MARK: - Properties
  // Publisher & store
  @Published var username: String?
  @Published var password: String?
  @Published var isLoading: Bool = false
  
  // Trigger TextField
  var validatedText: AnyPublisher<Bool, Never> {
    return Publishers.CombineLatest($username, $password)
      .map { !($0!.isEmpty || $1!.isEmpty) }
      .eraseToAnyPublisher()
  }
  
  // Model
  var user: User?
  
  // Actions
  let action = PassthroughSubject<Action, Never>()
  
  // State
  let state = CurrentValueSubject<State, Never>(.initial)
  
  // Subscriptions
  var subscriptions = [AnyCancellable]()
  
  
  //MARK: init
  init(username: String, password: String) {
    
    self.user = .init(username: username, password: password)
    
    // state
    state
      .sink { [weak self] state in
        self?.processState(state)
    }.store(in: &subscriptions)
    
    // action
    action
      .sink { [weak self] action in
        self?.processAction(action)
    }.store(in: &subscriptions)
    
    //test
//    $username
//      .sink { print($0)}
//      .store(in: &subscriptions)
  }
  
  
  //MARK: Actions
  // without callback
  func clear() {
    username = ""
    password = ""
  }
  
  // with callback
  func login() -> AnyPublisher<Bool, Never> {
    
    if isLoading {
      return $isLoading.map { !$0 }.eraseToAnyPublisher()
    }
    
    isLoading = true
    
    // test
    let test = username == "fxstudio" && password == "123456"
    
    let subject = CurrentValueSubject<Bool, Never>(test)
    return subject.delay(for: .seconds(1), scheduler: DispatchQueue.main).eraseToAnyPublisher()
  }
  
  //MARK: - Private functions
  // process Action
  private func processAction(_ action: Action) {
    
    switch action {
    case .login:
      print("ViewModel -> Login")
    
      _ = login().sink { done in
        self.isLoading = false
        
        if done {
          self.state.value = .logined
        } else {
          self.state.value = .error(message: "Login failed.")
        }
      }
      
    case .clear:
      self.clear()
      
    }
  }
  
  // process State
  private func processState(_ state: State) {
    switch state {
    case .initial:
      
      if let user = user {
        username = user.username
        password = user.password
        isLoading = false
      } else {
        username = ""
        password = ""
        isLoading = false
      }
      
    case .logined:
      print("LOGINED")
      isLoading = true
      
    case .error(let message):
      print("Error: \(message)")
    }
  }
}
