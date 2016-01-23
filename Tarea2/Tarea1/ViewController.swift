//
//  ViewController.swift
//  Tarea1
//
//  Created by Vital Sistemas on 13/01/16.
//  Copyright © 2016 Vital Sistemas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var coverImg: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var ISBNText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.textView.text  = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buscarISBN(sender: AnyObject) {
        ISBNText.resignFirstResponder()
        let isbn = ISBNText.text
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN"+isbn!
        let url = NSURL(string: urls)
        
        
        let datos:NSData? = NSData(contentsOfURL: url!)
        if (datos == nil) {
            self.textView.text = "Error de conexión"
        } else {
            let texto = NSString(data:datos!, encoding: NSUTF8StringEncoding)
            self.textView.text = texto! as String
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                let dico1 = json as! NSDictionary
                print(dico1.allKeys)
                var tmp = dico1["ISBN"+isbn!]
                if (tmp != nil && tmp is NSDictionary) {
                    let dico2 = tmp as! NSDictionary
                    tmp = dico2["authors"]
                    if (tmp != nil && tmp is NSArray) {
                        let dico3 =  tmp as! NSArray
                
                        self.textView.text = "TITULO: \n"+(dico2["title"] as! NSString as String)
                        self.textView.text = self.textView.text + "\n\n AUTOR(ES):"
                        for id in dico3 {
                            print(id["name"])
                            self.textView.text = self.textView.text + "\n" + (id["name"] as! NSString as String)
                        }
                        let cover = dico2["cover"]
                        if (cover != nil && cover is NSDictionary) {
                            let covers = cover as! NSDictionary
                            let url = NSURL(string: covers["medium"] as! NSString as String)
                            if let data = NSData(contentsOfURL: url!) {
                                coverImg.image = UIImage(data: data)
                            }
                    
                        }
                    }
                }
            } catch _ {
            }
        }
        
    }

    @IBAction func limpiarTexto(sender: AnyObject) {
        ISBNText.text = ""
    }

}

