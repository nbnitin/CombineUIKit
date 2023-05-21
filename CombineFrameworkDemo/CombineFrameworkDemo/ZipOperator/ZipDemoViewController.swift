//
//  ZipDemoViewController.swift
//  CombineFrameworkDemo
//
//  Created by Nitin Bhatia on 22/04/23.
//

//Similar to Combine Latest, Zip operator is another useful operator which takes multiple publishers as input, and passes the processed value to downstream only on completion of all the publishers. In this video, I've shown that how can we use Zip for making multiple web service calls asynchronously, and hold the processing till all of them completes.

//Before or without combine we can do this with dispatch groups

import UIKit
import Combine

class ZipDemoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //outlets
    @IBOutlet weak var zipTblView: UITableView!
    
    //variables
    let vm = ZipDemoViewModel()
    var demoDatas : [UserModel] = [UserModel]()
    var cancellables : Set<AnyCancellable> = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllData()
    }
    
    private func getAllData() {
        let publishers = Publishers.Zip(vm.getAllUsers(), vm.getAllAlbums())
        
        publishers.compactMap{
            let albums = $0.1
            return $0.0.map{
                let userId = $0.id
                let userAlbums = albums.filter({$0.userId == userId})
                return UserModel(id: $0.id, name: $0.name, username: $0.username, email: $0.email, phone: $0.phone, website: $0.website, address: $0.address, company: $0.company, albumDatas: userAlbums)
            }
        }
        .sink { (completion) in
                    if case let .failure(error) = completion {
                        print("Error -> \(error.localizedDescription)")
                    }
                } receiveValue: { [weak self] profileModel in
                    self?.demoDatas = profileModel
                    self?.zipTblView.reloadData()
                }
                .store(in: &cancellables)
            
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserAndPostTableViewCell
        
        cell.lblUserName.text = demoDatas[indexPath.row].name
        cell.lblUserAlbumNames.text! = (demoDatas[indexPath.row].albumDatas.map({
            return $0.map({
                ($0.title ?? "") + ", "
            })
        })?.joined())!
        
        cell.lblUserAlbumNames.text! = String(cell.lblUserAlbumNames.text!.dropLast(2))
        
        return cell
    }
    


}
