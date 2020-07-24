//
//  Extentions.swift
//  WaveMP
//
//  Created by Samuel Tsokwa on 2020-04-06.
//  Copyright © 2020 Samuel Tsokwa. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer

extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 8, height: 16)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    static func fromRoundImage(size: CGSize, backgroundColor: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(backgroundColor.cgColor)
        context?.setStrokeColor(UIColor.clear.cgColor)
        let bounds = CGRect(origin: .zero, size: size)
        context?.addEllipse(in: bounds)
        context?.drawPath(using: .fill)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
extension UIImage {
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
extension MPMediaPlaylist
{
//    func artworkImageArray() -> [UIImage]
//    {
//        let size = CGSize(width: 187.5, height: 161)
//        var images = [UIImage]()
//
//        
//        for item in self.items
//        {
//            let itemimage = item.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
//            let img = itemimage?.image(at: size)
//            images.append(img!)
//        }
//        
//        let imageswithoutduplicates = images.uniqued()
//        var finalimagearray = [UIImage]()
//        if imageswithoutduplicates.count >= 4 {
//            finalimagearray = Array(imageswithoutduplicates[0 ..< 4])
//        } else {
//            finalimagearray = imageswithoutduplicates
//        }
//        
//        return finalimagearray
//    }
}


extension MPMediaItemCollection
{
    enum StorageType {
        case userDefaults
        case fileSystem
    }
    func artworkImageArray(size : CGSize) -> [UIImage]
    {
        //let size = CGSize(width: 187.5, height: 161)
        var images = [UIImage]()

        
        
        for item in self.items
        {
            if let itemimage = item.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork
            {
                let img = itemimage.image(at: size)
                
                 let temp = img?.resizeImage(targetSize: size)
                 //let ace = img?.resizeCG(size: size)
                 //if img != nil{images.append(temp!)}
                 if img != nil{images.append(temp!)}
               
            }
//            else
//            {
//                let temp = UIImage(named: "defaultmusicimage")
//                images.append(temp!)
//            }

        }
        
//        let imageswithoutduplicates = images.uniqued()
        let imageswithoutduplicates = images.unique{ $0.pngData() }
        var finalimagearray = [UIImage]()
        if imageswithoutduplicates.count >= 4
        {
            finalimagearray = Array(imageswithoutduplicates[0 ..< 4])
        }
        else {
            finalimagearray = imageswithoutduplicates
        }
        return finalimagearray
    }
        func collageImage (rect:CGRect, images:[UIImage]) -> UIImage
        {

            UIGraphicsBeginImageContext(rect.size)
            UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
            
           
            if images.count >= 4
            {
                images[0].draw(at: CGPoint.zero)
                images[1].draw(at: CGPoint(x: rect.width / 2, y: 0))
                images[2].draw(at: CGPoint(x: 0, y: rect.height / 2))
                images[3].draw(at: CGPoint(x: rect.width / 2, y: rect.height / 2))
            }


            
  
            let outputImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return outputImage!

        }
    
  
    
   
}

public extension Array where Element: Hashable {


    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return self.filter { seen.insert($0).inserted }
    }
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }

        return arrayOrdered
    }
}


extension UISearchBar {
    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }
    func setTextField(color: UIColor) {
        guard let textField = getTextField() else { return }
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = color.cgColor
            textField.layer.cornerRadius = 6
        case .prominent, .default: textField.backgroundColor = color
        @unknown default: break
        }
    }
}
extension UISearchBar {

     func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UILabel {

    func addImageWith(name: String, behindText: Bool) {

        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: name)
        let attachmentString = NSAttributedString(attachment: attachment)

        guard let txt = self.text else {
            return
        }

        if behindText {
            let strLabelText = NSMutableAttributedString(string: txt)
            strLabelText.append(attachmentString)
            self.attributedText = strLabelText
        } else {
            let strLabelText = NSAttributedString(string: txt)
            let mutableAttachmentString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(strLabelText)
            self.attributedText = mutableAttachmentString
            print(self.attributedText)
        }
    }

    func removeImage() {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
    
}

extension UIImage {
  func resizeImage(targetSize: CGSize) -> UIImage {
    //let size = self.size
//    let widthRatio  = targetSize.width  / size.width
//    let heightRatio = targetSize.height / size.height
    //let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    let rect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
    UIGraphicsBeginImageContextWithOptions(targetSize, false, 0)
    self.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
  }
    func resizeCG(size:CGSize) -> UIImage? {
        let bitsPerComponent = self.cgImage!.bitsPerComponent
        let bytesPerRow = self.cgImage!.bytesPerRow
        let colorSpace = self.cgImage!.colorSpace
        let bitmapInfo = self.cgImage!.bitmapInfo
        
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace!, bitmapInfo: bitmapInfo.rawValue)
        context!.interpolationQuality = .high
        context!.draw(self.cgImage!, in: CGRect(origin: CGPoint.zero, size: size))
        //CGContextDrawImage(context, CGRect(origin: CGPoint.zero, size: size), self.cgImage)
        
        return context!.makeImage().flatMap { UIImage(cgImage: $0) }
    }
}



extension UIColor
{
     static var logocolor = UIColor(named: "LogoColor")
}
extension UINavigationController {

    func setStatusBar(backgroundColor: UIColor) {
        let statusBarFrame: CGRect
        if #available(iOS 13.0, *) {
            statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
        } else {
            statusBarFrame = UIApplication.shared.statusBarFrame
        }
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.backgroundColor = backgroundColor
        view.addSubview(statusBarView)
    }

}
