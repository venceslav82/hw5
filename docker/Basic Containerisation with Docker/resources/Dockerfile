FROM centos:centos7
LABEL maintainer="Ivelin Dimitrov"
RUN yum update -y && yum install -y httpd && rm -rf /var/lib/apt/yum/*
COPY index.html /var/www/html
# CMD ["/usr/sbin/httpd","-D","FOREGROUND"]
ENTRYPOINT ["/usr/sbin/httpd"]
CMD ["-D", "FOREGROUND"]
EXPOSE 80
