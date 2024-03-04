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


@app.route("/predict", methods=["GET"])
def predict():

    labels = [
        "cover",
        "defence",
        "flick",
        "hook",
        "late_cut",
        "lofted",
        "pull",
        "square_cut",
        "straight",
        "sweep",
    ]

    video_path = os.path.join(
        app.config["UPLOAD_FOLDER"], "uploads\cover_0170_vertical.avi"
    )

    # Define the parameters for FrameGenerator
    frames = VideoFrameGenerator(
        batch_size=1,
        nb_frames=15,
        glob_pattern="uploads\sweep_0177_vertical.avi",
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
