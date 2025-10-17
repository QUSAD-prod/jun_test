import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let fileWriterChannel = FlutterMethodChannel(name: "com.qusadprod.filewriter", binaryMessenger: controller.binaryMessenger)
    
    fileWriterChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      
      switch call.method {
      case "writeToFile":
        guard let args = call.arguments as? [String: Any],
              let counter = args["counter"] as? Int,
              let message = args["message"] as? String else {
          result(FlutterError(code: "INVALID_ARGUMENTS", message: "Неверные аргументы", details: nil))
          return
        }
        
        let fileContent = self.callWriteToFile(counter: counter, message: message)
        result(fileContent)
        
      case "readFromFile":
        let fileContent = self.callReadFromFile()
        result(fileContent)
        
      case "deleteFile":
        let deleteResult = self.callDeleteFile()
        result(deleteResult)
        
      default:
        result(FlutterMethodNotImplemented)
      }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func callWriteToFile(counter: Int, message: String) -> String {
    guard let result = writeToFile(Int32(counter), message) else {
      return "Ошибка вызова функции"
    }
    return String(cString: result)
  }
  
  private func callReadFromFile() -> String {
    guard let result = readFromFile() else {
      return "Ошибка чтения файла"
    }
    return String(cString: result)
  }
  
  private func callDeleteFile() -> String {
    guard let result = deleteFile() else {
      return "Ошибка удаления файла"
    }
    return String(cString: result)
  }
}
