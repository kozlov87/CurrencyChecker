//
//  FirstViewController.swift
//  OkRouble
//
//  Created by Козлов Егор on 22.03.17.
//  Copyright © 2017 Козлов Егор. All rights reserved.
//

import UIKit
import CoreData

class RateViewController: UIViewController {
    
    fileprivate struct Constants {
        static let cellId = "rateCell"
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in 
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = Currency.entity()
        
        let fetchSort = NSSortDescriptor(key: "code", ascending: true)
        fetchRequest.sortDescriptors = [fetchSort]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataHelper.instance.context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refresh:", for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Unable to perform fetch: \(error.localizedDescription)")
        }
        refreshData()
    }
    
    func refreshData() {
        // must be in a main queue.
        ExchangeBrain.updateData { (result) -> Void in
            if result == .done {
                let queue = OperationQueue.main
                queue.addOperation() {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func refresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        refreshData()
    }
}

extension RateViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sectionCount = fetchedResultsController.sections?.count else {
            return 0
        }
        return sectionCount
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        default: break
        }
    }
}

extension RateViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionData = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionData.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId) as! CurrencyTableViewCell
        let currency = fetchedResultsController.object(at: indexPath) as! Currency
        cell.setData(currency)
        return cell
    }
}
