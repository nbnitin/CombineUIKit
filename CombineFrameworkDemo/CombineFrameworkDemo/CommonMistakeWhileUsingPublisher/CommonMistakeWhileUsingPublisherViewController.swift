//
//  CommonMistakeWhileUsingPublisherViewController.swift
//  CombineFrameworkDemo
//
//  Created by Nitin Bhatia on 21/05/23.
//

import UIKit
import Combine

class CommonMistakeWhileUsingPublisherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //outlets
    @IBOutlet weak var btnReload: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
    //variables
    var viewModel : CommonMistakeWhileUsingPublisherViewControllerViewModel = CommonMistakeWhileUsingPublisherViewControllerViewModel()
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Problem statement, when you click on reload button the data will not be refreshed
        //Test 1 press the button is data refreshed -> No
        //No, we need to find out the solution for that we follow some steps
        //1. Add a break ppoint to check button is getting presssed or not
        //2. Add a break point under sink to check eigther call back is coming or not
        //3. We will check by adding willSet and didSet block to view model publisher
        
        
        /* Problemetic code starts */
        viewModel.$dataSource
            .sink (receiveValue :{ [weak self] _ in
                self?.tblView.reloadData()
            })
            .store(in: &cancellables)
        /* Problemetic code ends */
        
        /* Solution starts */
        //we need to add subscriber for this
        //RunLoop.main or DispatchQueue.main
        
        //Now difference between RunLoop and DispatchQueue
//        Both are identical and you can do almost everything with RunLoop as you do with DispatchQuue
        
        /* Run Loop */
        
        //Run loop is a event processing loop, that is used for scheduling a work
        //Each thread we create or created by system, each thread has it own RunLoop
        //When we talk about main thread, all the runLoop which is associated with the main thread is called RunLoop.main
        //Run Loop will be executed using perform selector
        //Run loop will give call back when working in default mode
        
        
        /* Run Loop */
        
        /* DispatchQueue.main */
        
            // DispatchQueue is just a queue which is associated with main thread, now thread can have multiple queue which is not a case with main thread. A serial queue that is attached with main thread is called DispatchQueue.main
        //DispatchQueue.main will be executed with GCD
        
        /* DispatchQueue.main */
        
        //Main thread is resposible to update UI and Other stuffs
        
        //What to choose and when
        //Ex. if we are downloading image when user is interacting with the table view like scrolling it, then image wont get displayed or not get downloaded under run loop, but it will get once user stop interacting with the table view or the screen, becuase we choosed run loop as a scheduler and run loop is busy in handling the user interactions so in that case DispatchQueue.main should be the choice
        //Infact DispatchQueue.main should be the default choice when it comes to scheduler
        
//        viewModel.$dataSource
//            .receive(on: RunLoop.main)
//            .sink (receiveValue :{ [weak self] _ in
//                self?.tblView.reloadData()
//            })
//            .store(in: &cancellables)
        /* Solution snds */
    }
    
    @IBAction func btnReloadAction(_ sender: Any) {
        var tempResource = [String]()
        
        for _ in 1 ... 6 {
            if let randomNumber = ((1 ... 20).randomElement()), let spell = randomNumber.asWord {
                tempResource.append(spell)
            } else {
                tempResource.append("No spell found")
            }
            
        }
        viewModel.dataSource = tempResource
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var config = cell.defaultContentConfiguration()
        
        config.text = viewModel.dataSource[indexPath.row]
        
        cell.contentConfiguration = config
        
        return cell
        
    }
    

}

class CommonMistakeWhileUsingPublisherViewControllerViewModel {
    @Published var dataSource : [String] = [] {
        //Now will you will observe that our sink method will be called just after will set block but it should be called after did set
        //Now out problem is clear, but what is the solution for this
        willSet {
            print("i m under will set")
        }
        
        didSet {
            print("i m under did set")
        }
    }
}

public extension Int {
  var asWord: String? {
    let numberValue = NSNumber(value: self)
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    return formatter.string(from: numberValue)
  }
}
