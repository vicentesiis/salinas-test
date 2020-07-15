//
//  ShowsViewController.swift
//  salinas-test
//
//  Created by Macintosh HD on 14/07/20.
//  Copyright © 2020 vicentesiis. All rights reserved.
//

import UIKit
import RealmSwift

class ShowsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var shows = Show.all()
    var realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarUIView?.backgroundColor = UIColor(named: "Main")
        
        if shows.isEmpty {
            
            RestAPI.getShows { (response) in
                
                switch response {
                    
                case .success(let shows):
                    Show.add(shows)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    Utils.presentAlert(in: self, title: "Oops, algo salió mal!",
                                       message: "Ocurrió un error al consultar el servicio. ¿Quieres intentar nuevamente?",
                                       alertActions: nil,
                                       closeAction: nil)
                    
                }
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            let VC = segue.destination as? DetailViewController
            VC?.show = sender as? Show
        }
    }


}

// MARK: - UITableViewDelegate

extension ShowsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detail", sender: shows[indexPath.row])
    }
    
}

// MARK: - UITableViewDataSource

extension ShowsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "show_cell") as! ShowTableViewCell
        
        let show = shows[indexPath.row]
        cell.showImage.image = nil
        cell.showImage.downloaded(from: show.image?.medium ?? "")
        cell.showTitle.text = show.name
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let show = shows[indexPath.row]
        
        let contextItem = UIContextualAction(style: .normal, title: "Favorite") {  (_, _, boolValue) in
            
            do {
                try self.realm.write {
                    show.isFavorite = true
                }
            } catch (let error) {
                print(error.localizedDescription)
                Utils.presentAlert(in: self, title: "Oops, algo salió mal!", message: "Hubo un problema al guardar/borrar este show de TV. ¿Quieres intentar nuevamente?", alertActions: nil, closeAction: nil)
            }
            
            boolValue(true)
        }
        
        let contextItemDelete = UIContextualAction(style: .destructive, title: "Delete") {  (_, _, boolValue) in
            
            let closeAction = UIAlertAction(title: "No", style: .cancel, handler: { (alertAction) in
                boolValue(false)
            })
            
            let acceptAction = UIAlertAction(title: "Si", style: .destructive, handler: { (alertAction) in
                show.delete()
                tableView.beginUpdates()
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
            })
            
            Utils.presentAlert(in: self, title: "Borrar", message: "Está seguro que desea borrar \(show.name)", alertActions: [acceptAction], closeAction: closeAction)
            
        }

        contextItem.backgroundColor = .green
        contextItemDelete.backgroundColor = .red
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItemDelete, contextItem])

        return swipeActions
    }
    
    
}
