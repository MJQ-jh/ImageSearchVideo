ARG ARG IMAGE=intersystemsdc/irishealth-community
FROM $IMAGE as builder
USER ${ISC_PACKAGE_MGRUSER}

WORKDIR /opt/ImageSearchVideo

COPY --chown=${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} user /usr/irissys/csp/user
COPY --chown=${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} iris.script iris.script
COPY --chown=${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} src src

USER root

RUN mkdir -p /usr/irissys/mgr/user/images \
    && mkdir -p /usr/irissys/csp/user/videos \
    && apt-get update \
    && apt-get install openbsd-inetd -y \
    && apt-get install ffmpeg libsm6 libxext6  -y \
    && chmod 777 /usr/irissys/mgr/user/images \
    && chmod 777 /usr/irissys/csp/user/videos 


USER ${ISC_PACKAGE_MGRUSER}
RUN python3 -m pip install --target /usr/irissys/mgr/python opencv-python -i https://pypi.tuna.tsinghua.edu.cn/simple --trusted-host pypi.tuna.tsinghua.edu.cn
RUN python3 -m pip install --target /usr/irissys/mgr/python scikit-image -i https://pypi.tuna.tsinghua.edu.cn/simple --trusted-host pypi.tuna.tsinghua.edu.cn
RUN python3 -m pip install --target /usr/irissys/mgr/python nltk -i https://pypi.tuna.tsinghua.edu.cn/simple --trusted-host pypi.tuna.tsinghua.edu.cn

RUN iris start IRIS \
    && iris session IRIS < iris.script \
    && iris stop IRIS quietly
    

