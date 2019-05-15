import UIKit
import SwiftyJSON
import Firebase

class List: UITableViewController {
    var dbStuff: DatabaseReference!
    var jsonData = [[String:String]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let userID = Auth.auth().currentUser!.uid
        sleep(1)
        self.dbStuff.child(userID).observe(.value){ snapshot in
            let data = snapshot.value as? [String: AnyObject] ?? [:]
            print(data)
//            for (key,value) in data{
//                if let title = value["Title"] as? String,
//                    let link = value["Poster"] as? String{
//                    self.jsonData.append(["Title": title, "Poster": link])
//                }
//            }
        }
//        dbStuff.child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
//            print(snapshot)
//        }) { (error) in
//            print(error.localizedDescription)
//        }
//        sleep(1)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonData.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listItemList", for: indexPath) as! ListCell
        let row = indexPath.row
        let url = jsonData[row]["Poster"] ?? "Movie X"
        let title = jsonData[row]["Title"] ?? "Movie X"
        cell.title = title
        cell.link = url
        cell.decorate()
        return cell
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
