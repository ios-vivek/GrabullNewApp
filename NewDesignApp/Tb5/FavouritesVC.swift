//
//  FavouritesVC.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 31/08/24.
//

import UIKit

class FavouritesVC: UIViewController {
    var favoriteList = [Restaurant]()
    @IBOutlet weak var favTbl: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        favTbl.backgroundColor = .white
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getRestDataFromApi()
    }
    func getRestDataFromApi() {
       
        let parameters = CommonAPIParams.base()
       
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: OldServiceType.getFavorite, forModelType: FavListResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            self.favoriteList = success.data.restaurant
            self.favTbl.reloadData()
            
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
        }
    }
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    func setFavRestaurant(index: Int) {
        var rest = self.favoriteList[index]
        var tempList = self.favoriteList
        var favStr = OldServiceType.addFavorite
        if rest.favorite == "Yes" {
            favStr = OldServiceType.removeFavorite
        }
        var parameters = CommonAPIParams.base()
        parameters.merge([
            "restaurant_id" : rest.rid
        ]) { _, new in new }
        print(parameters)
        UtilsClass.showProgressHud(view: self.view)
        WebServices.loadDataFromServiceWithBaseResponse(parameter: parameters, servicename: favStr, forModelType: FavoriteResponse.self) { success in
            UtilsClass.hideProgressHud(view: self.view)
            //let addRemoveFavRestResponse = success.data.result
            if favStr == OldServiceType.addFavorite {
                rest.favorite = "Yes"
            } else {
                rest.favorite = "No"
            }
            tempList.remove(at: index)
            //tempList.insert(rest, at: index)
            self.favoriteList = tempList
            self.favTbl.reloadData()
           // self.showAlert(msg: addRemoveFavRestResponse ?? "")
        } ErrorHandler: { error in
            UtilsClass.hideProgressHud(view: self.view)
        }
    }
    
    func removeDataFromTbl(index: Int) {
        /*
        favoriteListResponse?.data?.rest_list.list.remove(at: index)
        favTbl.reloadData()
        */
    }

}
extension FavouritesVC: RestCellDelegate {
    func clickedFavAction(index: Int) {
        setFavRestaurant(index: index)
    }
    
    func openOptionView(sender: UITapGestureRecognizer, index: Int) {
        let point = sender.location(in: self.view)
        let popupVC = self.viewController(viewController: RestaurantPoupVC.self, storyName: StoryName.Main.rawValue) as! RestaurantPoupVC
        popupVC.restIndex = index
        popupVC.pointY = Float(point.y)
        popupVC.numberOfItem = 1
        popupVC.textOne = "Remove from favourites"
        popupVC.textTwo = ""
        popupVC.textThree = ""
        popupVC.firstImg = UIImage.init(named: "favorite")
        popupVC.secondImg = UIImage.init(named: "")
        popupVC.thirdImg = UIImage.init(named: "")
        popupVC.delegate = self
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        self.present(popupVC, animated: true)
    }
}
extension FavouritesVC: SelectOptionDelegate {
    func selectedOption(restIndex: Int, index: Int) {
        setFavRestaurant(index: restIndex)
    }

}

extension FavouritesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestDetailCell", for: indexPath) as! RestDetailCell
        cell.delegate = self
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        cell.updateUIWithOld(index: indexPath.row, restaurant: favoriteList[indexPath.row])
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}
