//
//  CPMemberTableCell.swift
//  ChatApp
//
//  Created by Siddhant on 28/02/21.
//

import UIKit
import Kingfisher

protocol CPMemberTableCellDelegate {
    func likeDislikeAction(cell: CPMemberTableCell, member: ModelMeber)
}

public class ModelMeber {
    var name : String?
    var isLiked : Bool?
    var location : String?
    var imageURL : String?
    var picture: String?
    var geoLocation: GeoLocationConfig?
    var gender : String?
    var age: Int?
    var favoriteColor: String?
    var phone: String?
    var lastSeen: String?
    var _id: String?
    var email: String?
    
    init(name : String, isLiked: Bool, location: String, imageURL: String, picture: String, geoLocation: GeoLocationConfig, gender: String, age: Int, favoriteColor: String, phone: String, lastSeen: String, _id: String, email: String) {
        self.name = name
        self.isLiked = isLiked
        self.location = location
        self.imageURL = imageURL
        self.picture = picture
        self.geoLocation = geoLocation
        self.gender = gender
        self.age = age
        self.favoriteColor = favoriteColor
        self.phone = phone
        self.lastSeen = lastSeen
        self._id = _id
        self.email = email
    }
    
    init(isLiked: Bool) {
        self.isLiked = isLiked
    }
    
    init() {
        
    }
}

class CPMemberTableCell: UITableViewCell {

    @IBOutlet weak var imageViewProfiel: UIImageView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    var delegate:CPMemberTableCellDelegate?
    var indexPathRow = Int()
    var memberModel = ModelMeber()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setValues(member: ModelMeber) {
        memberModel = member
        self.lblName.text = member.name
    }
    
    func setBtnValue(member: ModelMeber) {
        guard let isLiked = member.isLiked else {
            return
        }
        if isLiked {
            btnLike.setTitle("Dislike", for: .normal)
        } else {
            btnLike.setTitle("Like", for: .normal)
        }
    }
    
    fileprivate func setImage(_ url: URL, _ placeholderImage: UIImage) {
        let processor = DownsamplingImageProcessor(size: imageViewProfiel.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 5)
        imageViewProfiel.kf.indicatorType = .activity
        imageViewProfiel.kf.setImage(
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
                self.imageViewProfiel.image = value.image
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
    
    func configureCellForMemberImage(with urlString: String, placeholderImage: UIImage) {
        if(urlString.isEmpty == false){
            if let url = URL(string: urlString) {
                setImage(url, placeholderImage)
            } else {
                imageViewProfiel.image = placeholderImage
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func actionLickButton(_ sender: Any) {
        self.delegate?.likeDislikeAction(cell: self, member: memberModel)
    }
    
}
