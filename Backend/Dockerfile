FROM python:3.11-slim
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt
RUN apt-get update && apt-get install ffmpeg libsm6 libxext6 libgl1-mesa-glx libglib2.0-0 -y
EXPOSE 8000
CMD python ./app.py