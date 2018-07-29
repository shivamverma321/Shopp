//
//  File.swift
//  Shopp
//
//  Created by Nikhil Sridhar on 7/28/18.
//  Copyright © 2018 rsrn. All rights reserved.
//

import Foundation
import UIKit


//adds a border to any view
public extension UIView {
    
    @discardableResult func addBorders(edges: UIRectEdge, color: UIColor = .green, thickness: CGFloat = 1.0, offsetR: CGFloat = 0) -> [UIView] {
        
        var borders = [UIView]()
        
        func border() -> UIView {
            let border = UIView(frame: CGRect.zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            return border
        }
        
        if edges.contains(.top) || edges.contains(.all) {
            let top = border()
            addSubview(top)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top(==thickness)]",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["top": top]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[top]-(\(offsetR))-|",
                    options: [],
                    metrics: nil,
                    views: ["top": top]))
            borders.append(top)
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            let left = border()
            addSubview(left)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[left(==thickness)]",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["left": left]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[left]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["left": left]))
            borders.append(left)
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            let right = border()
            addSubview(right)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-(0)-|",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["right": right]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[right]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["right": right]))
            borders.append(right)
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            let bottom = border()
            addSubview(bottom)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-(0)-|",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["bottom": bottom]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[bottom]-(\(offsetR))-|",
                    options: [],
                    metrics: nil,
                    views: ["bottom": bottom]))
            borders.append(bottom)
        }
        
        return borders
    }
    
}

//changes the text of a search bar
public extension UISearchBar {
    
    func change(textFont : UIFont?) {
        for view: UIView in (self.subviews[0]).subviews {
            if let textField = view as? UITextField {
                textField.font = textFont
            }
        }
    }
    
}

//returns the name of a date's month
public extension Date {
    
    func monthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    
}

//returns the currency string representation of a double
public extension Double{
    
    func dollarCurrency() -> String{
        return String(format: "$%.02f", self)
    }
    
}

//returns the number of digits in an int
public extension Int {
    
    var digitCount: Int {
        get {
            return numberOfDigits(in: self)
        }
    }
    
    private func numberOfDigits(in number: Int) -> Int {
        if abs(number) < 10 {
            return 1
        } else {
            return 1 + numberOfDigits(in: number/10)
        }
    }
    
}

//adjusts a textfield's appearance based on the relative accuracy of its content
public extension UITextField {
    
    func correctColorScheme() {
        backgroundColor = UIColor.white
        textColor = UIColor.black
        if let placeholder = placeholder{
            attributedPlaceholder = NSAttributedString(string: placeholder,
                                                       attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        }
    }
    func incorrectColorScheme() {
        backgroundColor = UIColor.red
        textColor = UIColor.white
        if let placeholder = placeholder{
            attributedPlaceholder = NSAttributedString(string: placeholder,
                                                       attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        }
    }
    
}

//creates an image with a solid color
public extension UIImage {
    
    public convenience init(color: UIColor, size: CGSize = CGSize(width: 100, height: 100)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let cgImage = image!.cgImage!
        self.init(cgImage: cgImage)
    }
    
}

//returns the textfield's text if it is a given type
//returns if the textfield's text is a given type
public extension UITextField {
    
    var name: String?{
        guard let text = self.text, text.count > 1, text.count < 15 else {
            return nil
        }
        return text
    }
    func textIsAName() -> Bool{
        guard let text = self.text, text.count > 1, text.count < 15 else {
            return false
        }
        return true
    }
    var phoneNumber: String?{
        guard let text = self.text, text.count == 10 else {
            return nil
        }
        return text
    }
    func textIsAPhoneNumber() -> Bool{
        guard let text = self.text, text.count == 10 else {
            return false
        }
        return true
    }
    var email: String?{
        guard let text = self.text, text.count > 7, text.count < 50, text.contains("@"), text.contains(".") else {
            return nil
        }
        return text
    }
    func textIsAnEmail() -> Bool{
        guard let text = self.text, text.count > 7, text.count < 50, text.contains("@"), text.contains(".") else {
            return false
        }
        return true
    }
    var username: String?{
        guard let text = self.text, text.count > 5, text.count < 20 else {
            return nil
        }
        return text
    }
    func textIsAUsername() -> Bool{
        guard let text = self.text, text.count > 5, text.count < 20 else {
            return false
        }
        return true
    }
    var password: String?{
        guard let text = self.text, text.count > 5, text.count < 25 else {
            return nil
        }
        return text
    }
    func textIsAPassword() -> Bool{
        guard let text = self.text, text.count > 5, text.count < 25 else {
            return false
        }
        return true
    }
    
}

//creates a button shake effect
public extension UIView {
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-15.0, 15.0, -15.0, 15.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
}

//returns the string representation of the integer with commas inserted in the appropriate places
public extension Int {
    
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
    
}

//returns the string representation of the date
public extension Date{
    
    var creationString: String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        let day = calendar.component(.day, from: self)
        let defaultDateText = "Created " + self.monthName() + " \(day), \(year)"
        
        return defaultDateText
        /*
         let units = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second, .weekOfYear])
         let components = Calendar.current.dateComponents(units, from: self, to: Date())
         
         if components.year! > 0 || components.month! > 0 || components.weekOfYear! > 0{
         return defaultDateText
         
         } else if (components.day! > 0) {
         return "Created " + (components.day! > 1 ? "\(components.day!) days ago" : "yesterday")
         
         } else if components.hour! > 0 {
         return "Created " + "\(components.hour!) " + (components.hour! > 1 ? "hours ago" : "hour ago")
         
         } else if components.minute! > 0 {
         return "Created " + "\(components.minute!) " + (components.minute! > 1 ? "minutes ago" : "minute ago")
         
         } else {
         return "Created " + "\(components.second!) " + (components.second! > 1 ? "seconds ago" : "second ago")
         }
         */
    }
    
}

enum AlertType{
    case dataRetrievalFailed
    case requestFailed
}

//presents an alert to notify the current user about an error which occurred in the database
extension UIViewController {
    
    func issueAlert(ofType type: AlertType) {
        var alertController = UIAlertController()
        switch type {
        case .dataRetrievalFailed:
            alertController = UIAlertController(title: "Error", message: "A problem occurred while retrieving your data", preferredStyle: .alert)
        case .requestFailed:
            alertController = UIAlertController(title: "Error", message: "A problem occurred while performing your request", preferredStyle: .alert)
        }
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}

//detects if the user's device is an iPhone X
extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
}

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var startColor: UIColor = .black { didSet{ updateColors() }}
    @IBInspectable var middleColor: UIColor = .white { didSet{ updateColors() }}
    @IBInspectable var endColor: UIColor = .white { didSet{ updateColors() }}
    @IBInspectable var startLocation: Double = 0.05 { didSet{ updateLocations() }}
    @IBInspectable var middleLocation: Double = 0.05 { didSet{ updateLocations() }}
    @IBInspectable var endLocation: Double = 0.95 { didSet{ updateLocations() }}
    @IBInspectable var horizontalMode: Bool = false { didSet{ updatePoints() }}
    @IBInspectable var diagonalMode: Bool = false { didSet{ updatePoints() }}
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    var gradientLayer: CAGradientLayer {
        return (layer as? CAGradientLayer)!
    }
    
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 1, y: 0): CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 0, y: 1): CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 0, y: 0): CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 1, y: 1): CGPoint(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, middleLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, middleColor.cgColor, endColor.cgColor]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        updateLocations()
        updateColors()
    }
}

