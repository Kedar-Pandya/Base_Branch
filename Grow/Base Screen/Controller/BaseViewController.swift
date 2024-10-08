//
//  BaseViewController.swift
//  Grow
//
//  Created by Kedarnath Pandya on 26/09/24.
//

import UIKit
import SideMenu
import CoreLocation

class BaseViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var sideMenu : SideMenuNavigationController?
    var greeting = ""
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    @IBOutlet weak var lblGreetings: UILabel!
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblTemprature: UILabel!
    @IBOutlet weak var cardCollectionView: UICollectionView!
    @IBOutlet weak var serviceCollectionView: UICollectionView!
    
    let images = ["image1", "image2", "image3", "image4", "image5", "image6"]
    let cardImage = ["image7", "image8", "image9", "image10", "image11"]
    let labels = ["Plant Care", "Plants and More", "Plant Decore in AR", "Plant Recognition", "About the app", "FAQ?"]
    let heading = ["India", "Sweden", "United Kingdom", "United States", "France"]
    let subHeading = ["2070", "2045", "2050", "2050", "2050"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        onTimeGreet()
        
        weatherView.layer.cornerRadius = 10
        weatherView.clipsToBounds = true
        
        let nib = UINib(nibName: "CardCollectionViewCell", bundle: nil)
        cardCollectionView.register(nib, forCellWithReuseIdentifier: "CardViewCell")
        
        let serviceNib = UINib(nibName: "CustomCollectionViewCell", bundle: nil)
        serviceCollectionView.register(serviceNib, forCellWithReuseIdentifier: "ServiceViewCell")
        
        cardCollectionView.dataSource = self
        cardCollectionView.delegate = self
        
        serviceCollectionView.dataSource = self
        serviceCollectionView.delegate = self
        
        sideMenu = SideMenuNavigationController(rootViewController: UIViewController())
        
        sideMenu?.leftSide = true
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            reserveGeocodeLocation(location: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Fail to find locationn: \(error.localizedDescription)")
    }
    
    func reserveGeocodeLocation(location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reserve Geocode Failed: \(error.localizedDescription)")
                self.lblLocation.text = "Error to fetch location"
                return
            }
            
            if let placemark = placemarks?.first {
                let city = placemark.locality ?? "Unknown city"
                self.lblLocation.text = "\(city)"
            } else {
                self.lblLocation.text = "No location found"
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cardCollectionView {
            return heading.count
        } else if collectionView == serviceCollectionView {
            return images.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == serviceCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceViewCell", for: indexPath) as! CustomCollectionViewCell
            cell.layer.cornerRadius = 25.0
            cell.layer.masksToBounds = true
            cell.imageView?.image = UIImage(named: images[indexPath.item])
            cell.label.text = labels[indexPath.item]
            return cell
        }
        else if collectionView == cardCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardViewCell", for: indexPath) as! CardCollectionViewCell
            cell.layer.cornerRadius = 25.0
            cell.layer.masksToBounds = true
            cell.lblHeadline.text = heading[indexPath.item]
            cell.lblSubHeadline.text = "set an ambitious goal to become carbon neutral by \(subHeading[indexPath.item])"
            cell.img.image = UIImage(named: cardImage[indexPath.item])
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    @IBAction func btnSideAction(_ sender: Any) {
        present(sideMenu!, animated: true)
    }
    
    func onTimeGreet() {
        
        let date = NSDate()
        let calendar = NSCalendar.current
        let currentHour = calendar.component(.hour, from: date as Date)
        let hourInt = Int(currentHour.description)!
        
        if hourInt > 12 && hourInt <= 18 {
            greeting = "Good Afternoon"
        }
        else if hourInt >= 4 && hourInt <= 12 {
            greeting = "Good Morning"
        }
        else if hourInt > 18 && hourInt <= 24 {
            greeting = "Good Evening"
        }
        else if hourInt >= 1 && hourInt < 4 {
            greeting = "Good Night"
        }
        
        lblGreetings.text = greeting
    }
}
