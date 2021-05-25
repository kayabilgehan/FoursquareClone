import UIKit

class AddPlaceViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var placeNameText: UITextField!
    @IBOutlet weak var placeTypeText: UITextField!
    @IBOutlet weak var placeDescText: UITextField!
    @IBOutlet weak var placeImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeImageView.isUserInteractionEnabled = true
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(imageSelector))
        placeImageView.addGestureRecognizer(imageGesture)
        
    }
    @objc func imageSelector(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        self.present(pickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImageView.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil	)
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        if placeNameText.text != "" && placeTypeText.text != "" && placeDescText.text != "" {
            if let choosenImage = placeImageView.image {
                PlaceModel.sharedInstance.placeName = placeNameText.text!
                PlaceModel.sharedInstance.placeType = placeTypeText.text!
                PlaceModel.sharedInstance.placeDesc = placeDescText.text!
                PlaceModel.sharedInstance.placeImage = choosenImage
                
                performSegue(withIdentifier: "toMapVC", sender: nil)
            }
        }
        else {
            let alert = UIAlertController(title: "Error", message: "Place Name/Type/Desc", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
