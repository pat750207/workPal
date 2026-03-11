//
//  UIImage+Extension.swift
//  bet188asia
//
//  Created by Pat Chang on 2016/8/11.
//  Copyright © 2016年 Xuenn. All rights reserved.
//
import UIKit

extension UIImage {
    
    typealias MB = CGFloat
    
    enum JPEGQuality: CGFloat, CaseIterable {
        case highest  = 1.0
        case higher   = 0.9
        case high     = 0.75
        case medium   = 0.5
        case low      = 0.25
        case lowest   = 0.1
    }
    
    func compressed(to quality: JPEGQuality) -> Data? {
        return self.jpegData(compressionQuality: quality.rawValue)
    }
    
    func compressed(to size: MB) -> Data? {
        guard let _ = cgImage else { return nil }
        #if false
        let size = size*CGFloat(1<<20)
        var imageData = UIImageJPEGRepresentation(self, JPEGQuality.original.rawValue)
        while let data = imageData, CGFloat(data.count) > size, let image = UIImage(data: data) {
            imageData = UIImageJPEGRepresentation(image, size/CGFloat(data.count))
        }
        return imageData
        #else
        for quality in JPEGQuality.allCases.filter({ $0 != .highest && $0 != .higher }) {
            guard let data = compressed(to: quality) else { return nil }
            if CGFloat(data.count) < size*CGFloat(1<<20) { return data }
        }
        return UIImage(data: compressed(to: .lowest)!)?.compressed(to: size)
        #endif
    }
}

extension UIImage {
    static func fromColor(_ color: UIColor) -> UIImage {
        return fromColor(color, size: CGSize(width: 1, height: 1))
    }
    
    static func fromColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    
    // MARK : - Proportional image width & height to scale
    func widthForHeight(_ height: CGFloat) -> CGFloat {
        return size.width/size.height*height
    }
    
    func heightForWidth(_ width: CGFloat) -> CGFloat {
        return size.height/size.width*width
    }
    
    func scaledTo(size newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func tintedWithLinearGradientColors(colorsArray: [CGColor]) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1, y: -1)

        context.setBlendMode(.normal)
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)

        // Create gradient
        let colors = colorsArray as CFArray
        let space = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: space, colors: colors, locations: nil)

        // Apply gradient
        context.clip(to: rect, mask: self.cgImage!)
        context.drawLinearGradient(gradient!, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: self.size.height), options: .drawsAfterEndLocation)
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return gradientImage!
    }
}


extension UIImage {
    var grayed: (CIColor) -> UIImage {
        {
            guard let ciImage = CIImage(image: self) else { return self }
            let filterParameters = [ kCIInputColorKey: $0, kCIInputIntensityKey: 1.0 ] as [String: Any]
            let grayscale = ciImage.applyingFilter("CIColorMonochrome", parameters: filterParameters)
            return UIImage(ciImage: grayscale)
        }
    }
}
