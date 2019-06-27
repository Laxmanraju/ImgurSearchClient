//
//  DebounceTimer.swift
//  ImgurSearchClient
//
//  Created by Laxman Penmesta on 6/27/19.
//  Copyright © 2019 BanCreations. All rights reserved.
//

import Foundation

class DebounceTimer{
    
    var timer: Timer?
    var timeInterval: TimeInterval
    var timerHandler :(()-> Void)?
    init(with Interval: TimeInterval) {
        self.timeInterval = Interval
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: { [weak self] timer in
            guard let self = self else {return}
            self.manageTimer(timer)
        })
    }
    
    func manageTimer(_ timer: Timer){
        guard  timer.isValid else {
            return
        }
        timerHandler?()
        timerHandler  = nil
    }
}
