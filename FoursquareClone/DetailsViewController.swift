import UIKit
import MapKit
import Parse

class DetailsViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var detailsNameLabel: UILabel!
    @IBOutlet weak var detailsTypeLabel: UILabel!
    @IBOutlet weak var detailsDescLabel: UILabel!
    @IBOutlet weak var detailsMapView: MKMapView!
    
    var choosenPlaceId = ""
    var choosenLatitude = Double()
    var choosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(choosenPlaceId)
        
        detailsMapView.delegate = self
        
        getDataFromParse()
    }
    
    func getDataFromParse() {
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: choosenPlaceId)
        query.findObjectsInBackground { objects, error in
            if error != nil {
                
            }
            else {
                //print(objects)
                if objects != nil && objects!.count > 0 {
                    
                    //OBJECTS
                    let choosenObject = objects![0]
                    if let placeName = choosenObject.object(forKey: "name") as? String {
                        self.detailsNameLabel.text = placeName
                    }
                    if let placeType = choosenObject.object(forKey: "type") as? String {
                        self.detailsTypeLabel.text = placeType
                    }
                    if let placeDesc = choosenObject.object(forKey: "desc") as? String {
                        self.detailsDescLabel.text = placeDesc
                    }
                    if let placeLat = choosenObject.object(forKey: "latitude") as? String {
                        if let placeLatitudeDouble = Double(placeLat){
                            self.choosenLatitude = placeLatitudeDouble
                        }
                    }
                    if let placeLon = choosenObject.object(forKey: "longitude") as? String {
                        if let placeLongitudeDouble = Double(placeLon){
                            self.choosenLongitude = placeLongitudeDouble
                        }
                    }
                    
                    if let imageData = choosenObject.object(forKey: "image") as? PFFileObject{
                        imageData.getDataInBackground { data, error in
                            if error == nil && data != nil {
                                self.detailsImageView.image = UIImage(data: data!)
                            }
                        }
                    }
                    
                    //MAPS
                    let location = CLLocationCoordinate2D(latitude: self.choosenLatitude, longitude: self.choosenLongitude)
                    let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                    let region = MKCoordinateRegion(center: location, span: span)
                    self.detailsMapView.setRegion(region, animated: true)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location
                    annotation.title = self.detailsNameLabel.text
                    annotation.subtitle = self.detailsTypeLabel.text
                    self.detailsMapView.addAnnotation(annotation)
                    
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //kullanıcının yeri ise hiçbişey yapma
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        }
        else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.choosenLongitude != 0.0 && self.choosenLatitude != 0.0 {
            let requestLocation = CLLocation(latitude: self.choosenLatitude, longitude: self.choosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let mkPlacemark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlacemark)
                        mapItem.name = self.detailsNameLabel.text
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    }

}
