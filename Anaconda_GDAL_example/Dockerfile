FROM continuumio/anaconda3
RUN conda install gdal
COPY . .
ENTRYPOINT ["python","calroad_merge_test.py"]