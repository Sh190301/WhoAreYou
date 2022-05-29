//
//  RecordViewController.swift
//  API+DB
//
//  Created by Shreya Das on 28/05/22.
//

import UIKit
import SDWebImage
import FirebaseStorage

class RecordViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var label: UILabel!
    
    var fileLink = [String]()
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    
    override func viewDidLoad() {
        label.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listRecords()
    }
    
    func listRecords() {
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
              
              gsReference.downloadURL(completion:{ (url, error) in
                  if let error = error {
                      print ("Got an error generating the URL in list: \(error.localizedDescription)")
                      return
                  }
                  if let url = url {
//                      print ("Here is your download URL: \(url.absoluteString)")
                      print("url: ", url.absoluteString)
                      DispatchQueue.main.async {
 
                          self.appendLink(link: url.absoluteString)
                          
            
                      }
                      
                  }
                  })
              
          }
            
            
        }
        
        
    }
    
    func appendLink(link: String) {
        fileLink.append(link)
        print(fileLink)
        collectionView.reloadData()
        print(fileLink.count)
        self.label.alpha = 0


        
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fileLink.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
    
        
        
        DispatchQueue.main.async {
            
        
            let url = self.fileLink[indexPath.row]
            
            cell.imageView.sd_imageTransition = .fade
            cell.imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "Abstrac"))
            cell.layer.cornerRadius = 15

            
        
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
    
}

class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView : UIImageView!
}


