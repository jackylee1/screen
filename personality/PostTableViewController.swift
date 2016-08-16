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
        let dateSort = NSSortDescriptor(key: "dateCreated", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            posts = try managedObjectContext.executeFetchRequest(fetchRequest) as! [Post]
        } catch let getUserError as NSError {
            print("Error fetching User: \(getUserError)")
        }
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.scopeButtonTitles = ["All", "Last 24h", "Last 7d", "Last 30d"]
        searchController.searchBar.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredPosts = posts.filter { post in
            let catagoryMatch = checkDateScope(Int(post.dateCreated!), scope: scope)
            if searchText == "" {
                return catagoryMatch
            } else {
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active {
            return filteredPosts.count
        }
        return posts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let post: Post
        if searchController.active {
            post = filteredPosts[indexPath.row]
        } else {
            post = posts[indexPath.row]
        }
        cell.textLabel?.text = post.message
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        let date = NSDate(timeIntervalSince1970: post.dateCreated! as Double)
        let formattedDate = dateFormatter.stringFromDate(date)
        
        cell.detailTextLabel?.text = formattedDate

        return cell
    }
    
    deinit{
        if let superView = searchController.view.superview {
            superView.removeFromSuperview()
        }
    }
    
    @IBAction func unwindFromPostDetail(segue: UIStoryboardSegue) {
        
    }

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "postDetail" {
            let postDetailViewController = segue.destinationViewController as! PostDetailViewController
            let postToPass: Post
            if let indexPath = tableView.indexPathForSelectedRow {
                if searchController.active {
                    postToPass = filteredPosts[indexPath.row]
                } else {
                    postToPass = posts[indexPath.row]
                }
                postDetailViewController.post = postToPass
            }
            
        }
        
    }
    

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
