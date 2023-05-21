//
//  PostViewController.swift
//  CombineFrameworkDemo
//
//  Created by Nitin Bhatia on 10/04/23.
//

import UIKit
import Combine

class PostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //outelts
    @IBOutlet weak var tblPosts: UITableView!
    
    
    //variables
    let postViewModel = PostViewModel()
    var cancellables =  Set<AnyCancellable>()
    @Published var postData = [Posts]()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        getPosts()
    }
    
    //MARK: get all posts
    private func getPosts() {
        postViewModel.getAllPosts()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let err):
                    print(err.localizedDescription)
                }
            }, receiveValue: {items in
                self.postData = items
                self.tblPosts.reloadData()
            }).store(in: &cancellables)
        
        
        
        
        $postData
            .receive(on: RunLoop.main)
            .sink(receiveValue: {items in
                let _ = items.map({
                    $0.$isRead
                        .receive(on: RunLoop.main)
                        .map({$0})
                        .sink { completion in
                            print(completion)
                        } receiveValue: { data in
                            if true {
                                if let index = self.tblPosts.indexPathForSelectedRow {
                                    self.tblPosts.reloadRows(at: [index], with: .fade)
                                }
                            }
                        }
                        .store(in: &self.cancellables)
                })
                    
                
                
//                self.tblPosts.reloadData()
            }).store(in: &cancellables)
    }
    
    
    //MARK: table view setting up
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = postData[indexPath.row].title
        content.secondaryText = postData[indexPath.row].body
        
        
        if postData[indexPath.row].isRead {
            cell.backgroundColor = .red
            content.textProperties.color = .white
            content.secondaryTextProperties.color = .white
        } else {
            cell.backgroundColor = .white
            content.textProperties.color = .black
            content.secondaryTextProperties.color = .black
        }
        
        cell.contentConfiguration = content
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVc = storyboard?.instantiateViewController(identifier: "postDetailVC") as! PostDetailsViewController
        detailVc.postId = postData[indexPath.row].id
        detailVc.posts = postData[indexPath.row]
        show(detailVc, sender: nil)
    }
}
