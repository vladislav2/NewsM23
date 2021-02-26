//
//  CountryPickerViewController.swift
//  TXiBPcod
//
//  Created by user on 09.02.2021.
//

import UIKit

class CountryPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  
  private let countryArray = ["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn", "co", "cu", "cz", "de", "eg", "fr", "gb", "gr", "hk", "hu", "id", "ie", "il", "in", "it", "jp", "kr", "lt", "lv", "ma", "mx", "my", "ng", "nl", "no", "nz", "ph", "pl", "pt", "ro", "rs", "ru", "sa", "se", "sg", "si", "sk", "th", "tr", "tw", "ua", "us", "ve", "za"]
  private let categoryArray = ["All", "business", "health", "science", "sports", "technology"]
  var tagButton = 0
  var selectedValue = "ua"
  
  weak var delegate: PickedValueTransfer?
  
  @IBOutlet weak var countryPicker: UIPickerView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    countryPicker.delegate = self
    countryPicker.dataSource = self
    if tagButton == 0 {
      selectedValue = "All"
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    delegate?.pickerDataTransfer(value: selectedValue, tag: tagButton)
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    switch tagButton {
    case 0: return categoryArray.count
    case 1: return countryArray.count
    default:
      return 1
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    switch tagButton {
    case 0: return categoryArray[row]
    case 1: return countryArray[row]
    default:
      return "?"
    }
  }
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    switch tagButton {
    case 0: selectedValue = categoryArray[row]
    case 1: selectedValue = countryArray[row]
    default:
      selectedValue = tagButton == 0 ? "All" : "ua"
    }
  }
}
