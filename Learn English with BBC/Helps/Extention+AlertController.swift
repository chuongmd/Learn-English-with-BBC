//
//  Extention+AlertController.swift
//  Learn English with BBC
//
//  Created by chuongmd on 11/5/18.
//  Copyright © 2018 chuongmd. All rights reserved.
//
import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView
{
    //Hàm tải image sử dụng bộ nhớ tạm Cache
    func loadImageCacheWithUrlString(urlString: String, imageSize: CGSize)
    {
        //Kiểm tra xem trong Cache đã có Image chưa
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject)
        {
            self.image = (cacheImage as! UIImage)
            return
        }
        
        //Ngược lại khi trong bộ nhớ Cache không có Image
        let url = URL(string: urlString)
        if (url == nil)
        {
            print("Địa chỉ không tồn tại: \(String(describing: url))")
            return
        } else
        {
            URLSession.shared.dataTask(with: url!)
            { (data, response, error) in
                
                //Xuất hiện lỗi khi truy hồi dữ liệu
                if (error != nil)
                {
                    print("Lỗi khi truy hồi dữ liệu: \(String(describing: error))")
                    return
                }
                DispatchQueue.main.async
                    {
                    
                    if let downloadedImage = UIImage(data: data!){
                        let newImage = self.resizeImage(image: downloadedImage, toTheSize: imageSize)
                        imageCache.setObject(newImage, forKey: urlString as AnyObject)
                        self.image = newImage
                    }
                }
            }.resume()
        }
    }
    
    //Hàm chỉnh sửa kích thước ảnh
    func resizeImage(image: UIImage, toTheSize size: CGSize) -> UIImage
    {
        
        let scale = CGFloat(max(size.width/image.size.width,
                                size.height/image.size.height))
        let width: CGFloat  = image.size.width * scale
        let height: CGFloat = image.size.height * scale;
        
        let rr:CGRect = CGRect(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        image.draw(in: rr)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return newImage!
    }
}

class AlertView: NSObject
{
    
    class func showAlert(view: UIViewController ,title: String,  message: String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OkAction = UIAlertAction(title: "OK", style: .destructive , handler: nil)
        alertController.addAction(OkAction)
        
        DispatchQueue.main.async
            { view.present(alertController, animated: true, completion: nil) }
    }
}

