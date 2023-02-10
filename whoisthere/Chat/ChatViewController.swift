//
//  ChatViewController.swift
//  whoisthere
//
//  Created by Efe Kocabas on 12/07/2017.
//

import UIKit
import CoreBluetooth

class ChatViewController: UIViewController {

    var device: Device?

    var deviceUUID : UUID? { device?.peripheral.identifier }

//    var deviceAttributes : String = ""
    var selectedPeripheral : CBPeripheral?
    var centralManager: CBCentralManager?
    var peripheralManager = CBPeripheralManager()
    var messages = Array<Message>()
    
    let cellDefinition = "ChatCell"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomContainer: UIView!

    var chatServiceConfig = ChatServiceConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: cellDefinition, bundle: nil), forCellReuseIdentifier: cellDefinition)
        
        centralManager = CBCentralManager(delegate: self, queue: .main)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)

        messageTextField.delegate = self

        registerForKeyboardNotifications()
        
        setDeviceValues()
        sendButton.setTitle("_chat_send_button".localized, for: .normal)
    }

    override func viewWillDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
    }

    @IBAction func sendButtonClick(_ sender: Any) {

        if(!(messageTextField.text?.isEmpty)!) {
            centralManager?.connect(selectedPeripheral!, options: nil)
            messageTextField.resignFirstResponder()
        }
    }

    @objc func keyboardWasShown(notification: NSNotification){
        animateViewMoving(up: true, notification: notification)
    }

    @objc func keyboardWillBeHidden(notification: NSNotification){

        animateViewMoving(up: false, notification: notification)
    }

    func setDeviceValues() {
        //        let deviceData = deviceAttributes.components(separatedBy: "|")

        //        if (deviceData.count > 2) {
        self.navigationItem.title = device?.name ?? "Unknown" // deviceData[0]
        tableView.backgroundColor = device?.user?.color // AvatarPalette(rawValue: ) Constants.colors[Int(deviceData[2])!]
    }

    // Following methods are needed for pushing bottomContainer view up and down when keyboard is shown and hidden.
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func animateViewMoving (up:Bool, notification :NSNotification){
        let movementDuration:TimeInterval = 0.3
        
        let info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let moveValue = keyboardSize?.height ?? 0
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        
        self.bottomContainer.frame = bottomContainer.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    // end of keyboard animation related methods
    
    func updateAdvertisingData() {
        
        if (peripheralManager.isAdvertising) {
            peripheralManager.stopAdvertising()
        }
        
        let user = User()
        chatServiceConfig.setDataDictValue(user.jsonString()!, for: CBAdvertisementDataLocalNameKey)
        peripheralManager.startAdvertising(chatServiceConfig.advertDataDict)
    }
    
//    func initService() {
////        CBMutableService.ini
//        let serialService = CBMutableService(type: WITAdvertData.SERVICE_UUID, primary: true)
//        let rx = CBMutableCharacteristic(type: WITAdvertData.RX_UUID, properties: WITAdvertData.RX_PROPERTIES, value: nil, permissions: WITAdvertData.RX_PERMISSIONS)
//        serialService.characteristics = [rx]
//
//        peripheralManager.add(serialService)
//    }
    
    func appendMessageToChat(message: Message) {
        
        messages.append(message)
        tableView.reloadData()
    }
    
}

extension ChatViewController : CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if (central.state == .poweredOn) {
            self.centralManager?.scanForPeripherals(withServices: [ChatServiceConfiguration.uuid], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if (peripheral.identifier == deviceUUID) {
            
            selectedPeripheral = peripheral
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        
    }
}

extension ChatViewController : CBPeripheralDelegate {
    
    func peripheral( _ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        for service in peripheral.services! {
            
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    private func sendMessage(to peripheral: CBPeripheral, using characteristic: CBCharacteristic) {
        if let messageText = messageTextField.text, let messageData = messageText.data(using: .utf8) {
            peripheral.writeValue(messageData, for: characteristic, type: .withResponse)
            let message = Message(text: messageText, isSent: true)
            appendMessageToChat(message: message)
            messageTextField.text = String()
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            if let chatCharacteristic = characteristics.first(where: { $0.uuid == ChatServiceConfiguration.CharacteristicKeys.rx.uuid }) {
                sendMessage(to: peripheral, using: chatCharacteristic)
            }
        }
    }
}

extension ChatViewController : CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        if (peripheral.state == .poweredOn) {
            peripheral.add(chatServiceConfig.service)
            updateAdvertisingData()
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        
        for request in requests {
            if let value = request.value {
                
                let messageText = String(data: value, encoding: String.Encoding.utf8)
                appendMessageToChat(message: Message(text: messageText!, isSent: false))
            }
            self.peripheralManager.respond(to: request, withResult: .success)
        }
    }
}

extension ChatViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        
        return true
    }
}

extension ChatViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        let cell  = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        if (message.isSent) {
            
            cell.receivedMessage.isHidden = true
            cell.sentMessage.isHidden = false
            cell.sentMessage.text = message.text
            cell.sentMessage.sizeToFit()
        } else {
            
            cell.sentMessage.isHidden = true
            cell.receivedMessage.isHidden = false
            cell.receivedMessage.text = message.text
            cell.receivedMessage.sizeToFit()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
     

    
}
