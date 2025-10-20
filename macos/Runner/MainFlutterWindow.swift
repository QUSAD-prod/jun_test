import Cocoa
import FlutterMacOS
import Foundation

@_silgen_name("writeToFile")
func c_writeToFile(_ counter: Int32, _ message: UnsafePointer<CChar>) -> UnsafePointer<CChar>?

@_silgen_name("readFromFile")
func c_readFromFile() -> UnsafePointer<CChar>?

@_silgen_name("deleteFile")
func c_deleteFile() -> UnsafePointer<CChar>?

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    let fileWriterChannel = FlutterMethodChannel(name: "com.qusadprod.filewriter", binaryMessenger: flutterViewController.engine.binaryMessenger)

    fileWriterChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      guard let _ = self else { return }

      switch call.method {
      case "writeToFile":
        guard let args = call.arguments as? [String: Any],
              let counter = args["counter"] as? Int,
              let message = args["message"] as? String else {
          result(FlutterError(code: "INVALID_ARGUMENTS", message: "Неверные аргументы", details: nil))
          return
        }

        let response = Self.callWriteToFile(counter: counter, message: message)
        result(response)

      case "readFromFile":
        let response = Self.callReadFromFile()
        result(response)

      case "deleteFile":
        let response = Self.callDeleteFile()
        result(response)

      default:
        result(FlutterMethodNotImplemented)
      }
    }

    super.awakeFromNib()
  }

  private static func callWriteToFile(counter: Int, message: String) -> String {
    return message.withCString { cString -> String in
      guard let resPtr = c_writeToFile(Int32(counter), cString) else {
        return "Ошибка вызова функции"
      }
      return String(cString: resPtr)
    }
  }

  private static func callReadFromFile() -> String {
    guard let resPtr = c_readFromFile() else {
      return "Ошибка чтения файла"
    }
    return String(cString: resPtr)
  }

  private static func callDeleteFile() -> String {
    guard let resPtr = c_deleteFile() else {
      return "Ошибка удаления файла"
    }
    return String(cString: resPtr)
  }
}
