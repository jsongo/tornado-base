from pypy:3
RUN pip install --upgrade pip
RUN pip install tornado
COPY requirements.txt /
RUN pip install -r /requirements.txt
RUN mkdir /app
WORKDIR /app

RUN pip install circus

#EXPOSE 9021 
#CMD ["python", "-m", "tornado.autoreload", "server.py"]

# other operation for the specific app
RUN apt-get update
# RUN apt-get install -y libmysqld-dev
RUN apt-get install -y libpq-dev python-dev python3-dev

# other requirements
ENV MOMOKO_PSYCOPG2_IMPL psycopg2cffi
COPY requirements-others.txt /
RUN pip install -v -r /requirements-others.txt
# 时区
RUN cp /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime

# lxml
#RUN pip install -e git+git://github.com/aglyzov/lxml.git@cffi#egg=lxml-cffi

# circus
COPY circus.ini /etc/
COPY tornado.ini /etc/circus/
ONBUILD COPY run.sh /

ONBUILD ENTRYPOINT ["/run.sh"]
ONBUILD CMD ["bash", "-c"]
