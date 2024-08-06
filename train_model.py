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
img_size = (256, 256)
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

# Get class labels
class_labels = list(train_data.class_indices.keys())

# Load MobileNetV3 model
base_model = MobileNetV3Small(weights='imagenet', include_top=False, input_shape=(256, 256, 3))
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
dummy_input = np.zeros((1, 256, 256, 3))
_ = model.predict(dummy_input)

# Explicitly build the model by calling it on some data
model.build(input_shape=(None, 256, 256, 3))

# Convert the model to CoreML and specify iOS14 as the minimum deployment target
coreml_model = ct.convert(
    model,
    source='tensorflow',
    inputs=[ct.ImageType(name="MobilenetV3small_input", shape=(1, 256, 256, 3), color_layout='RGB')],
    classifier_config=ct.ClassifierConfig(class_labels=class_labels),
    minimum_deployment_target=ct.target.iOS14
)

# Save the CoreML model & assign metadata
coreml_model.author = "Brad Grigsby"
coreml_model.license = "Your License"
coreml_model.short_description = "MobileNetV3 Image Classification Model"
coreml_model.version = "1.0"
coreml_model.save('MobileNetV3.mlpackage')

print("CoreML model saved successfully!")
