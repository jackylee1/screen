//
//  PostTableViewController.swift
//  personality
//
//  Created by Martin Conklin on 2016-08-16.
//  Copyright © 2016 Martin Conklin. All rights reserved.
//

import UIKit
import CoreData

class PostTableViewController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    var posts = [Post]()
    var filteredPosts = [Post]()
    var managedObjectContext = FacebookHandler.sharedInstance.managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest(entityName: "Post")
        
        do {
            posts = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Post]
        } catch let getUserError as NSError {
            print("Error fetching User: \(getUserError)")
        }

        
//        posts = [
//            Candy(category:"Chocolate", name:"Chocolate Bar"),
//            Candy(category:"Chocolate", name:"Chocolate Chip"),
//            Candy(category:"Chocolate", name:"Dark Chocolate"),
//            Candy(category:"Hard", name:"Lollipop")
//        ]
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.scopeButtonTitles = ["All", "Last 24h", "Last 7d", "Last 30d"]
        searchController.searchBar.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredPosts = posts.filter { post in
            let catagoryMatch = checkDateScope(Int(post.dateCreated!), scope: scope)
            if searchText == "" {
                print("empty: \(catagoryMatch)")
                return catagoryMatch
            } else {
                print("full")
                return catagoryMatch && post.message!.lowercaseString.containsString(searchText.lowercaseString)
            }
        }
        tableView.reloadData()
    }
    
    func checkDateScope(dateInS: Int, scope: String = "All") -> Bool{
        if scope == "All"{
            return true
        } else if scope == "Last 24h" {
            // 24hr in seconds: 86400
            //timeframe is -now+24hr
            let timeframe = Int(-NSDate().timeIntervalSince1970) + 86400
            if (dateInS + timeframe)>=0{
                return true
            } else {
                return false
            }
        } else if scope == "Last 7d" {
            // 7 days in seconds: 604800
            //timeframe is -now+7day
            let timeframe = Int(-NSDate().timeIntervalSince1970) + 604800
            if (dateInS + timeframe)>=0{
                return true
            } else {
                return false
            }
            
        } else if scope == "Last 30d" {
            // 30 days in seconds: 2592000
            //timeframe is -now+30day
            let timeframe = Int(-NSDate().timeIntervalSince1970) + 2592000
            if (dateInS + timeframe)>=0{
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredPosts.count
        }
        return posts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let post: Post
        if searchController.active { // && searchController.searchBar.text != "" {
            post = filteredPosts[indexPath.row]
        } else {
            post = posts[indexPath.row]
        }
        cell.textLabel?.text = post.message
        cell.detailTextLabel?.text = "\(post.dateCreated)"

        return cell
    }
    
    deinit{
        if let superView = searchController.view.superview {
            superView.removeFromSuperview()
        }
    }

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PostTableViewController : UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

extension PostTableViewController : UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
 }
