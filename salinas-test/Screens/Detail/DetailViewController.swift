//
//  DetailViewController.swift
//  salinas-test
//
//  Created by Macintosh HD on 14/07/20.
//  Copyright © 2020 vicentesiis. All rights reserved.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {
    
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var showDescription: UITextView!
    @IBOutlet weak var showIMDb: UIButton!
    
    @IBOutlet weak var favorite: UIBarButtonItem!
    
    var show: Show?
    var realm = try! Realm()
    var titleIMDb = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        if let show = show {
            
            title = show.name
            showImage.downloaded(from: show.image?.original ?? "")
            showDescription.text = show.summary.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            
            if let imdb = show.externals?.imdb {
                titleIMDb = imdb
            } else {
                showIMDb.isHidden = true
            }
            
            if !show.isFavorite {
                favorite.title = "Favorite"
            }
            
        }
    }
    
    @IBAction func openPageWeb(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.imdb.com/title/\(titleIMDb)")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func addOrDeleteFromFavorite(_ sender: Any) {
        
        guard show != nil else { return }
        
         do {
            
            try self.realm.write {
                show!.isFavorite.toggle()
            }
            
            favorite.title = show!.isFavorite ? "Delete" : "Favorite"
            
         } catch (let error) {
            
            print(error.localizedDescription)
            Utils.presentAlert(in: self,
                               title: "Oops, algo salió mal!",
                               message: "Hubo un problema al guardar/borrar este show de TV. ¿Quieres intentar nuevamente?",
                               alertActions: nil,
                               closeAction: nil)
            
        }
        
    }
    
}
