//
//  ViewController.swift
//  201312356
//
//  Created by D7703_30 on 2017. 9. 18..
//  Copyright © 2017년 D7703_30. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,MKMapViewDelegate{
    @IBOutlet weak var myMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // plist data 가져오기
        let path = Bundle.main.path(forResource: "ViewPoint", ofType: "plist")
        print("path=\(String(describing: path))")
        
        let contents = NSArray(contentsOfFile: path!)
        print("contents=\(String(describing: contents))")
        
        // pin point를 저장하기 위한 배열 선언
        var annotations = [MKPointAnnotation]()
        
        myMapView.delegate = self
        if let myItems = contents {
            // Dictionary Array에서 값 뽑기
            for item in myItems {
        let addr = (item as AnyObject).value(forKey: "addr")
        let title = (item as AnyObject).value(forKey: "title")
                
        let geoCoder = CLGeocoder()
                
    geoCoder.geocodeAddressString(addr as! String, completionHandler: { placemarks, error in
            if let myPlacemarks = placemarks {
               let myPlacemark = myPlacemarks[0]
                        
               let annotation = MKPointAnnotation()
                   annotation.title = title as? String
                   annotation.subtitle = addr as? String
            if let myLocation = myPlacemark.location {
                   annotation.coordinate = myLocation.coordinate
                   annotations.append(annotation)
                                                    }
                                                }
            self.myMapView.showAnnotations(annotations, animated: true)
            self.myMapView.addAnnotations(annotations)
            })
            }
        } else {
            print("contents-nil")
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locateToCenter(){
    let center = CLLocationCoordinate2DMake(35.166197, 129.072594)
    let span = MKCoordinateSpanMake(0.15, 0.15)
    let region = MKCoordinateRegionMake(center, span)
        myMapView.setRegion(region, animated: true)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "MyPin"
        var  annotationView = myMapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            if annotation.title! == "시민공원" {
                // 부시민공원
                annotationView?.pinTintColor = UIColor.green
                let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
                leftIconView.image = UIImage(named:"sai1.png" )
                annotationView?.leftCalloutAccessoryView = leftIconView
                
            } else if annotation.title! == "동의과학대" {
                // 동의과학대학교
                let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
                leftIconView.image = UIImage(named:"sai2.png" )
                annotationView?.leftCalloutAccessoryView = leftIconView
                
            } else {
                // 송상현광장
                annotationView?.pinTintColor = UIColor.blue
                let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
                leftIconView.image = UIImage(named:"sai3.png" )
                annotationView?.leftCalloutAccessoryView = leftIconView
            }
        } else {
            annotationView?.annotation = annotation
        }
        
        let btn = UIButton(type: .detailDisclosure)
        annotationView?.rightCalloutAccessoryView = btn
        
        return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        print("callout Accessory Tapped!")
        
        let viewAnno = view.annotation
        let viewTitle: String = ((viewAnno?.title)!)!
        let viewSubTitle: String = ((viewAnno?.subtitle)!)!
        
        print("\(viewTitle) \(viewSubTitle)")
        
        let ac = UIAlertController(title: viewTitle, message: viewSubTitle, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
}
