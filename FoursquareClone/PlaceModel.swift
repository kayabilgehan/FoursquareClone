import Foundation
import UIKit

public class PlaceModel {
    static let sharedInstance = PlaceModel()
    var placeName = ""
    var placeType = ""
    var placeDesc = ""
    var placeImage = UIImage()
    var placeLatitude = ""
    var placeLongitude = ""
    private init() {}
}
