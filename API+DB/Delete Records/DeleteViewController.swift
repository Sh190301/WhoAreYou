//
//  DeleteViewController.swift
//  API+DB
//
//  Created by Shreya Das on 29/05/22.
//

import UIKit
import FirebaseStorage
import Lottie

class DeleteViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var newview: UIView!
    private var animationView: AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ondeleteTmp(_ sender: Any) {
        lottieAnimation()
        deleteTempStorage()
    }
    
    @IBAction func ondeleteCore(_ sender: Any) {
        lottieAnimation()
        deleteAllStorage()
    }
    func deleteAllStorage() {
        // Create a reference to the file to delete
        let storageReference = Storage.storage().reference().child("images/")

        storageReference.listAll { (result, error) in
          if let error = error {
            // ...
              print("error to list")
          }
          for prefix in result.prefixes {
            // The prefixes under storageReference.
            // You may call listAll(completion:) recursively on them.
              print(prefix)
          }
          for item in result.items {
              let gsReference = Storage.storage().reference(forURL: "\(item)")
              
              gsReference.delete { error in
                if let error = error {
                   print("Uh-oh, an error occurred!")
                } else {
                   print("File deleted successfully")
                    self.animationView?.removeFromSuperview()
                    self.imageView.alpha = 1
                }
              }
              
          }
            
        }
    }
    
    func deleteTempStorage() {
        // Create a reference to the file to delete
        let storageReference = Storage.storage().reference().child("temp/")

        storageReference.listAll { (result, error) in
          if let error = error {
            // ...
              print("error to list")
          }
          for prefix in result.prefixes {
            // The prefixes under storageReference.
            // You may call listAll(completion:) recursively on them.
              print(prefix)
          }
          for item in result.items {
              let gsReference = Storage.storage().reference(forURL: "\(item)")
              
              gsReference.delete { error in
                if let error = error {
                   print("Uh-oh, an error occurred!")
                } else {
                   print("File deleted successfully")
                    self.animationView?.removeFromSuperview()
                    self.imageView.alpha = 1
                }
              }
              
          }
            
        }
    }
    
    func lottieAnimation() {
        
        imageView.alpha = 0
        animationView = .init(name: "recycling-bin")
        
        animationView!.frame = view.bounds
        
        
        animationView?.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        animationView?.center = view.center
        
        animationView!.loopMode = .loop
        
        animationView?.animationSpeed = 0.4
        
        
        view.addSubview(self.animationView!)
        
        
        self.animationView!.play(fromProgress: 0, toProgress: 1) { (finished) in
//            self.animationView?.removeFromSuperview()
        }
          
          
          
          // 6. Play animation
          
          
        
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
