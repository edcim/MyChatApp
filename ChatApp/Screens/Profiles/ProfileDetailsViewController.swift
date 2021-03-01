//
//  ProfileDetailsViewController.swift
//  ChatApp
//
//  Created by Siddhant on 01/03/21.
//

import UIKit
import Kingfisher
import CoreLocation
import SwiftSpinner

class ProfileDetailsViewController: UIViewController {

    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblFavColor: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var lblLastSeen: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLoc: UILabel!
    var member = ModelMeber()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    // set location
    fileprivate func setUpLocation() {
        var loc = String()
        if let lat = member.geoLocation?.latitude, let lon = member.geoLocation?.longitude {
            SwiftSpinner.show("Loading Details...")
            geocode(latitude: lat, longitude: lon) { (placemark, error) in
                
                guard let placemark = placemark, error == nil else {
                    return
                }
                if let country = placemark.first?.country  {
                    SwiftSpinner.hide()
                    loc = country
                    self.lblLoc.text = loc
                } else {
                    loc = "NA"
                    self.lblLoc.text = loc
                }
            }
        } else {
            loc = "NA"
            lblLoc.text = loc
        }
    }
    
    // set Age
    fileprivate func setUpAge() {
        if let age = member.age {
            let ageString = String(age)
            lblAge.text = ageString
        } else {
            lblAge.text = "NA"
        }
    }
    
    func setUpUI() {
        setProfilePicture(member: member)
        setUpLocation()
        lblGender.text = member.gender
        setUpAge()
        lblFavColor.text = member.favoriteColor
        lblLastSeen.text =  member.lastSeen
        lblPhone.text = member.phone
        lblId.text = member._id
        lblEmail.text = member.email
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
    
    // set profile picture
    fileprivate func setProfilePicture(member: ModelMeber) {
        if let pictureUrl = member.picture {
            let defaultImage = UIImage(systemName: "person.circle")!
            defaultImage.withTintColor(UIColor(red: 142.0, green: 40.0, blue: 82.0, alpha: 1.0))
            if let url = URL(string: pictureUrl) {
                setImage(url, defaultImage)
            } else {
                imageViewProfile.image = defaultImage
            }
        }
    }
    
    fileprivate func setImage(_ url: URL, _ placeholderImage: UIImage) {
        let processor = DownsamplingImageProcessor(size: imageViewProfile.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 20)
        imageViewProfile.kf.indicatorType = .activity
        imageViewProfile.kf.setImage(
            with: url,
            placeholder: placeholderImage,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
                self.imageViewProfile.image = value.image
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }

}
