//
//  AppDelegate.swift
//  swizzle-swift-ble
//
//  Created by Jacob Rosenthal on 12/24/17.
//  Copyright © 2017 augmentous. All rights reserved.
//

import Cocoa
import CoreBluetooth

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, CBPeripheralManagerDelegate {
    var peripheralManager: CBPeripheralManager?
    var service: CBMutableService?
    var characteristic: CBMutableCharacteristic?
    @IBOutlet weak var window: NSWindow!
    
    override init() {
        super.init()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)

        let serviceUUID = CBUUID(string: "9BC1F0DC-F4CB-4159-BD38-7375CD0DD545")
        service = CBMutableService(type: serviceUUID, primary: true)
        let characteristicUUID = CBUUID(string:  "9BC1F0DC-F4CB-4159-BD38-7B74CD0CD546")
        let properties: CBCharacteristicProperties = [.notify, .read, .write, .indicate, .broadcast]
        let permissions: CBAttributePermissions = [.readable, .writeable]
        characteristic = CBMutableCharacteristic(
            type: characteristicUUID,
            properties: properties,
            value: nil,
            permissions: permissions)
        service?.characteristics = [characteristic!]

    }
    

    func start(){
        
        

        peripheralManager?.add(service!)
        peripheralManager?.startAdvertising( [CBAdvertisementDataLocalNameKey: "Test Device"])
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) {
            
            let data = "ABCD".data(using: .ascii)!

            self.characteristic?.value = data
            self.peripheralManager?.updateValue(
                data,
                for: self.characteristic!,
                onSubscribedCentrals: nil)
    
    
//            self.peripheralManager?.stopAdvertising()
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager)
    {
        switch(peripheral.state){
        case CBManagerState.poweredOn:
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10) {
                self.start()
            }
            break
            
        case .unknown, .resetting, .unsupported, .unauthorized, .poweredOff:
            print("state: ", peripheral.state)
            break;
        }
    }

    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        if let error = error {
            print("error: \(error)")
            return
        }
//        peripheral.remove(service as! CBMutableService)
        
        print("service: \(service)")
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?)
    {
        if let error = error {
            print("Failed… error: \(error)")
            return
        }
        print("started advertising!")
    }

    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        print("peripheralManagerIsReadytoUpdateSubscribers!")
    }
    
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
        if request.characteristic.uuid.isEqual(characteristic?.uuid)
        {
            // Set the correspondent characteristic's value
            // to the request
            request.value = characteristic?.value

            // Respond to the request
            peripheralManager?.respond(
                to: request,
                withResult: .success)
        }

    }

    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        for request in requests
        {
            if request.characteristic.uuid.isEqual(characteristic?.uuid)
            {
                // Set the request's value
                // to the correspondent characteristic
                characteristic?.value = request.value
            }
        }
        peripheralManager?.respond(to: requests[0], withResult: .success)

    }
    


    
    func peripheralManager(_ peripheral: CBPeripheralManager,
        central: CBCentral,
        didSubscribeTo characteristic: CBCharacteristic)
    {
        print("didSubscribeTo")
    }

    
    
    
    func peripheralManager(_ peripheral: CBPeripheralManager,
        central: CBCentral,
        didUnsubscribeFrom characteristic: CBCharacteristic)
    {
        print("didUnsubscribeFrom")
    }
    
    
    
}

