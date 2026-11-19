FROM httpd:2.4
RUN sed -i 's/^#LoadModule proxy_module/LoadModule proxy_module/; s/^#LoadModule proxy_fcgi_module/LoadModule proxy_fcgi_module/' /usr/local/apache2/conf/httpd.conf
COPY php/public/ /var/www/html/
COPY web/httpd-app.conf /usr/local/apache2/conf/extra/app.conf
RUN printf '\nInclude conf/extra/app.conf\n' >> /usr/local/apache2/conf/httpd.conf
