//
//  ProfilesViewController.swift
//  ChatApp
//
//  Created by Siddhant on 28/02/21.
//

import UIKit
import SwiftSpinner
import CoreLocation


class ProfilesViewController: UIViewController {
    
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    @IBOutlet weak var tblProfiles: UITableView!
    var profilesFetched = [Profiles]()
    var tempProfiles = [Profiles]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.genderSegmentControl.selectedSegmentIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initialUIsetUp()
        SwiftSpinner.show("Loding Profiles")
        profilesFetched.removeAll()
        getDataFromServer()
    }
    
    func initialUIsetUp() {
        self.navigationController?.navigationBar.isHidden = false
        AppDelegate.sharedAppDelegate().arrOfLikes.removeAll()
    }
    
    fileprivate func maleSorting() {
        var arrMale = [Profiles]()
        let maleGroup = DispatchGroup()
        SwiftSpinner.show(duration: 2, title: "Loading Male Profiles", animated: true, completion: nil)
        self.tempProfiles.forEach {
            maleGroup.enter()
            if $0.gender == "male" {
                arrMale.append($0)
            }
            print("Finished request \($0)")
            maleGroup.leave()
        }
        maleGroup.notify(queue: .main) {
            print("Finished all requests.")
            self.profilesFetched.removeAll()
            self.profilesFetched.append(contentsOf: arrMale)
            self.tblProfiles.reloadData()
        }
    }
    
    func getDataFromServer() {
        let service = ProfilesService()
        service.getProfile(requestString: "http://www.json-generator.com/api/json/get/ceiNKFwyaa?indent=2",  completed:{(profiles:[Profiles]?, error:CPError?) -> Void in
            SwiftSpinner.hide()
            if(error == nil && profiles != nil){
                self.profilesFetched = profiles!
                self.tempProfiles = self.profilesFetched
                self.maleSorting()
            } else {
                DispatchQueue.main.async {
                    SwiftSpinner.hide()
                    let alert = UIAlertController(title: "Alert", message: AlertMessageServer.serverNotResponding.rawValue, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
    
    // MARK: Actions
    fileprivate func femaleSorting() {
        var arrFemale = [Profiles]()
        let femaleGroup = DispatchGroup()
        SwiftSpinner.show(duration: 2, title: "Loading Female Profiles", animated: true, completion: nil)
        profilesFetched.forEach {
            femaleGroup.enter()
            if $0.gender == "female" {
                arrFemale.append($0)
            }
            print("Finished request \($0)")
            femaleGroup.leave()
        }
        femaleGroup.notify(queue: .main) {
            print("Finished all requests.")
            self.profilesFetched.removeAll()
            self.profilesFetched.append(contentsOf: arrFemale)
//            SwiftSpinner.hide()
            self.tblProfiles.reloadData()
        }
    }
    
    @IBAction func genderSegControl(_ sender: Any) {
        switch genderSegmentControl.selectedSegmentIndex
        {
        case 0:
            profilesFetched = tempProfiles
            self.maleSorting()
        case 1:
            profilesFetched = tempProfiles
            femaleSorting()
            break
        default:
            break
        }
    }
}

extension ProfilesViewController : UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Tableview Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profilesFetched.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let profileCell = tableView.dequeueReusableCell(withIdentifier: "CPMemberTableCell") as? CPMemberTableCell else {
            return UITableViewCell()
        }
        setProfilePicture(indexPath, profileCell)
        var loc = String()
        
        if let lat = profilesFetched[indexPath.row].geoLocation?.latitude, let lon = profilesFetched[indexPath.row].geoLocation?.longitude {
            geocode(latitude: lat, longitude: lon) { (placemark, error) in
                
                guard let placemark = placemark, error == nil else {
                    return
                }
                if let country = placemark.first?.country  {
                    loc = country
                    profileCell.lblLocation.text = loc
                } else {
                    loc = "NA"
                    profileCell.lblLocation.text = loc
                }
            }
        }
        setModelData(indexPath, loc, profileCell)
        profileCell.delegate = self
        return profileCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let member = profilesFetched[indexPath.row]
        let modelMember = ModelMeber(name: member.name ?? "", isLiked: false, location: "", imageURL: member.picture ?? "", picture: member.picture ?? "", geoLocation: member.geoLocation ?? GeoLocationConfig(), gender: member.gender ?? "", age: member.age ?? Int(), favoriteColor: member.favoriteColor ?? "", phone: member.phone ?? "", lastSeen: member.lastSeen ?? "", _id: member._id ?? "", email: member.email ?? "")
        guard let profileDetailsVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "ProfileDetailsViewController") as? ProfileDetailsViewController else {
            return
        }
        profileDetailsVC.member = modelMember
        self.navigationController?.pushViewController(profileDetailsVC, animated: false)
    }
    
    func geocode(latitude: Double, longitude: Double, completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { placemark, error in
            guard let placemark = placemark, error == nil else {
                completion(nil, error)
                return
            }
            completion(placemark, nil)
        }
    }
    
    fileprivate func setProfilePicture(_ indexPath: IndexPath, _ profileCell: CPMemberTableCell) {
        if let pictureUrl = self.profilesFetched[indexPath.row].picture {
            let defaultImage = UIImage(systemName: "person.circle")!
            defaultImage.withTintColor(UIColor(red: 142.0, green: 40.0, blue: 82.0, alpha: 1.0))
            profileCell.configureCellForMemberImage(with: pictureUrl, placeholderImage: defaultImage)
        }
    }
    
    fileprivate func setModelData(_ indexPath: IndexPath, _ loc: String, _ profileCell: CPMemberTableCell) {
        let modelMember = ModelMeber(name: profilesFetched[indexPath.row].name ?? "", isLiked: false, location: loc, imageURL: profilesFetched[indexPath.row].picture ?? "", picture: profilesFetched[indexPath.row].picture ?? "", geoLocation: profilesFetched[indexPath.row].geoLocation ?? GeoLocationConfig(), gender: profilesFetched[indexPath.row].gender ?? "", age: profilesFetched[indexPath.row].age ?? Int(), favoriteColor: profilesFetched[indexPath.row].favoriteColor ?? "", phone: profilesFetched[indexPath.row].phone ?? "", lastSeen: profilesFetched[indexPath.row].lastSeen ?? "", _id: profilesFetched[indexPath.row]._id ?? "", email: profilesFetched[indexPath.row].email ?? "")
        profileCell.setValues(member: modelMember)
        profileCell.setBtnValue(member: modelMember)
    }
    
}

extension ProfilesViewController : CPMemberTableCellDelegate {
    func likeDislikeAction(cell: CPMemberTableCell, member: ModelMeber) {
        cell.btnLike.setTitle("Liked", for: .normal)
        AppDelegate.sharedAppDelegate().arrOfLikes.append(member)
    }
}
