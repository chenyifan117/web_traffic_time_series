# A shell script to initialize a docker container that will host jupyter notebooks with the conda environment.

set -x
port=8888
dataset_folder="/Users/chenyifan/Documents/cel_nb_proj/datasets"
final_dataset_folder="$PWD/notebooks/datasets"

echo "Cloning datasets into folder: $dataset_folder"
rm -r $final_dataset_folder
mkdir -p $final_dataset_folder
cp -r "$dataset_folder/" "$final_dataset_folder/"

echo "Starting Jupyter notebooks"

# Check if the container is already running
if [ "$(docker inspect -f '{{.State.Running}}' $container_name 2>/dev/null)" == "true" ]; then
    echo "Container $container_name is already running."
    docker exec -it $container_name /opt/conda/bin/jupyter notebook --notebook-dir=/opt/notebooks \
    --ip='*' --port=$port --no-browser --allow-root
elif [ "$(docker inspect -f '{{.State.Status}}' $container_name 2>/dev/null)" == "exited" ]; then
    echo "Container $container_name exists but is not running."
    docker start $container_name
    docker exec -it $container_name /opt/conda/bin/jupyter notebook --notebook-dir=/opt/notebooks \
    --ip='*' --port=$port --no-browser --allow-root
else
    echo "Creating and starting new container $container_name."
    docker run -i --name=$container_name \
    -v $(PWD)/notebooks:/opt/notebooks -t \
    -p $port:$port continuumio/anaconda3 bin/bash \
    -c "/opt/conda/bin/conda install jupyter -y --quiet && \
        /opt/conda/bin/conda install -c conda-forge hyperopt=0.2.5 -y --quiet && \
        /opt/conda/bin/conda install -c conda-forge ipywidgets -y --quiet && \
        mkdir -p /opt/notebooks && \
        PYTHONWARNINGS='ignore' /opt/conda/bin/python -Xfrozen_modules=off /opt/conda/bin/jupyter notebook --notebook-dir=/opt/notebooks --ip='*' --port=$port --no-browser --allow-root"
fi