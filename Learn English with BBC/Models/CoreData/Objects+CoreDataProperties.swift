//
//  Object+CoreDataProperties.swift
//  Learn English with BBC
//
//  Created by chuongmd on 11/5/18.
//  Copyright © 2018 chuongmd. All rights reserved.
//


import Foundation
import CoreData


extension Object
{

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Object>
    {
        return NSFetchRequest<Object>(entityName: "Object")
    }

    @NSManaged public var title: String?
    @NSManaged public var descriptions: String?
    @NSManaged public var link: String?
    @NSManaged public var guid: String?
    @NSManaged public var urlMedia: String?
    @NSManaged public var isFavorited: Bool
    @NSManaged public var isExistedInCoreData: Bool

    //Hàm chèn dữ liệu vào entity Object - sử dụng từ khoá: @discardableResult để lờ đi lỗi "Result of call to ... is unused"
    @discardableResult static func insertNewObject(title: String, descriptions: String, link: String, guid: String, urlMedia: String, isFavorited: Bool, isExistedInCoreData: Bool) -> Object?
    {
        let newObject = NSEntityDescription.insertNewObject(forEntityName: "Object", into: AppDelegate.managedObjectContext!) as! Object
        newObject.title = title
        newObject.descriptions = descriptions
        newObject.link = link
        newObject.guid = guid
        newObject.urlMedia = urlMedia
        newObject.isFavorited = isFavorited
        newObject.isExistedInCoreData = !isExistedInCoreData
        
        //Lưu dữ liệu newObject vào CoreData
        do
        {
            try AppDelegate.managedObjectContext?.save()
            print("Thêm mới Object \(title), \(descriptions), \(link), \(guid), \(urlMedia) vào CoreData")
        } catch
        {
            let error = error as NSError
            print("Lỗi không thêm được newObject vào entity Object: \(error)")
            return nil
        }
        return newObject
    }
    
    //Hàm lấy dữ liệu từ CoreData
    @discardableResult static func getAllObject() -> [Object]
    {
        var result = [Object]()
        let context = AppDelegate.managedObjectContext
        do
        {
            result = try context!.fetch(Object.fetchRequest()) as! [Object]
        } catch
        {
            print("Không thể lấy dữ liệu do xuất hiện lỗi: \(error)")
            return result
        }
        print("Lấy dữ liệu thành công")
        return result
    }
    
    //Xoá toàn bộ dữ liệu có trong CoreData
    @discardableResult static func deleleAllObject() -> Bool
    {
        let context = AppDelegate.managedObjectContext
        let objects = Object.getAllObject()
        for object in objects
        {
            context?.delete(object)
        }
        do
        {
            try AppDelegate.managedObjectContext?.save()
        } catch
        {
            let error = error as NSError
            print("Xoá Object không thành công do xuất hiện lỗi: \(error)")
            return false
        }
        print("Xoá toàn bộ Object trong CoreData ")
        return true
    }
    
    //Update dữ liệu có trong CoreData
    @discardableResult static func updateIsFavoritedObject(favoriteObject: Object, isNewValueFavorited: Bool) -> Bool
    {
        let context = AppDelegate.managedObjectContext
        let objects = Object.getAllObject()
        for object in objects
        {
            if object.title! == favoriteObject.title!
            {
                object.setValue(isNewValueFavorited, forKey: "isFavorited")
            }
        }
        do
        {
            try context?.save()
        } catch
        {
            let error = error as NSError
            print("Update thuộc tính không thành công do xuất hiện lỗi: \(error)")
            return false
        }
        print("Update thành công thuộc tính isFavorited của \(favoriteObject) trong CoreData ")
        return true
    }
    
    //Lấy danh sách các favorite object có trong CoreData
    @discardableResult static func getFavoriteObjects() -> [Object]
    {
        var favoriteList = [Object]()
        for object in Object.getAllObject()
        {
            if object.isFavorited
            {
                favoriteList += [object]
            }
        }
        do
        {
            try AppDelegate.managedObjectContext?.save()
        } catch
        {
            let error = error as NSError
            print("Lấy Object không thành công do xuất hiện lỗi: \(error)")
        }
        print("Lấy thành công favoriteList trong CoreData: \(favoriteList.count) phần tử ")
        return favoriteList
    }
}
