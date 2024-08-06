# Landmark Trading Cards

This project is an iOS app that uses a trained CoreML model to recognize landmarks from camera input and unlock trading cards based on the recognized landmarks.

## Prerequisites

- Python 3.8+
- TensorFlow 2.12.1
- CoreMLTools 7.2
- Xcode 12+
- Swift 5.3+
- Roboflow account

## Setup

### Step 1: Export Dataset from Roboflow

1. **Create and Label Dataset**: Create a project in Roboflow and upload your images. Label the images with appropriate classes.
2. **Export Dataset**: Export the dataset in a folder structure. Ensure the folder name is `data`.
3. **Move Dataset**: Move the `data` folder to the root directory where your scripts are located.

### Step 2: Prepare the Environment

1. **Clone the Repository**: Clone this repository to your local machine.
2. **Create a Virtual Environment**:
   ```sh
   python -m venv venv_3.8.12
   source venv_3.8.12/bin/activate
   ```
3. **Install Dependencies**:
   ```sh
	pip install tensorflow==2.12.1 coremltools==7.2
   ```

### Step 3: Train the Model
1. **Train the Model**: Run the `train_model.py` script to train the model and convert it to a CoreML package.
   ```sh
	python train_model.py
   ```

### Step 4: Add ML Package to Xcode Project
1. **Add the Model**: Drag and drop the generated `MobileNetV3.mlpackage` file into your Xcode project under the appropriate target.
2. **Verify the Model**: In Xcode, open the `.mlpackage` file and test with an image in the preview window to ensure the model works correctly.

### Step 5: Integrate into SwiftUI Code
1. **Integrate with SwiftUI Code**: See `CameraViewController.swift` as to how to integreate ML Package into SwiftUI

### Step 6: Run and Test the App
1. **Build and Run**: Build and run the app on a device or simulator
2. **Test the Model**: Use the camera to detect landmarks. Verify the recognized landmarks are being correctly identified.

## Additional Information
- Roboflow: [Roboflow Documention](https://developer.apple.com/documentation/coreml)
- CoreML: [CoreML Document](https://developer.apple.com/documentation/coreml)
- Xcode: [Xcode Documentation](https://developer.apple.com/xcode/)
- SwiftUI: [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)

## License
This project is licensed under the MIT License - see the LICENSE file for details.

