 #The line below determines the build image to use

FROM tensorflow/tensorflow:latest-py3

#The next block determines what dependencies to load

RUN pip3 install pandas
RUN pip3 install numpy
RUN pip3 install matplotlib
RUN pip3 install seaborn
RUN pip3 install statsmodels
RUN pip3 install patsy


#This line determines where to copy project files from, and where to copy them to

COPY . .

#The entrypoint is the command used to start your project

ENTRYPOINT ["python3","python_example.py"]
