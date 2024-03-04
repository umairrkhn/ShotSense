import os
from flask import Flask, request, jsonify
from werkzeug.utils import secure_filename
from tensorflow import keras
from tensorflow import keras
import cv2
from keras_video import VideoFrameGenerator
import numpy as np

app = Flask(__name__)

UPLOAD_FOLDER = "uploads"
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER


@app.route("/upload", methods=["POST"])
def upload_file():
    if "file" not in request.files:
        return jsonify({"error": "No file part"})

    file = request.files["file"]

    if file.filename == "":
        return jsonify({"error": "No selected file"})

    if file:
        filename = secure_filename(file.filename)
        file.save(os.path.join(app.config["UPLOAD_FOLDER"], filename))
        return jsonify({"message": "File uploaded successfully", "filename": filename})


@app.route("/predict", methods=["POST"])
def predict():

    labels = [
        "Cover Drive",
        "Cut Shot",
        "Defense",
        "Flick Shot",
        "Hook Shot",
        "Pull Shot",
        "Straight Drive",
        "Sweep",
    ]

    file = request.files["file"]

    if file.filename == "":
        return jsonify({"error": "No selected file"})

    if file:
        filename = secure_filename(file.filename)
        file.save(os.path.join(app.config["UPLOAD_FOLDER"], filename))

    # Define the parameters for FrameGenerator
    frames = VideoFrameGenerator(
        batch_size=1,
        nb_frames=15,
        glob_pattern=f"uploads/{filename}",
    )

    # Load the model
    model = keras.models.load_model("models/vgg16_gru_model")

    # Predict the video
    prediction = model.predict(frames)

    # Find the index of the label with the highest probability
    predicted_label_index = np.argmax(prediction)

    # Get the name of the predicted label
    predicted_label = labels[predicted_label_index]

    return jsonify({"prediction": predicted_label})


if __name__ == "__main__":
    app.run(debug=True)
