//
//  ViewController.swift
//  PhotoMaster
//
//  Created by Shu Fujita on 2020/05/15.
//  Copyright © 2020 Fujita shu. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    //写真表示用
    @IBOutlet weak var photoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onTappedCameraButton() {
          presentPickerController(sourceType: .camera)
      }
    @IBAction func onTappedAlbumButton() {
          presentPickerController(sourceType: .photoLibrary)
      }
    //テキスト合成
    @IBAction func onTappedTextButton() {
          //画像がなかったら関数呼ばない
          if photoImageView.image != nil{
              photoImageView.image = drawText(image: photoImageView.image!)
          }else{
              print("画像がありません")
          }
      }
    //イラスト合成
    @IBAction func onTappedIlustButton() {
          if photoImageView.image != nil{
                    photoImageView.image = drawMaskImage(image: photoImageView.image!)
                }else{
                    print("画像がありません")
                }
      }
    //アップロード
    @IBAction func onTappedUPlpadBUtton(){
          if photoImageView.image != nil{
              //共有するアイテムを設定
              let activityVC = UIActivityViewController(activityItems: [photoImageView.image!, "#PhotoMaster"], applicationActivities: nil)
              self.present(activityVC, animated: true, completion: nil)
          } else{
              print("画像がありません")
          }
      }
    //カメラ、アルバムの呼び出し
       func presentPickerController(sourceType: UIImagePickerController.SourceType){
           if UIImagePickerController.isSourceTypeAvailable(sourceType){
               let picker = UIImagePickerController()
               picker.sourceType = sourceType
               picker.delegate = self
               self.present(picker,animated: true,completion: nil)
            }
        }
    //写真選択時に呼ばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        //画像出力
        photoImageView.image = info[.originalImage]as? UIImage
    }
    
    //元の画像にテキストを合成する
       func drawText(image: UIImage) -> UIImage {
           let text = "LifeisTech!"
           let textFontAttributes = [
               NSAttributedString.Key.font: UIFont(name: "Arial", size: 120)!,
               NSAttributedString.Key.foregroundColor: UIColor.red
           ]
           //グラフィックコンテキスト編集を開始
           UIGraphicsBeginImageContext(image.size)
           //読み込んだ写真の書き出し
           image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
           //範囲の定義
           let margin: CGFloat = 5.0//余白
           let textRect = CGRect(x: margin, y: margin, width: image.size.width - margin, height: image.size.height - margin)
           //以上の設定でtextの書き出し
           text.draw(in: textRect, withAttributes: textFontAttributes)
           let newImage = UIGraphicsGetImageFromCurrentImageContext()
            //グラフィックコンテキスト編集終了
            UIGraphicsEndImageContext()
           
           return newImage!
       }

    //元の画像にイラストを合成するメソッド
       func drawMaskImage(image: UIImage) -> UIImage {
           //マスク画像保存場所設定
           let maskImage = UIImage(named: "furo_ducky")!
               
           //グラフィックコンテキスト生成編集を開始
           UIGraphicsBeginImageContext(image.size)
           //読み込んだ写真の書き出し
           image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
           //範囲の定義
           let margin: CGFloat = 50.0
           let maskRect = CGRect(x: image.size.width - maskImage.size.width - margin,
                                 y: image.size.height - maskImage.size.height - margin,
                                 width: maskImage.size.width,
                                 height: maskImage.size.height)
            //以上の設定でマスク画像の書き出し
           maskImage.draw(in: maskRect)
           let newImage = UIGraphicsGetImageFromCurrentImageContext()
            //グラフィックコンテキスト編集終了
           UIGraphicsEndImageContext()
               
           return newImage!
       }
}
