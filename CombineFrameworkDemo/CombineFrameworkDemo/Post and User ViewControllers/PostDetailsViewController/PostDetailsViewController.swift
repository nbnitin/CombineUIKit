//
//  PostDetailsViewController.swift
//  CombineFrameworkDemo
//
//  Created by Nitin Bhatia on 10/04/23.
//

import UIKit
import Combine

class PostDetailsViewController: UIViewController {

    //outlets
    @IBOutlet weak var lblPostTitle: UILabel!
    @IBOutlet weak var lblPostDetails: UILabel!
    
    //variables
    let vm = PostDetailsViewModel()
    var postId : Int?
    var cancellabeles = Set<AnyCancellable>()
    var posts : Posts?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        posts?.isRead = true
        if let postId {
            vm.getPostDetails(postId)
            vm.$postDetails
                .sink(receiveValue: { item in
                self.lblPostTitle.text = item.title
                self.lblPostDetails.text = item.body
                })
                .store(in: &cancellabeles)
            
            
            
            //this will be called just before new value is about to set to @published variable
            vm.objectWillChange.sink(receiveValue: {
                print("virew model changing")
            }).store(in: &cancellabeles)
            
        }
    }
    

}
