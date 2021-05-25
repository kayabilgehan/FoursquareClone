import UIKit
import MapKit
import Parse

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButtonClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonClicked))
        
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        longTapGesture.minimumPressDuration = 1.5
        mapView.addGestureRecognizer(longTapGesture)
    }
    @objc func chooseLocation(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceModel.sharedInstance.placeName
            annotation.subtitle = PlaceModel.sharedInstance.placeType
            self.mapView.addAnnotation(annotation)
            
            
            //self.choosenLatitude = String(coordinates.latitude)
            //self.choosenLongitude = String(coordinates.longitude)
            
            PlaceModel.sharedInstance.placeLatitude = String(coordinates.latitude)
            PlaceModel.sharedInstance.placeLongitude = String(coordinates.longitude)
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        locationManager.stopUpdatingLocation()
        
    }
    @objc func saveButtonClicked () {
        //PARSE işlemleri
        
        let object = PFObject(className: "Places")
        object["name"] = PlaceModel.sharedInstance.placeName
        object["desc"] = PlaceModel.sharedInstance.placeDesc
        object["type"] = PlaceModel.sharedInstance.placeType
        object["latitude"] = PlaceModel.sharedInstance.placeLatitude
        object["longitude"] = PlaceModel.sharedInstance.placeLongitude
        
        
        //Görseli dataya çeviriyoruz
        if let imageData = PlaceModel.sharedInstance.placeImage.jpegData(compressionQuality: 0.5)
        {
            object["image"] = PFFileObject(name: "\(PlaceModel.sharedInstance.placeName).jpeg", data: imageData)
        }
        
        object.saveInBackground { success, error in
            if error != nil {
                let errorr = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                errorr.addAction(okButton)
                self.present(errorr, animated: true, completion: nil)
            }
            else {
                self.performSegue(withIdentifier: "fromMapVcToPlacesVc", sender: nil)
            }
        }
        
    }
    @objc func backButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
}
