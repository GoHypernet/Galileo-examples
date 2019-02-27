FROM tensorflow/tensorflow:latest-py3
RUN pip install comet_ml
COPY . .
ENTRYPOINT ["python","learn.py"]