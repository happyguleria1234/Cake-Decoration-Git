//
//  CustomerOrderListing.swift
//  CakeDecoration
//
//  Created by MyMac on 14/08/21.
//
import UIKit
import Foundation

class CustomerOrderListing : BaseVC , UITableViewDelegate , UITableViewDataSource{
    
    //------------------------------------------------------
    
    //MARK: IBOutlet(s)
    
    @IBOutlet weak var tblList: UITableView!
    
    var items: [OrderListingModal] = []
    var itemCounts = 0
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Custome
    
    func configureUI(){
                
        let identifier = String(describing: CustomerListingCell.self)
        let nibCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblList.register(nibCell, forCellReuseIdentifier: identifier)
        tblList.delegate = self
        tblList.dataSource = self
        tblList.separatorStyle = .none
    }
    
    func performGetListing(completion:((_ flag: Bool) -> Void)?) {
        
        let parameter: [String: Any] = [
            Request.Parameter.employeeId: currentUser?.id ?? String(),
            Request.Parameter.role : currentUser?.role ?? String(),
            Request.Parameter.status : "1",
            Request.Parameter.month: "",
            Request.Parameter.week : "",
        ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.orderListing, parameter: parameter, showLoader: false, decodingType: ResponseModal<[OrderListingModal]>.self, successBlock: { (response: ResponseModal<[OrderListingModal]>) in
            
            self.items.removeAll()
            
            LoadingManager.shared.hideLoading()
            
            if response.code == Status.Code.success {
                
                delay {
                    self.items.append(contentsOf: response.data ?? [])
                    self.items = self.items.removingDuplicates()
                    self.tblList.reloadData()
                }
                
            } else {
                
//                delay {
//                    DisplayAlertManager.shared.displayAlert(animated: true, message: response.message ?? String(), handlerOK: nil)
//                }
            }
            
        }, failureBlock: { (error: ErrorModal) in
            
            LoadingManager.shared.hideLoading()
            
            delay {
                DisplayAlertManager.shared.displayAlert(animated: true, message: error.errorDescription, handlerOK: nil)
            }
        })
    }
    
    func performStatus(orderID : String , orderStatus : String ,completion:((_ flag: Bool) -> Void)?) {
        
        var parameter: [String: Any] = [:]
        
        parameter = [
            Request.Parameter.employeeId: currentUser?.id ?? String(),
            Request.Parameter.statussss : "1",
            Request.Parameter.order_id: orderID,
        ]
        
        RequestManager.shared.requestPOST(requestMethod: Request.Method.deliverStatus, parameter: parameter, showLoader: false, decodingType: ResponseModal<ReadyStatus>.self, successBlock: { (response: ResponseModal<ReadyStatus>) in
            
            LoadingManager.shared.hideLoading()
            
            if response.code == Status.Code.success {
                
                delay {
                    DisplayAlertManager.shared.displayAlert(target: self, animated: true, message: response.message ?? String()) {
                        
                        delay {
                            
                            LoadingManager.shared.showLoading()
                            
                            self.performGetListing { (flag : Bool) in
                                
                            }
                        }
                    }
                }

                
            } else {
                
                delay {
//                    DisplayAlertManager.shared.displayAlert(animated: true, message: response.message ?? String(), handlerOK: nil)
                }
            }
            
        }, failureBlock: { (error: ErrorModal) in
            
            LoadingManager.shared.hideLoading()
            
            delay {
                DisplayAlertManager.shared.displayAlert(animated: true, message: error.errorDescription, handlerOK: nil)
            }
        })
    }
    
    //------------------------------------------------------
    
    //MARK: TableView Delegate Datasource Method(s)
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items.count == 0 {
            self.tblList.setEmptyMessage("No data found!")
        } else {
            self.tblList.restore()
        }
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomerListingCell.self)) as? CustomerListingCell {
            cell.selectionStyle = .none
            let data = items[indexPath.row]
            cell.lblOrder.text = "Order ID : \(data.orderID ?? String())"
            cell.cutomerName.text = "Customer name : \(data.name ?? String())"
            let dateVal = NumberFormatter().number(from: data.orderDateStr ?? "")?.doubleValue ?? 0.0
            let timeStamp = self.convertTimeStampToDate(dateVal: dateVal)
            let dateVal1 = NumberFormatter().number(from: data.orderDateStr ?? "")?.doubleValue ?? 0.0
            let timeStampp = self.convertTimeStampToDate(dateVal: dateVal1)
            cell.LblDate.text = "Order Date : \(timeStamp)"
            cell.lblTotalCOst.text = "Name : \(data.name ?? String())"
            cell.orderDate.text = "Expected Date: \(timeStampp)"
            cell.btnDeliver.addTarget(self, action: #selector(readyButtonAction(sender:)), for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderData = items[indexPath.row]
        let vc = DetailsVC.instantiate(fromAppStoryboard: .Customer)
        vc.orderDetail = orderData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //------------------------------------------------------
    
    //MARK: Table view button action
    
    @objc func readyButtonAction(sender : UIButton) {
        let data = items[sender.tag]
        DisplayAlertManager.shared.displayAlertWithNoYes(target: self, animated: true, message: "Are you sure want to deliver this order?") {
            
        } handlerYes: {
            DispatchQueue.main.async {
                
                LoadingManager.shared.showLoading()
                
                self.performStatus(orderID: data.orderID ?? "", orderStatus: "1") { (flag : Bool) in
                    
                }
            }
        }

        
//        DisplayAlertManager.shared.displayAlertWithCancelOk(target: self, animated: true, message: "Are you sure want to deliver this order?") {
            
//        } handlerOk: {
//
//            DispatchQueue.main.async {
//
//                LoadingManager.shared.showLoading()
//
//                self.performStatus { (flag : Bool) in
//
//                }
//            }
//
//        }
        
    }
    
    //------------------------------------------------------
    
    //MARK: Action
    
    @IBAction func brnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        tblList.separatorStyle = .none
        tblList.separatorColor = .clear
        LoadingManager.shared.showLoading()
        
        self.performGetListing { (flag : Bool) in
            
        }
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}
