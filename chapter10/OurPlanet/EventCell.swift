//
//  EventCell.swift
//  OurPlanet
//
//  Created by fahreddin on 16.02.2021.
//  Copyright © 2021 fahreddin. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet var title: UILabel!
      @IBOutlet var date: UILabel!
      @IBOutlet var details: UILabel!

      func configure(event: EOEvent) {
        title.text = event.title
        details.text = event.description

        let formatter = DateFormatter()
        formatter.dateStyle = .short
        if let when = event.date {
          date.text = formatter.string(for: when)
        } else {
          date.text = ""
        }
      }
}
