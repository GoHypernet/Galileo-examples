FROM hypernetlabs/simulator:ambertools20

USER galileo
WORKDIR /home/galileo
ENV GALILEO_RESULTS_DIR /home/galileo

COPY . .

ENTRYPOINT ["bash","run.sh"]