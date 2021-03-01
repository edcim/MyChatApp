//
//  HomeViewController.swift
//  ChatApp
//
//  Created by Siddhant on 27/02/21.
//

import UIKit
import SwiftSpinner

class HomeViewController: UIViewController, UITabBarControllerDelegate, UITabBarDelegate {

    
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tabBarHome: UITabBar!
    var name = String()
    var dob = String()
    var user = SignUpModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarHome.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserProfile()
        updateUI()
    }
    
    func getUserProfile() {
        let service : HomeDBService = HomeDBService()
        SwiftSpinner.show(duration: 2, title: "Loading My Profile", animated: true, completion: nil)
        user = service.getUser(name: name, dob: dob)
        SwiftSpinner.hide()
    }
    
    func updateUI() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated: true)
        let rightButtonItem = UIBarButtonItem.init(
              title: "Logout",
            style: .done,
              target: self,
            action: #selector(rightButtonAction)
        )

        self.navigationItem.rightBarButtonItem = rightButtonItem
        
        self.tabBarHome.selectedItem = self.tabBarHome.items?[0]
        self.lblName.text = user.name
        if let imagePath = user.imageURL {
            let url = URL(fileURLWithPath: imagePath)
            do {
                let imageData = try Data(contentsOf: url)
                imageViewProfile.image = UIImage(data: imageData)
            } catch {
                print("Error loading image : \(error)")
            }
        }
    }
    @objc func rightButtonAction(sender: UIBarButtonItem) {
        AppDelegate.sharedAppDelegate().isFromHome = true
        UserDefaults.standard.set(false, forKey: NSMyProfileDefaultKeys.isLoginDone.rawValue)
        let loginVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginViewController")
        self.navigationController?.pushViewController(loginVC, animated: false)
    }

    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = item.tag
        switch index {
        case 0:
            break
        case 1:
            let profileVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "ProfilesViewController")
            self.navigationController?.pushViewController(profileVC, animated: false)
        case 2:
            let likesVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "LikesViewController")
            self.navigationController?.pushViewController(likesVC, animated: false)
        default:
            break
        }
    }
}
