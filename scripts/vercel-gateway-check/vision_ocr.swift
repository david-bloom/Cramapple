import Vision
import AppKit
import Foundation

let args = CommandLine.arguments
guard args.count > 1, let image = NSImage(contentsOfFile: args[1]) else {
    print("{\"error\": \"could not load image\"}")
    exit(1)
}

guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
    print("{\"error\": \"could not get cgImage\"}")
    exit(1)
}

let semaphore = DispatchSemaphore(value: 0)
var resultsJSON = "[]"

let request = VNRecognizeTextRequest { (request, error) in
    guard let observations = request.results as? [VNRecognizedTextObservation] else {
        semaphore.signal()
        return
    }
    var items: [String] = []
    for obs in observations {
        guard let candidate = obs.topCandidates(1).first else { continue }
        let box = obs.boundingBox
        let text = candidate.string.replacingOccurrences(of: "\"", with: "'")
        let conf = candidate.confidence
        items.append("{\"text\": \"\(text)\", \"confidence\": \(conf), \"x\": \(box.origin.x), \"y\": \(box.origin.y), \"w\": \(box.size.width), \"h\": \(box.size.height)}")
    }
    resultsJSON = "[" + items.joined(separator: ",") + "]"
    semaphore.signal()
}
request.recognitionLevel = .accurate
request.usesLanguageCorrection = false

let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
do {
    try handler.perform([request])
} catch {
    print("{\"error\": \"\(error)\"}")
    exit(1)
}
semaphore.wait()
print(resultsJSON)
