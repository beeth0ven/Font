//
//  AppsTableViewController.swift
//  Font
//
//  Created by luojie on 2016/11/26.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit
import BNKit
import RxSwift
import RxCocoa
import CoreData

class AppsTableViewController: UITableViewController {
    
    @IBOutlet weak var footLabel: UILabel!
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Application> = {
        let fetchRequest = NSFetchRequest<Application>(entityName: "Application")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(ManagedObject.creationDate), ascending: false)]
        fetchRequest.fetchBatchSize = 20
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.Font.context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        try! controller.performFetch()
        Queue.main.execute { self.updatefootLabel() }
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let app = fetchedResultsController.object(at: indexPath)
        let cell = UITableViewCell.from(tableView)
        cell.textLabel?.text = app.name
        cell.detailTextLabel?.text = app.caption
        return cell
    }
    
    fileprivate func updatefootLabel() {
        footLabel.text = "共 \(fetchedResultsController.fetchedObjects!.count) 个"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "AppDetailViewController"?:
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
            let app = fetchedResultsController.object(at: indexPath)
            (segue.destination as! AppDetailViewController).app = app
        default:
            break
        }
    }
}

extension AppsTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        updatefootLabel()
    }
}
