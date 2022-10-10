//
//  CameraViewController.swift
//  Parstagram
//
//  Created by Nelson  on 10/2/22.
//

import UIKit
import AlamofireImage
import Parse
import MBProgressHUD

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    
    @IBAction func onSubmitButton(_ sender: Any) {
        let hud = MBProgressHUD.showAdded( to: view, animated:true)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = "Uploading...";
        hud.label.font = UIFont.systemFont(ofSize: 20)
        //hud.detailsLabel.text = "(1/1 Post)"
        
        let post = PFObject(className: "Posts")
        
        post["user"] = PFUser.current()!
        post["caption"] = commentField.text!
        
        let imageData = uploadImage.image!.pngData()
        let file = PFFileObject(name: "image.png", data: imageData!)
        post["image"] = file
        
        post.saveInBackground{  (success, error) in
            usleep(3000)
            hud.hide(animated: true)
            if success {
                self.dismiss(animated: true)
                print("saved!")
            
            } else {
                print("Error!")
            }
        }
    }
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 374, height: 350)
        let scaledImage = image.af.imageAspectScaled(toFill: size)
        
        uploadImage.image = scaledImage
        dismiss(animated: true)
        
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
