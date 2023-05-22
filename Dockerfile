FROM perl:latest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get upgrade -qqq
RUN cpanm -n App::pepper Term::ReadLine::Gnu
ENTRYPOINT ["/usr/local/bin/pepper"]
