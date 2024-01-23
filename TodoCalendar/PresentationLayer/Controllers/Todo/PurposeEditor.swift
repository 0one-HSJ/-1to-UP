//
//  PurposeEditor.swift
//  TodoCalendar
//
//  Created by 하상준 on 1/21/24.
//

import UIKit

class PurposeEditor: UIViewController {
    private let detailView = PurposeEditorComponents()
    
    override func loadView() {
        self.view = detailView
    }
    
    let mainPurposeManager = MainPurposeManager.shared
    
    var mainPurpose: MainPurpose? {
        didSet {
            temporaryNum = mainPurpose?.color
        }
    }
    var temporaryNum: Int64? = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureUI()
    }
    
    func setup() {
        detailView.mainTextView.delegate = self 
        
        detailView.buttons.forEach { button in
            button.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
        }
        
        detailView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        detailView.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    func configureUI() {
        // 기존데이터가 있을때
        if let mainPurpose = self.mainPurpose {
            self.title = "Edit Purpose"
            
            guard let text = mainPurpose.mainPurposeText else { return }
            detailView.mainTextView.text = text
            
            detailView.mainTextView.textColor = .black
            detailView.saveButton.setTitle("UPDATE", for: .normal)
            detailView.backgroundView.backgroundColor = MyColor(rawValue: mainPurpose.color)?.colors
            detailView.mainTextView.becomeFirstResponder()
    
            
        // 기존데이터가 없을때
        } else {
            self.title = "Make new Purpose"
            
            detailView.mainTextView.text = "Set Purpose."
            detailView.mainTextView.textColor = .lightGray
            detailView.backgroundView.backgroundColor = .lightGray
        }
        setupColorButton(num: temporaryNum ?? 1)
    }
    //MARK: - Helpers
    func setupColorButton(num: Int64) {
        switch num {
        case 1:
            detailView.firstButton.backgroundColor = MyColor.first.colors
            detailView.firstButton.setTitleColor(.white, for: .normal)
        case 2:
            detailView.secondButton.backgroundColor = MyColor.second.colors
            detailView.secondButton.setTitleColor(.white, for: .normal)
        case 3:
            detailView.thirdButton.backgroundColor = MyColor.third.colors
            detailView.thirdButton.setTitleColor(.white, for: .normal)
        default:
            detailView.firstButton.backgroundColor = MyColor.first.colors
            detailView.firstButton.setTitleColor(.white, for: .normal)
        }
    }
    
    // 다른 곳을 터치하면 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setupColorTheme(color: MyColor? = .first) {
        detailView.backgroundView.backgroundColor = color?.colors
        detailView.saveButton.backgroundColor = color?.colors
    }
    
    func clearButtonColors() {
        detailView.firstButton.backgroundColor = MyColor.first.colors
        detailView.firstButton.setTitleColor(MyColor.first.colors, for: .normal)
   
        detailView.secondButton.backgroundColor = MyColor.second.colors
        detailView.secondButton.setTitleColor(MyColor.second.colors, for: .normal)

        detailView.thirdButton.backgroundColor = MyColor.third.colors
        detailView.thirdButton.setTitleColor(MyColor.third.colors, for: .normal)
    }
    
    //MARK: - Actions
    @objc func colorButtonTapped(_ sender: UIButton) {
        // 임시숫자 저장
        self.temporaryNum = Int64(sender.tag)
        let color = MyColor(rawValue: Int64(sender.tag))
        setupColorTheme(color: color)
        clearButtonColors()
        setupColorButton(num: Int64(sender.tag))
    }

    @objc func saveButtonTapped(num: Int64) {
        if let mainPurpose = self.mainPurpose {
            mainPurpose.mainPurposeText = detailView.mainTextView.text
            mainPurpose.color = temporaryNum ?? 1
            
            mainPurposeManager.update(mainPurpose: mainPurpose, newText: mainPurpose.mainPurposeText, newColor: mainPurpose.color) {
                print("update 완료")
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            let text = detailView.mainTextView.text
            let color = temporaryNum ?? 1
            
            mainPurposeManager.saveData(mainPurposeText: text, color: color) {
                print("새로 저장 완료")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc func deleteButtonTapped() {
        if let mainPurpose = self.mainPurpose {
            mainPurpose.mainPurposeText = detailView.mainTextView.text
            mainPurpose.color = temporaryNum ?? 1
            
            mainPurposeManager.delete(mainPurpose: mainPurpose) {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            print("deleted")
            self.navigationController?.popViewController(animated: true)
            }
        }
    }


extension PurposeEditor: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Set Purpose." {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    // 입력이 끝났을때
    func textViewDidEndEditing(_ textView: UITextView) {
        // 비어있으면 다시 플레이스 홀더처럼 입력하기 위해서 조건 확인
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "Set Purpose."
            textView.textColor = .lightGray
        }
    }
}
