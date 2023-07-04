//
//  UpdateProfileVC.swift
//  MVP+CoreData
//
//  Created by Umang on 16/06/23.
//

import UIKit

class UpdateProfileVC: UIViewController {
    
    //    MARK: - Outlets
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var lblHeader: UILabel!
    
    @IBOutlet weak var txtFName: UITextField!
    @IBOutlet weak var txtLName: UITextField!
    
    //    MARK: - Variables
    let presenter = ProfilePresenter()
    var isForAdd = false
    var fname = ""
    var lname = ""
    var profile = UIImage()
    var userIdToUpdate: Int64 = 0
    
    //    MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.setViewDelegate(delegate: self)
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setData()
    }
}

//    MARK: - Common functions
extension UpdateProfileVC {
    func setupUI() {
        imgProfile.setCorners(ofRadius: 15)
        btnEdit.roundedCorners()
        btnUpdate.setCorners()
        lblHeader.text = isForAdd ? "Add User" : "Update User"
        btnUpdate.setTitle(isForAdd ? "Add" : "Update", for: .normal)
    }
    
    func setData() {
        DispatchQueue.main.async { [self] in
            txtFName.text = fname
            txtLName.text = lname
            imgProfile.image = profile
        }
    }
    
    func openImagePicker() {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        present(controller, animated: true, completion: nil)
    }
}

//    MARK: - Actions
extension UpdateProfileVC {
    @IBAction func btnEditAction(_ sender: UIButton) {
        openImagePicker()
    }
    
    @IBAction func btnUpdateAction(_ sender: UIButton) {
        if txtFName.text == "" {
            self.showToast("Please enter first name")
        } else if txtLName.text == "" {
            self.showToast("Please enter last name")
        } else {
            let params: [String: Any] = [
                "image": imgProfile.image?.pngData() ?? Data(),
                "fname": txtFName.text ?? "",
                "lname": txtLName.text ?? "",
                "userId": userIdToUpdate
            ]
            
            if isForAdd {
                presenter.addNewUser(params: params)
            } else {
                presenter.updateUser(params: params)
            }
        }
    }
    
     @IBAction func btnBackAction(_ sender: Any) {
         navigationController?.popViewController(animated: true)
     }
}

//      MARK: - ProfilePresenterDelegate Methods
extension UpdateProfileVC: ProfilePresenterDelegate {
    func didAddedUser(success: Bool) {
        if success {
            navigationController?.popViewController(animated: true)
        } else {
            self.showToast("Opps... something went wrong")
        }
    }
    
    func didUpdateUser(success: Bool) {
        if success {
            navigationController?.popViewController(animated: true)
        } else {
            self.showToast("Opps... something went wrong")
        }
    }
}

//      MARK: - UIImagePickerControllerDelegate Methods
extension UpdateProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imgProfile.image = image
            self.dismiss(animated: true)
        }
    }
}
