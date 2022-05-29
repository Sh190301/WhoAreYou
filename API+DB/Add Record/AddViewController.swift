//
//  AddViewController.swift
//  API+DB
//
//  Created by Shreya Das on 29/05/22.
//

import UIKit
import FirebaseStorage
import Lottie

class AddViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var imageView: UIImageView!

    
    var tmpImage = UIImage() //Save Captured Image
    
    private var animationView: AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func photoPicker(_ sender: Any) {
        pickerSource()
        
    }
    @IBAction func addRecord(_ sender: Any) {
        if imageView.image != nil {
        lottieAnimation()
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
        
        let randomID = UUID.init().uuidString
        let uploadRef = Storage.storage ().reference (withPath: "images/\(randomID).jpg")
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
                                self.animationView?.removeFromSuperview()
                    self.performSegue (withIdentifier: "added", sender: self)
                            messageData = "data not found"
                }
                })
        }
        taskReference.observe(.progress) { [weak self] (snapshot) in
            guard let pctThere = snapshot.progress?.fractionCompleted else { return }
            print ("You are \(pctThere) complete")
        }
    }
    
    func lottieAnimation() {
        
        
        let loadingview = UIView()
        animationView = .init(name: "loading-file")
        
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
