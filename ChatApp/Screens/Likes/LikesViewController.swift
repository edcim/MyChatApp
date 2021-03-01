//
//  LikesViewController.swift
//  ChatApp
//
//  Created by Siddhant on 28/02/21.
//

import UIKit
import CoreLocation

class LikesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblLikeedProfiles: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initialUIsetUp()
    }
    
    func initialUIsetUp() {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: Tableview Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppDelegate.sharedAppDelegate().arrOfLikes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let profileCell = tableView.dequeueReusableCell(withIdentifier: "CPMemberTableCell") as? CPMemberTableCell else {
            return UITableViewCell()
        }
        profileCell.lblName.text = AppDelegate.sharedAppDelegate().arrOfLikes[indexPath.row].name
        setProfilePicture(indexPath, profileCell)
        if let lat = AppDelegate.sharedAppDelegate().arrOfLikes[indexPath.row].geoLocation?.latitude, let lon = AppDelegate.sharedAppDelegate().arrOfLikes[indexPath.row].geoLocation?.longitude {
            geocode(latitude: lat, longitude: lon) { (placemark, error) in
                guard let placemark = placemark, error == nil else {
                    return
                }
                if let country = placemark.first?.country  {
                    profileCell.lblLocation.text = country
                } else {
                    profileCell.lblLocation.text = "NA"
                }
            }
        }
        return profileCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let member = AppDelegate.sharedAppDelegate().arrOfLikes[indexPath.row]
        guard let profileDetailsVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "ProfileDetailsViewController") as? ProfileDetailsViewController else {
            return
        }
        profileDetailsVC.member = member
        self.navigationController?.pushViewController(profileDetailsVC, animated: false)
    }
    
    // set profile picture
    fileprivate func setProfilePicture(_ indexPath: IndexPath, _ profileCell: CPMemberTableCell) {
        if let pictureUrl = AppDelegate.sharedAppDelegate().arrOfLikes[indexPath.row].picture {
            let defaultImage = UIImage(systemName: "person.circle")!
            defaultImage.withTintColor(UIColor(red: 142.0, green: 40.0, blue: 82.0, alpha: 1.0))
            profileCell.configureCellForMemberImage(with: pictureUrl, placeholderImage: defaultImage)
        }
    }
    
    // get placemark
    func geocode(latitude: Double, longitude: Double, completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemark, error in
            guard let placemark = placemark, error == nil else {
                completion(nil, error)
                return
            }
            completion(placemark, nil)
        }
    }
}
