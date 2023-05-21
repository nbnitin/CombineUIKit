//
//  ViewController.swift
//  CombineFrameworkDemo
//
//  Created by Nitin Bhatia on 06/04/23.
//

import UIKit
import Combine

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //outlets
    @IBOutlet weak var tblUser: UITableView!
    
    //variables
    private var userViewModel = UserViewModel()
    @Published var userData = [UserModel]()
    var cancellabels = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        userViewModel.getUserData()
            .receive(on: DispatchQueue.main)
            .map{$0}
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: {items in
                self.userData = items
            })
            
            .store(in: &cancellabels)
            
        
        $userData
            .receive(on: RunLoop.main)
            .sink(receiveValue: {items in
                self.tblUser.reloadData()
            })
            .store(in: &cancellabels)
       
       
    }
    
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = userData[indexPath.row].name
        cell.contentConfiguration = content
        return cell
    }
   


}


