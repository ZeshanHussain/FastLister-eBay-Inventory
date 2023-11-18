// HomeViewController.swift
import UIKit
import SwiftUI
import CodeScanner

protocol HomeViewControllerDelegate: AnyObject {
    func didTapMenuButton()
}

class HomeViewController: UIViewController {

    struct ContentView: View {
        @State private var isPresentingScanner = false
        @State private var scannedCode: String = "Scan a Product to Get Started"

        var scannerSheet: some View {
            CodeScannerView(
                codeTypes: [.qr],
                completion: { result in
                    if case let .success(code) = result {
                        self.scannedCode = code.string
                        self.isPresentingScanner = false
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 500)
                    .stroke(Color.green, lineWidth: 2)
                    .padding(30)
                    .rotationEffect(.degrees(90), anchor: .center)
            )
        }

        var body: some View {
            VStack(spacing: 10) {
                Text(scannedCode)

                Button("SCAN") {
                    self.isPresentingScanner = true
                }
                .sheet(isPresented: $isPresentingScanner) {
                    self.scannerSheet
                }
            }
            .padding()
        }
    }

    weak var delegate: HomeViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Home"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chart.bar.xaxis"), style: .done, target: self, action: #selector(didTapMenuButton))

        // Add a button to launch the QR scanner
        let qrScannerButton = UIButton(type: .system)
        qrScannerButton.setTitle("Scan QR Code", for: .normal)
        qrScannerButton.addTarget(self, action: #selector(didTapQRScannerButton), for: .touchUpInside)

        // You can customize the button appearance here

        view.addSubview(qrScannerButton)

        // Set constraints for the button
        qrScannerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            qrScannerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            qrScannerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    @objc func didTapMenuButton() {
        delegate?.didTapMenuButton()
    }

    @objc func didTapQRScannerButton() {
        // Launch the QR scanner
        let contentView = ContentView()
        let hostingController = UIHostingController(rootView: contentView)
        present(hostingController, animated: true, completion: nil)
    }
}
