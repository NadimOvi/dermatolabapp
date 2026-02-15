# TFLite Model Setup

## Download Pre-trained Model

You need to download the skin disease detection TFLite model and place it here.

### Option 1: Use Existing Model
Download from: https://github.com/junaid54541/Skin-Cancer-Classification-Tflite-Model

1. Clone or download the repository
2. Find the `.tflite` file
3. Rename it to `skin_disease_model.tflite`
4. Place it in this directory

### Option 2: Train Your Own Model

1. Download HAM10000 dataset from Kaggle:
   https://www.kaggle.com/datasets/kmader/skin-cancer-mnist-ham10000

2. Train a MobileNet or EfficientNet model using TensorFlow/Keras

3. Convert to TFLite:
```python
import tensorflow as tf

# Load your trained model
model = tf.keras.models.load_model('your_model.h5')

# Convert to TFLite
converter = tf.lite.TFLiteConverter.from_keras_model(model)
converter.optimizations = [tf.lite.Optimize.DEFAULT]
tflite_model = converter.convert()

# Save the model
with open('skin_disease_model.tflite', 'wb') as f:
    f.write(tflite_model)
```

4. Place the generated `skin_disease_model.tflite` file in this directory

## Model Specifications

- **Input**: 224x224x3 RGB image
- **Output**: 7-element array (probabilities for each disease class)
- **Classes**: akiec, bcc, bkl, df, mel, nv, vasc
- **Format**: Float32
- **Quantization**: (Optional) INT8 for better performance

## Testing the Model

Run the app and test with sample images to verify the model works correctly.
