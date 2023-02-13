//
//  RegisterViewController.swift
//  whoisthere
//
//  Created by Efe Kocabas on 10/07/2017.
//  Copyright (c) 2017 Efe Kocabas. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var pickColorButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var isUpdateScreen : Bool = false

    var storageManager: StorageManager { .shared }


    var user = User()
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = User()
        isUpdateScreen = user.hasAllDataFilled
        setupUI()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? AvatarPickerViewController {
            controller.selectionDelegate = self
        } else if let controller = segue.destination as? ColorPickerViewController {
            controller.selectionDelegate = self
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        user.name = nameTextField.text ?? ""
        nameTextField.resignFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
        initData()
    }

    @IBAction func nextButtonClick(_ sender: Any) {
        user.name = nameTextField.text ?? ""
        if (user.avatar == .none) {
            AlertHelper.warn(delegate: self, message: "_alert_choose_avatar".localized)
        } else if (user.name.isEmpty) {
            AlertHelper.warn(delegate: self, message: "_alert_enter_name".localized)
        } else {
            storageManager.setCurrentUser(user)
            if (isUpdateScreen) {
                self.navigationController?.popViewController(animated: true)
            } else {

                if let target = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
                    target.navigationItem.hidesBackButton = true;
                    self.navigationController?.pushViewController(target, animated: true)
                }
            }
        }
    }

    func initData() {
        self.navigationItem.title = user.hasAllDataFilled ? "_register_title".localized : "_profile_title".localized

        let buttonTitle = user.hasAllDataFilled ? "_save".localized : "_next".localized
        nextButton.setTitle(buttonTitle, for: .normal)

        avatarButton.setImage(user.avatar.uiImage, for: .normal) // UIImage(named: String(format: "%@%d", Constants.kAvatarImagePrefix, user.avatarId)), for: UIControlState.normal)
        self.view.backgroundColor = user.color

        nameTextField.text = user.name
    }

    
    func setupUI() {
        nextButton.layer.cornerRadius = 10
        nameTextField.delegate = self
        pickColorButton.setTitle("_register_pick_color".localized, for: .normal)
    }

//    func saveName() {
//        var user = User()
//        let name: String = nameTextField.text ?? ""
//        user.name = name
//
//        storageManager.save(user)
//    }


    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        
        return true
    }
}


extension RegisterViewController: IndexSelectionDelegate {
    func indexIsSelected(_ valueSelector: UICollectionViewController, at index: Int) -> Bool {
        if let _ = valueSelector as? AvatarPickerViewController {
            return user.avatar.id == index
        } else if let _ = valueSelector as? ColorPickerViewController {
            return user.paletteValue == index
        } else {
            return false
        }
    }

    func indexSelector(_ valueSelector: UICollectionViewController, didSelect valueIndex: Int) {
        if let _ = valueSelector as? AvatarPickerViewController {
            user.avatar = Avatar(rawValue: valueIndex) ?? .none
            avatarButton.setImage(user.avatar.uiImage, for: .normal)
        } else if let _ = valueSelector as? ColorPickerViewController {
            user.paletteValue = valueIndex
        }
    }
}
