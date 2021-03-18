//
//  MemberVC.swift
//  MovieSelection
//
//  Created by 李易潤 on 2021/3/18.
//

import UIKit
import Firebase

class MemberVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var auth: Auth!
    
    @IBOutlet weak var photoImage: UIImageView!
    
    @IBOutlet weak var changePhoto: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        changePhoto.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 30), forImageIn: .normal)
        auth = Auth.auth()

    }
    
    @IBAction func LogoutButton(_ sender: Any) {
        do {
            try auth.signOut()
            self.navigationController?.popViewController(animated: true)
        } catch let error as NSError {
            print("Error signing out, error: \(error.localizedDescription)")
        }
    }

    @IBAction func changePhoto(_ sender: Any) {
        let imagePicker = UIImagePickerController()

        imagePicker.delegate = self
        // 照片來源為相簿
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let pickedImage = info[.originalImage] as? UIImage {
            photoImage.image = pickedImage
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
