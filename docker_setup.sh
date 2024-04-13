# A shell script to initialize a docker container that will host jupyter notebooks with the conda environment.

set -x
port=8888

echo "Starting Jupyter notebooks"

docker run -i --name=TimeSeriesModelExpriment \
-v $(PWD)/notebooks:/opt/notebooks -t \
-p $port:$port continuumio/anaconda3 bin/bash \
-c "/opt/conda/bin/conda install jupyter -y --quiet && \
    /opt/conda/bin/conda install -c conda-forge hyperopt=0.2.5 -y --quiet && \
    mkdir -p /opt/notebooks && \
    /opt/conda/bin/jupyter notebook --notebook-dir=/opt/notebooks \
    --ip='*' --port=$port --no-browser --allow-root"
