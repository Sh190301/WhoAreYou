//
//  RecordAddedVC.swift
//  API+DB
//
//  Created by Shreya Das on 29/05/22.
//

import UIKit
import Lottie

class RecordAddedVC: UIViewController {
    
    private var animationView: AnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lottieAnimation()
    }
    
    func lottieAnimation() {
           
           let loadingview = UIView()
           animationView = .init(name: "tick")
           
           animationView!.frame = view.bounds
           
           
           animationView?.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
           loadingview.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
           loadingview.backgroundColor = .white
           animationView?.center = view.center
           
           animationView!.loopMode = .playOnce
           
           animationView?.animationSpeed = 0.4
           
           
           view.addSubview(self.animationView!)
           
           self.animationView!.play(fromProgress: 0, toProgress: 1) { (finished) in
                           self.animationView?.removeFromSuperview()
           }
             
             
             
             //  Play animation
             
             
           
       
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
