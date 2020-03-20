FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y python3-pip build-essential git python3.7-dev wget ca-certificates nginx

WORKDIR /opt/program

ARG algorithm_name

# COPY config/nginx /opt/program
# COPY config/sagemaker_scripts/${algorithm_name} /opt/program
# COPY pipenv/${algorithm_name} /opt/program
COPY src /opt/program/src

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN pip3 install pipenv
RUN pipenv install --ignore-pipfile

# Set some environment variables. PYTHONUNBUFFERED keeps Python from buffering our standard
# output stream, which means that logs can be delivered tor the user quickly. PYTHONDONTWRITEBYTECODE
# keeps Python from writing the .pyc files which are unnecessary in this case. We also update
# PATH so that the train and serve programs are found when the container is invoked.

ENV PYTHONUNBUFFERED=TRUE
ENV PYTHONDONTWRITEBYTECODE=TRUE
ENV PATH="/opt/program:${PATH}"
ENV PYTHONPATH "${PYTHONPATH}:/opt/program"
