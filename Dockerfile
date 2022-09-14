FROM python:3.8.12-slim-bullseye

LABEL maintainer="Ezako <ezako@ezako.com>" \
      name="Python Container For Machine Learning" \
      description="Packages Essential for Machine Learning with Python" \
      version="1.0"

RUN apt-get update && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y wget default-libmysqlclient-dev default-mysql-client nano apt-utils vim gdb curl libgomp1 iputils-ping g++ libc-dev && \
    apt-get clean && apt-get autoclean && apt-get autoremove
#RUN pip3 install numpy cython pystan==2.19.1.1 holidays==0.11.3.1 pandas==1.1.2 matplotlib convertdate lunarcalendar setuptools-git==1.2 tqdm==4.62.3 --compile --no-cache-dir
RUN pip3 install numpy==1.21 cython pandas==1.1.2 convertdate setuptools-git==1.2 --compile --no-cache-dir
# && \ pip install --upgrade fbprophet==0.7.1 --compile --no-cache-dir
COPY requirements.txt /
RUN pip3 install --trusted-host pypi.python.org -r /requirements.txt --compile --no-cache-dir && \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* /var/cache/apt/archives/*.deb \
    /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin && \
    find /usr/lib/python3 -name __pycache__ | xargs rm -rf && \
    rm -rf /root/.[acpw]*;
RUN pip3 install cdtw
RUN useradd --create-home --shell /bin/bash ml_user
USER ml_user
WORKDIR /home/ml_user
# add pre-trained models
RUN mkdir trained_weights && \
    wget https://storage.googleapis.com/keras-applications/efficientnetb0_notop.h5 -P /home/ml_user/trained_weights/ && \
    wget https://storage.googleapis.com/tensorflow/keras-applications/resnet/resnet50_weights_tf_dim_ordering_tf_kernels_notop.h5 -P /home/ml_user/trained_weights/ 

CMD ["true"]
