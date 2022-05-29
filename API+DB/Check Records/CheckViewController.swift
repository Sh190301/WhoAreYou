//
//  CheckViewController.swift
//  API+DB
//
//  Created by Shreya Das on 29/05/22.
//

import UIKit
import FirebaseStorage
import Lottie

class CheckViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    private var animationView: AnimationView?

    var maxFace = Int()
    var tmpImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func photoPicker(_ sender: Any) {
        pickerSource()
        
    }
    @IBAction func checkRecord(_ sender: Any) {
        if imageView.image != nil {
            addRecordData()
        }
        
    }
    
    func pickerSource() {
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    func openCamera()
    {
        let imagePicker = UIImagePickerController()
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        tmpImage = image
        imageView.image = tmpImage
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func addRecordData() {
        lottieAnimation()
        let randomID = UUID.init().uuidString
        let uploadRef = Storage.storage ().reference (withPath: "temp/\(randomID).jpg")
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.75) else { return }
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        let taskReference = uploadRef.putData (imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
            if let error = error {
                print ("Oh no! Got an error! \(error.localizedDescription)")
                return
            }
            print ("Put is complete and I got this back: \(String (describing: downloadMetadata))")
            
            uploadRef.downloadURL(completion:{ (url, error) in
                if let error = error {
                    print ("Got an error generating the URL: \(error.localizedDescription)")
                    return
                }
                if let url = url {
                    print ("Here is your download URL: \(url.absoluteString)")
                    capturedImageURL = url.absoluteString
                    self.faceVerification()
                }
            })
        }
        taskReference.observe(.progress) { [weak self] (snapshot) in
            guard let pctThere = snapshot.progress?.fractionCompleted else { return }
            print ("You are \(pctThere) complete")
        }
    }
    
    func faceVerification() {
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
            DispatchQueue.main.async {
    
            for item in result.items {
                let gsReference = Storage.storage().reference(forURL: "\(item)")
                
                
                gsReference.downloadURL(completion:{ (url, error) in
                    if let error = error {
                        print ("Got an error generating the URL in list: \(error.localizedDescription)")
                        return
                    }
                    if let url = url {
                        //                      print ("Here is your download URL: \(url.absoluteString)")
                        DispatchQueue.main.async {
      
                            self.api(alink: url.absoluteString, blink: capturedImageURL)
    
                        
                            
                        }

                        self.animationView?.removeFromSuperview()
                        messageData = "data found"
                        self.performSegue (withIdentifier: "not-verified", sender: self)
                    }
                })
                
            }
                
              

                
        }
            

    
        }
        
        
        
        
    }
    
    
   
    
    
    
    func api(alink: String, blink: String) {
        
        let link1 = "\(alink)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let link2 = "\(blink)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        //        print(link1)
        let semaphore = DispatchSemaphore (value: 0)
        let parameters = "linkFile1=\(link1!)&linkFile2=\(link2!)"
        //
        //        print(parameters)
        let postData =  parameters.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: "https://face-verification2.p.rapidapi.com/faceverification")!,timeoutInterval: Double.infinity)
        request.addValue("face-verification2.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
        request.addValue("52f79a3db8mshfb9661e9ebfd7f4p17a052jsnfc565919706d", forHTTPHeaderField: "X-RapidAPI-Key")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if (error != nil) {
                print(error!)
            } else {
                //                let httpResponse = response as? HTTPURLResponse
                if let data = data {
                    do {
                        
                        
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String:Any]  {
//                                                        print(json)
                            let data = json["data"] as? [String: Any]
                            if let message = data?["resultMessage"] {
                                print("Result Message: ",message)
                                if message as! String == "The two faces belong to the same person. " {
                                    DispatchQueue.main.async {
                                        messageData = "Data Found"
                                        self.performSegue (withIdentifier: "not-verified", sender: self)
                                    }
                                    
                                }else{
                                    print("match not found")
                                }
                            }else{
                                print("cannot find result message")
                            }
                            
                            
                            
                            //                    print(parsedData)
                            //                    print(postData)
                            
                            
                        }else{
                            print("Error on JSON Parsing")
                        }
                        
                    } catch let error {
                        print(error)
                    }
                }else {
                    //                    print(String(describing: error))
                    semaphore.signal()
                }
                
                //                print(String(data: data!, encoding: .utf8)!)
                semaphore.signal()
                
                
            }
            
        }
        
        task.resume()
        semaphore.wait()
    }
    
    
    func lottieAnimation() {
        
        
        let loadingview = UIView()
        animationView = .init(name: "search-user")
        
        animationView!.frame = view.bounds
        
        
        animationView?.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        loadingview.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        loadingview.backgroundColor = .white
        animationView?.center = view.center
        
        animationView!.loopMode = .loop
        
        animationView?.animationSpeed = 0.4
        
        self.view.addSubview(loadingview)
        
        loadingview.addSubview(self.animationView!)
        
        self.animationView!.play(fromProgress: 0, toProgress: 1) { (finished) in
            //            self.animationView?.removeFromSuperview()
        }
          
          
          
          // 6. Play animation
          
          
        
    
    }
    
    
    
}
