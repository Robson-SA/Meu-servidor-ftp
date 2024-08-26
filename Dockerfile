FROM ubuntu:latest

# Instalação de pacotes e configuração do vsftpd
RUN apt-get update && \
    apt-get install -y vsftpd nano ufw && \
    ufw allow 20/tcp && \
    ufw allow 21/tcp && \
    ufw allow 21000:21010/tcp && \
    rm -rf /var/lib/apt/lists/*

# Criar um diretório para o usuário FTP
RUN mkdir -p /home/ftpuser/ftp/files && \
    chmod 777 /home/ftpuser/ftp/files

# Criar um usuário FTP com senha
RUN adduser -m ftpuser && \
    echo "ftpuser:ftppassword" | chpasswd

# Tornando o FTP seguro (comentei para ser opcional)
# RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd.pem -out /etc/ssl/private/vsftpd.pem

# Copiar arquivo de configuração
#COPY vsftpd.conf /etc/vsftpd.conf
COPY vsftpd.userlist /etc/vsftpd.userlist

# Expor porta 21 e faixa de portas passivas
EXPOSE 21 21000-21010

CMD ["/usr/sbin/vsftpd", "/etc/vsftpd.conf"]
