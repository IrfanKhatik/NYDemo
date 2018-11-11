//
//  DetailTableViewController.swift
//  NYTimes
//
//  Created by Irfan Khatik on 11/11/18.
//  Copyright © 2018 NewYorkTimes. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {

    var selectedPost : NYPost!
    var selectedPostImage: UIImage?
    
    @IBOutlet weak var imgNYPost: UIImageView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.imgNYPost.layer.cornerRadius = self.imgNYPost.bounds.size.height / 2;
        self.imgNYPost.layer.masksToBounds = true;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "NY Post Detail"
        if selectedPost.desc.count > 0 {
            self.lblDesc.text = selectedPost.desc
        }
        
        if selectedPost.author.count > 0 {
            self.lblAuthor.text = selectedPost.author
        }
        
        if selectedPost.dateTime.count > 0 {
            self.lblDate.text = selectedPost.dateTime
        }
        
        if let postImage = selectedPostImage {
            self.imgNYPost.image = postImage
            self.imgNYPost.layer.cornerRadius = self.imgNYPost.bounds.size.height / 2;
            self.imgNYPost.layer.masksToBounds = true;
        } else {
            if selectedPost.imagePath.count > 0 {
                guard let url = URL(string:selectedPost.imagePath) else {
                    self.tableView.reloadData()
                    return
                }
                // Download image into background thread and set it once downloads completed
                // Store same image in Cache for future use...
                DispatchQueue.global(qos: .background).async {
                    let data = try? Data(contentsOf: url)
                    if let imageData = data {
                        let image: UIImage = UIImage(data: imageData)!
                        DispatchQueue.main.async {
                            // This is not a retain cycle, because self doesn't own DispatchQueue.main.
                            // The block does keep self alive until it is executed, though.
                            self.imgNYPost.image = image
                            self.imgNYPost.layer.cornerRadius = self.imgNYPost.bounds.size.height / 2;
                            self.imgNYPost.layer.masksToBounds = true;
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
        self.tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.imgNYPost.layer.cornerRadius = self.imgNYPost.bounds.size.height / 2;
        self.imgNYPost.layer.masksToBounds = true;
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return (UIScreen.main.bounds.size.height * 0.30)
        }
        return UITableView.automaticDimension
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
