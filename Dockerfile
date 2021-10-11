FROM python:3.7-slim-stretch

LABEL maintainer="Ezako <ezako@ezako.com>" \
      name="Python Container For Machine Learning" \
      description="Packages Essential for Machine Learning with Python" \
      version="1.0"

RUN apt-get update && apt-get upgrade -y && \
    apt-get install --no-install-recommends -y default-libmysqlclient-dev mysql-client nano apt-utils vim gdb curl libgomp1 iputils-ping g++ libc-dev && \
    apt-get clean && apt-get autoclean && apt-get autoremove
COPY requirements.txt /
RUN pip3 install numpy cython pystan holidays==0.9.8 pandas==1.1.2 matplotlib convertdate lunarcalendar --compile --no-cache-dir

RUN pip3 install --trusted-host pypi.python.org -r /requirements.txt --compile --no-cache-dir && \
    pip install --upgrade fbprophet --compile --no-cache-dir && \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* /var/cache/apt/archives/*.deb \
    /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin && \
    find /usr/lib/python3 -name __pycache__ | xargs rm -rf && \
    rm -rf /root/.[acpw]*;
RUN pip3 uninstall matplotlib tensorboard suod h5py -y
RUN useradd --create-home --shell /bin/bash ml_user
USER ml_user
WORKDIR /home/ml_user

CMD ["true"]
