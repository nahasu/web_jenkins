FROM ubuntu
                # ubuntu 이미지를 베이스로 활용
LABEL maintainer BABO TT <babo@babo.com>
                # LABEL : 해당 이미지에 대한 정보 maintainer(만든사람)
#RUN sudo su -

RUN apt-get update -y

RUN apt-get install apache2 -y && apt-get install -y wget && apt-get install -y curl

RUN wget https://raw.githubusercontent.com/nahasu/aws_jenkins/main/index.html -O /var/www/html/index.html


RUN a2enmod proxy
RUN a2enmod proxy_http

RUN sed -i '22i\        ProxyPass /app http://app-server' /etc/apache2/sites-available/000-default.conf
RUN sed -i '23i\        ProxyPassReverse /app http://app-server' /etc/apache2/sites-available/000-default.conf

RUN service apache2 restart


WORKDIR /var/www/html

EXPOSE 80
                # http가 80번을 사용하기 때문에 80번 포트를 사용할 수 있도록 한다.
CMD ["apachectl", "-DFOREGROUND"]
