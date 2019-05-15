import UIKit
import SwiftyJSON
import Firebase

class List: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var twList: UITableView!
    var dbStuff: DatabaseReference!
    var jsonData = [[String:String]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.twList.rowHeight = 100.0
        dbStuff = Database.database().reference()
        getData()
    }
    // Set the number of rows for the table views
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Counting items")
        return jsonData.count
    }
    // Set the cells for the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Filling the list")
        let cell = twList.dequeueReusableCell(withIdentifier: "userMoviesItem", for: indexPath) as! ListCellNoSave
        let row = indexPath.row
        let url = jsonData[row]["Poster"] ?? "Movie X"
        let title = jsonData[row]["Title"] ?? "Movie X"
        cell.title = title
        cell.link = url
        cell.decorate()
        return cell
    }
    // Firebase request to retreive users movie list
    func getData(){
        let userID = Auth.auth().currentUser!.uid
        dbStuff.child("userData").child(userID).observe(.value){ snapshot in
            self.jsonData.removeAll()
            let data = snapshot.value as? [String: AnyObject] ?? [:]
            for (_,value) in data{
                if let title = value["Title"] as? String,
                    let link = value["Poster"] as? String{
                    self.jsonData.append(["Title": title, "Poster": link])
                }
            }
            print(self.jsonData)
            print("Got the data!")
            self.twList.reloadData()
        }
    }
}

class ListCellNoSave: UITableViewCell{
    @IBOutlet var listImage: UIImageView!
    @IBOutlet var listTitle: UILabel!
    var title:String = "John"
    var link:String = "Johnny"
    func decorate() {
        self.listTitle.text = title
        listImage.downloaded(from: link)
    }
}
