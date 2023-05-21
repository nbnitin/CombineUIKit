//
//  SignUpViewController.swift
//  CombineFrameworkDemo
//
//  Created by Nitin Bhatia on 08/04/23.
//

import UIKit
import Combine



class SignUpViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var txtUserName : UITextField!
    @IBOutlet weak var txtPassword : UITextField!
    @IBOutlet weak var btnTermsSwitch : UISwitch!
    @IBOutlet weak var btnSignUp : UIButton!
    
    //variables
    @Published private var isTnCAccepted: Bool! //@published will write will set block for you
    @Published private var username: String = ""
    @Published private var password: String = ""
    var subscriptions = Set<AnyCancellable>()
    var x : Bool? = nil {
        didSet {
            if let x = x, x == false {
                let alert = UIAlertController(title: "x", message: "x", preferredStyle: .alert)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    alert.dismiss(animated: true)
                })
                btnSignUp.isEnabled = false
                self.present(alert, animated: true)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //binding publisher with button isEnabled
//        singupValidationPublisher
//            .receive(on: RunLoop.main) //recevie value on main thread, mainly used for asycn task
//            .assign(to: \.isEnabled, on: btnSignUp) //using true false value to keypath and assigning to sign up button
//            .store(in: &subscriptions) //we need to retain any cancellable, it will help you to free up the memory, it will get connect to our life cycle of our view controller, and will get deallocate with our VC's deallocation
        
        // Do any additional setup after loading the view.
        
        //for single publisher
        
        $isTnCAccepted
            .receive(on: RunLoop.main)
            .map{$0}
            .assign(to: \.x, on: self)
            .store(in: &subscriptions)
    }
    
    
    private var singupValidationPublisher : AnyPublisher<Bool,Never> {
        ///combine latest 3 becuase we wanted to pass 3 params here
        ///combine latest will get to know about changes whenever changes happened on the property marked with @Published
        ///$ will be used to access property value from @published property
        ///in terminology of Combine map will be act as operator
        ///in actual project there will be more validations like password == confirm password, text length and all. All that logics will be gone under map operator
        ///
        return Publishers.CombineLatest3($isTnCAccepted, $username, $password)
            .map{isTnCAccepted, username, password in
                isTnCAccepted! && !username.isEmpty && !password.isEmpty
            }
            .eraseToAnyPublisher() //this will wrap the type to AnyPublisher which our function or variable is actually returing
    }
    
    //MARK: - actions
    @IBAction private func didToggleTnCSwitch(_ sender: UISwitch) {
        isTnCAccepted = sender.isOn
    }
    
    @IBAction private func didChangeUsername(_ sender: UITextField) {
        username = sender.text ?? ""
    }
    
    @IBAction private func didChangePassword(_ sender: UITextField) {
        password = sender.text ?? ""
    }
    
    @IBAction private func didClickOnSubmitButton(_ sender: UIButton) {
        //To be implemented in Zip Operator video
    }
    
}
