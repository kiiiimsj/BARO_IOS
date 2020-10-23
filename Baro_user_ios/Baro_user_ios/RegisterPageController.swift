//
//  RegisterPageController.swift
//  BARO_USER
//
//  Created by 이혜린 on 2020/10/15.
//

import UIKit

class RegisterPageController: UIViewController {
    let controllerTitle: UITextView = {
       let title = UITextView()
        title.textColor = .black
        title.text = "핸드폰 인증하기"
        return title
    }()
    let phoneInputTitle: UITextField = {
        let title = UITextField()
        title.textColor = .white
        title.backgroundColor = .white
        title.borderStyle = .roundedRect
        return title
    }()
    
    let sendAhtuMessage: UIButton = {
        let sendMessage = UIButton()
        sendMessage.tintColor = .white
        sendMessage.backgroundColor = .blue
        sendMessage.setTitle("인증문자 보내기", for: .normal)
        sendMessage.addTarget(self, action: #selector(handleSendAuthMessage(_:)), for: .touchUpInside)
        return sendMessage
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(controllerTitle)
        view.addSubview(phoneInputTitle)
        view.addSubview(sendAhtuMessage)
    }
    
    @objc private func handleSendAuthMessage(_ sender:UIButton) {
    }
}
