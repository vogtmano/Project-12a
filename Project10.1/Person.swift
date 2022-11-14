//
//  Person.swift
//  Project10.1
//
//  Created by Maks Vogtman on 21/09/2022.
//

import UIKit

// What if we want to hold an array of people? Well, the solution is to create a custom class.

// NSObject is what's called a universal base class for all Cocoa Touch classes. That means all UIKit classes ultimately come from NSObject, including all of UIKit.

class Person: NSObject, NSCoding {
    
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
// Above and beyond integers, dates, strings, arrays and so on, you can also save any kind of data inside UserDefaults as long as you follow some rules.
    
// What happens is simple: you use the archivedData() method of NSKeyedArchiver, which turns an object graph into a Data object, then write that to UserDefaults as if it were any other object. If you were wondering, “object graph” means “your object, plus any objects it refers to, plus any objects those objects refer to, and so on.”

// The rules are very simple:

   // 1. All your data types must be one of the following: boolean, integer, float, double, string, array, dictionary, Date, or a class that fits rule 2.
   // 2. If your data type is a class, it must conform to the NSCoding protocol, which is used for archiving object graphs.
   // 3. If your data type is an array or dictionary, all the keys and values must match rule 1 or rule 2.
    
// Many of Apple's own classes support NSCoding, including but not limited to: UIColor, UIImage, UIView, UILabel, UIImageView, UITableView, SKSpriteNode and many more. But your own classes do not, at least not by default. If we want to save the people array to UserDefaults we'll need to conform to the NSCoding protocol.
    
// The first step is to modify your Person class to inherits from NSCoding.
    

    
// When we were working on this code in project 10, there were two outstanding questions:
    
    // 1. Why do we need a class here when a struct will do just as well? (And in fact better, because structs come with a default initializer!)
    // 2. Why do we need to inherit from NSObject?
    
// It's time for the answers to become clear. You see, working with NSCoding requires you to use objects, or, in the case of strings, arrays and dictionaries, structs that are interchangeable with objects. If we made the Person class into a struct, we couldn't use it with NSCoding.

// The reason we inherit from NSObject is again because it's required to use NSCoding – although cunningly Swift won't mention that to you, your app will just crash.

// Once you conform to the NSCoding protocol, you'll get compiler errors because the protocol requires you to implement two methods: a new initializer and encode().
    

    
// We need to write some more code to fix the problems, and although the code is very similar to what you've already seen in UserDefaults, it has two new things you need to know about.

// First, you'll be using a new class called NSCoder. This is responsible for both encoding (writing) and decoding (reading) your data so that it can be used with UserDefaults.

// Second, the new initializer must be declared with the required keyword. This means "if anyone tries to subclass this class, they are required to implement this method." An alternative to using required is to declare that your class can never be subclassed, known as a final class, in which case you don't need required because subclassing isn't possible. We'll be using required here.
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        image = coder.decodeObject(forKey: "image") as? String ?? ""
    }
    
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(image, forKey: "image")
    }
}

// The initializer is used when loading objects of this class, and encode() is used when saving. The code is very similar to using UserDefaults, but here we’re adding as? typecasting and nil coalescing just in case we get invalid data back.

// With those changes, the Person class now conforms to NSCoding, so we can go back to ViewController.swift and add code to load and save the people array.
