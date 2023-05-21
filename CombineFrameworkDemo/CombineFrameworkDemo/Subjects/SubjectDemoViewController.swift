//
//  SubjectDemoViewController.swift
//  CombineFrameworkDemo
//
//  Created by Nitin Bhatia on 12/05/23.
//

//Using subjects is one of the easiest ways of creating your own publisher. The protocol allows you to write the concrete implementation as per the requirements, while the two pre defined implementations for Subject protocol i.e. PassthroughSubject and CurrentValue subject suffice for most of the use cases.

//A subject is a publisher that you can use to ”inject” values into a stream, by calling its send(_:) method. This can be useful for adapting existing imperative code to the Combine model.


//Subject is basically act as a protocol which helps to communicate between viewcontrollers

//Subject is abstract type or can say it is a protocol

//Subject is of two types PassThrough and CurrentValue

// Passthrough should be used when you want to emit the value when any action has performed e.x. tap on button from tableview cell and sending value to tableview or viewcontroller

// CurrentValue is used when you are intrested in the state of any subject, for e.x. is UISwitchButton state, user not performed any action but switch has some state either on or off, that is the reason current value subject has always some initial value

import UIKit
import Combine

let INITIAL_VALUE : Float = 0.5

class SubjectDemoViewController: UIViewController {

    //outlets
    @IBOutlet weak var lblValue1: UILabel!
    @IBOutlet weak var lblValue2: UILabel!
    @IBOutlet weak var lblValue3: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var lblState: UILabel!
    
    //variables

    var subscriptions : Set<AnyCancellable> = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblValue1.text = String(format: "%.1f", INITIAL_VALUE)
        lblValue2.text = String(format: "%.1f", INITIAL_VALUE)
        lblValue3.text = String(format: "%.1f", INITIAL_VALUE)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        stackView.spacing = view.frame.width / 3 - 60
    }
    

    @IBAction func btnNavOpenSheet(_ sender: Any) {
        let storyboard = self.storyboard
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "BottomSheet") as! BottomSheetViewController
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
        }
        
        vc.value1CurrentValueSubject
            .sink { [weak self] value in
                self?.lblValue1.text = String(format: "%.1f", value)
            }
            .store(in: &self.subscriptions)
        
        vc.value2CurrentValueSubject
            .sink { [weak self] value in
                self?.lblValue2.text = String(format: "%.1f", value)
            }
            .store(in: &self.subscriptions)
        
        vc.value3CurrentValueSubject
            .sink { [weak self] value in
                self?.lblValue3.text = String(format: "%.1f", value)
            }
            .store(in: &self.subscriptions)
        
        vc.stateCurrentValueSubject
            .sink { [weak self] value in
                self?.lblState.text = value
            }
            .store(in: &self.subscriptions)
        
        present(vc, animated: true)
    }
    

}
