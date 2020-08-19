import UIKit
import SQLite3

class TableViewController: UITableViewController {
    
    var arrayModel = [Model]()
    var arrayOfUsername = [String]()
    var refreshControll = UIRefreshControl()
    
    @IBOutlet weak var searchbar: UISearchBar!
    var currentUsersArray = [Model]()
    var searching = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load_functionality()
        searchbar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }
    
    
    
    
    //MARK: Load functionality
    func load_functionality() {
        let plus = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusclick))
        self.navigationItem.rightBarButtonItem = plus
        
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        refreshControll.addTarget(self, action: #selector(pullToRefresh(sender:)), for: .valueChanged)
//        refreshControll.attributedTitle = NSAttributedString(string: "Loading...")
        tableView.refreshControl = refreshControll
    }
    
    
    
    
    //MARK: pull_to_refresh function
    @objc func pullToRefresh(sender:UIRefreshControl){
        getData()
        sender.endRefreshing()
    }
    
    
    
    
    //MARK: plus_click function
    @objc func plusclick(){
        
        if arrayOfUsername.contains(LoginViewController.uniqueUsername){
            self.showAlert(title: "Alert", message: "Only one entry is allowed.")
        }else{
            let addvc = AddViewController()
            self.navigationController?.pushViewController(addvc, animated: true)
        }
    }
    
    
    
    
    //MARK: get_data function
    func getData(){
        
        self.arrayModel.removeAll()
        self.arrayOfUsername.removeAll()
        self.tableView.reloadData()
        
        let url = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let dbpath = url.appendingPathComponent("TravelN.sqlite")
        var ptr:OpaquePointer?
        var statement:OpaquePointer?
        
        if sqlite3_open(dbpath.path, &ptr)==SQLITE_OK{
            let query = "select * from data"
            
            if sqlite3_prepare(ptr, query, -1, &statement, nil)==SQLITE_OK{
                
                while sqlite3_step(statement) == SQLITE_ROW{
                    let c1 = String(format: "%s",sqlite3_column_text(statement, 0))
                    let c2 = String(format: "%s",sqlite3_column_text(statement, 1))
                    let c3 = String(format: "%s",sqlite3_column_text(statement, 2))
                    let c4 = String(format: "%s",sqlite3_column_text(statement, 3))
                    let c5 = String(format: "%s",sqlite3_column_text(statement, 4))
                    let c6 = String(format: "%s",sqlite3_column_text(statement, 5))
                    let c7 = String(format: "%s",sqlite3_column_text(statement, 6))
                    let c8 = Double(sqlite3_column_double(statement, 7))
                    let c9 = String(format: "%s",sqlite3_column_text(statement, 8))
                    
                    arrayModel.append(Model(uniqueUsername: c1, fullname: c2, mobile: c3, country1: c4, country2: c5, date1: c6, date2: c7, weight: c8, addressExtra: c9))
                    arrayOfUsername.append(c1)
                    
                    tableView.reloadData()
                }
            }else{
                print("fail to get data")
            }
        }else{
            print("fail to open database")
        }
        sqlite3_close(ptr)
    }
    
    
    
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            return self.currentUsersArray.count
        }else{
            return self.arrayModel.count
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        if searching{
            cell.country1lbl.text = self.currentUsersArray[indexPath.row].country1
            cell.country2lbl.text = self.currentUsersArray[indexPath.row].country2
            cell.layer.borderWidth = 0.5
            cell.layer.cornerRadius = cell.frame.size.height/2
            if LoginViewController.uniqueUsername == self.currentUsersArray[indexPath.row].uniqueUsername{
                cell.contentView.layer.cornerRadius = cell.contentView.frame.size.height/2
                cell.contentView.backgroundColor = UIColor.yellow
            }else{
                cell.contentView.backgroundColor = .white
            }
            
        }else{
            cell.country1lbl.text = self.arrayModel[indexPath.row].country1
            cell.country2lbl.text = self.arrayModel[indexPath.row].country2
            cell.layer.borderWidth = 0.5
            cell.layer.cornerRadius = cell.frame.size.height/2
            if LoginViewController.uniqueUsername == self.arrayModel[indexPath.row].uniqueUsername{
                cell.contentView.layer.cornerRadius = cell.contentView.frame.size.height/2
                cell.contentView.backgroundColor = UIColor.yellow
            }else{
                cell.contentView.backgroundColor = .white
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailvc = DetailViewController()
        
        if searching{
            detailvc.tempModel = self.arrayModel[indexPath.row]
        }else{
            detailvc.tempModel = self.arrayModel[indexPath.row]
        }
        
        self.navigationController?.pushViewController(detailvc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Boarding Country -> Landing Country"
    }
    
}




extension TableViewController:UISearchBarDelegate{
    
    //MARK: Search_Bar_Delegate Function
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else{ currentUsersArray = arrayModel; self.tableView.reloadData(); return }
        
        currentUsersArray = arrayModel.filter({ (user) -> Bool in
            return user.country1.lowercased().contains(searchText.lowercased())
        })
        searching = true
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searching = false
        self.tableView.reloadData()
    }
}
