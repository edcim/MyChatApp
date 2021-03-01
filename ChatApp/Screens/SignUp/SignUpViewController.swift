//
//  SignUpViewController.swift
//  ChatApp
//
//  Created by Siddhant on 27/02/21.
//

import UIKit

class SignUpViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    
    @IBOutlet weak var lblTopSignUp: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var textFieldName: UITextField!
    
    @IBOutlet weak var lblDateOfBirth: UILabel!
    
   
    @IBOutlet weak var textFieldDOB: UITextField!
    
    @IBOutlet weak var lblGender: UILabel!
    
    @IBOutlet weak var segmentControllGender: UISegmentedControl!
    
    @IBOutlet weak var lblProfilePicture: UILabel!
    
    @IBOutlet weak var imageViewProfilePreview: UIImageView!
    
    @IBOutlet weak var btnChoosePicture: UIButton!
    
    @IBOutlet weak var btnSignUp: UIButton!
    
    var selectedGender = ""
    var imagePicker = UIImagePickerController()
    var imageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialUISetUp()
    }
    
    // MARK: - Initial UI Setup
    func initialUISetUp() {
        self.navigationController?.navigationBar.isHidden = false
    }

    // MARK: - Actions
    
    @IBAction func btnChoosePictureAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                    print("Button capture")
                    imagePicker.delegate = self
                    imagePicker.sourceType = .savedPhotosAlbum
                    imagePicker.allowsEditing = false
                    present(imagePicker, animated: true, completion: nil)
                }
    }
    
    @IBAction func btnSignUpAction(_ sender: Any) {
        if let name = textFieldName.text {
            if let dob = textFieldDOB.text {
                let modelSignUp = SignUpModel(name: name, dob: dob, imageURL: self.imageURL, gender: self.selectedGender)
                self.insertUser(model: modelSignUp)
            } else {
                let alert = UIAlertController(title: "Alert", message: "Date birth should not be empty..!!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            }
        } else {
            let alert = UIAlertController(title: "Alert", message: "Name should not be empty..!!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        self.navigationController?.popViewController(animated: false)
    }
    
    
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentControllGender.selectedSegmentIndex
        {
        case 0:
            selectedGender = "male"
        case 1:
            selectedGender = "female"
        default:
            break
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageViewProfilePreview.image = image
        } else {
            print("No image found")
        }
        if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? NSURL {
            let urlString = imageURL.path
            self.imageURL = urlString ?? ""
        }
    }
    
    func insertUser(model:SignUpModel) {
        let service: SignUpService = SignUpService()
        service.saveUser(model: model)
    }
}
