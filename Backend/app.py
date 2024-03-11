import os
from flask import Flask, request, jsonify
from werkzeug.utils import secure_filename
from tensorflow import keras
from keras_video import VideoFrameGenerator
import numpy as np

app = Flask(__name__)

UPLOAD_FOLDER = "/video"
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER

# Load the model
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

model = keras.models.load_model("vgg16_gru_model")


@app.route("/predict", methods=["POST"])
def predict():
    if "file" not in request.files:
        return jsonify({"error": "No file part"})

    file = request.files["file"]

    if file.filename == "":
        return jsonify({"error": "No selected file"})

    # Save the uploaded video file
    filename = secure_filename(file.filename)
    filepath = os.path.join(app.config["UPLOAD_FOLDER"], filename)
    file.save(filepath)

    # Define the parameters for FrameGenerator
    frames = VideoFrameGenerator(
        batch_size=1,
        nb_frames=15,
        glob_pattern=filepath,
    )

    # Predict the video
    prediction = model.predict(frames)

    # Find the index of the label with the highest probability
    predicted_label_index = np.argmax(prediction)

    # Get the name of the predicted label
    predicted_label = labels[predicted_label_index]

    return jsonify({"prediction": predicted_label})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)