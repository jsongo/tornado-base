from python:3.5
RUN pip install --upgrade pip
RUN pip install tornado
COPY requirements*.txt /
RUN pip install -r /requirements.txt
RUN mkdir /app
WORKDIR /app

RUN pip install circus

#EXPOSE 9021 
#CMD ["python", "-m", "tornado.autoreload", "server.py"]

# other operation for the specific app
RUN apt-get update
# RUN apt-get install -y libmysqld-dev
RUN apt-get install -y libpq-dev python-dev

# basic 
# ENV MOMOKO_PSYCOPG2_IMPL psycopg2cffi
RUN pip install -r /requirements-basic.txt

# other requirements
# RUN pip install -r /requirements-other.txt

# wechat requirements
# RUN pip install -r /requirements-wechat.txt

# 时区
RUN cp /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime

# circus
COPY circus.ini /etc/
COPY tornado.ini /etc/circus/
ONBUILD COPY run.sh /

ONBUILD ENTRYPOINT ["/run.sh"]
ONBUILD CMD ["bash", "-c"]
