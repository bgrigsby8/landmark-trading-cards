import tensorflow as tf
from tensorflow.keras.applications import MobileNetV3Small
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.optimizers import Adam
import coremltools as ct
import numpy as np
import os

# Paths
train_dir = './data/train'
val_dir = './data/valid'  # Updated directory name

# Parameters
img_size = (224, 224)
batch_size = 32
num_classes = 2  # Adjusted based on your dataset
epochs = 10

# Data preparation
datagen = ImageDataGenerator(rescale=1./255, validation_split=0.2)

train_data = datagen.flow_from_directory(
    train_dir,
    target_size=img_size,
    batch_size=batch_size,
    class_mode='categorical',
    subset='training'
)

val_data = datagen.flow_from_directory(
    val_dir,
    target_size=img_size,
    batch_size=batch_size,
    class_mode='categorical'
)

# Verify the number of images in each set
print(f'Found {train_data.samples} training images belonging to {train_data.num_classes} classes.')
print(f'Found {val_data.samples} validation images belonging to {val_data.num_classes} classes.')

# Load MobileNetV3 model
base_model = MobileNetV3Small(weights='imagenet', include_top=False, input_shape=(224, 224, 3))
base_model.trainable = False

# Add classification head
model = tf.keras.Sequential([
    base_model,
    tf.keras.layers.GlobalAveragePooling2D(),
    tf.keras.layers.Dense(num_classes, activation='softmax')
])

# Compile the model
model.compile(optimizer=tf.keras.optimizers.legacy.Adam(), loss='categorical_crossentropy', metrics=['accuracy'])

# Train the model
model.fit(train_data, validation_data=val_data, epochs=epochs)

# Save the model in the recommended format
model.save('mobilenetv3_model.keras')

# Call the model on some data to ensure inputs and outputs are defined
dummy_input = np.zeros((1, 224, 224, 3))
_ = model.predict(dummy_input)

# Explicitly build the model by calling it on some data
model.build(input_shape=(None, 224, 224, 3))

# Define the input and output features with appropriate types
input_features = ct.ImageType(name="MobilenetV3small_input", shape=(1, 224, 224, 3), color_layout=ct.colorlayout.RGB)

# Convert the model to CoreML
coreml_model = ct.convert(
    model, 
    inputs=[input_features], 
    source='tensorflow', 
    minimum_deployment_target=ct.target.iOS14
)

# Add metadata
coreml_model.short_description = "MobileNetV3 Image Classification Model"
coreml_model.author = "Brad Grigsby"
coreml_model.license = "Your License"

# Save the CoreML model
coreml_model.save('MobileNetV3.mlpackage')

print("CoreML model saved successfully!")
