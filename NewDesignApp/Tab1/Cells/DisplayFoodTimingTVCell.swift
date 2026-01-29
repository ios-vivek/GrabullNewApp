//
//  DisplayFoodTimingTVCell.swift
//  NewDesignApp
//
//  Created by Vivek SIngh on 09/08/24.
//

import UIKit
import Lottie

class DisplayFoodTimingTVCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var icon: LottieAnimationView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
        icon.animation = LottieAnimation.named("lunch.json")
        titleLbl.text = "hello"
        titleLbl.textColor = themeBackgrounColor
        titleLbl.text = displayTitle()
        icon.backgroundColor = .clear
    }
    
    func displayTitle() -> String{
        
        let dinner = "dinner".translated()//3PM - 11:30PM
        let breakfast = "breakfast".translated()//5AM - 11:30AM
        let lunch = "lunch".translated()//11:30AM - 3PM
        let latenight = "latenight".translated()//11:30 PM - 5 AM
        
        let hour = Calendar.current.component(.hour, from: Date())
        let minut = Calendar.current.component(.minute, from: Date())
        let hourInminutes = hour * 60
        let totalMinuts = hourInminutes + minut
        
        let breakfastStartMinuts = 5 * 60
        let breakfastEndMinuts = (11 * 60) + 30
        
        let lunchStartMinuts = (11 * 60) + 31
        let lunchEndMinuts = (15 * 60)
        
        let dinnerStartMinuts = (15 * 60) + 1
        let dinnerEndMinuts = (23 * 60) + 30
        
       // let lateNightStartMinuts = (23 * 60) + 31
       // let lateNightEndMinuts = (4 * 60) + 59
        var textmsg = ""
        if totalMinuts > breakfastStartMinuts && totalMinuts < breakfastEndMinuts {
            textmsg = breakfast
            icon.animation = LottieAnimation.named("breakfast.json")

        }
        else if totalMinuts > lunchStartMinuts && totalMinuts < lunchEndMinuts {
            textmsg = lunch
            icon.animation = LottieAnimation.named("lunch.json")

        }
        else if totalMinuts > dinnerStartMinuts && totalMinuts < dinnerEndMinuts {
            textmsg = dinner
            icon.animation = LottieAnimation.named("dinner.json")

        }
        else {
            textmsg = latenight
        }
        icon.play()
        icon.loopMode = .loop
        return "\("hungry".translated()) \(textmsg)"
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
