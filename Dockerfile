FROM centos:latest

# adapted from Mansour's dockerfile https://github.com/mraad/docker-arcgis/ 
MAINTAINER @druidsmith <smith.davidg@epa.gov>

RUN yum -y --nogpg install xorg-x11-server-Xvfb.x86_64 fontconfig freetype gettext less htop vim

RUN mkdir /arcgis

# put your install tgz and prvc in the same folder with the dockerfile when building - rename as needed
ADD ArcGISforServerAdvancedEnterprise_Server.prvc /arcgis/
ADD ArcGIS_for_Server_Linux_1041.tar.gz /arcgis/

ENV USER arcgis
ENV GROUP arcgis

RUN groupadd $GROUP
RUN useradd -m -r $USER -g $GROUP

RUN mkdir -p /arcgis/server
RUN chown -R $USER:$GROUP /arcgis
RUN chmod -R 755 /arcgis

EXPOSE 6080 6443 4001 4002 4004

USER $USER

RUN /arcgis/ArcGISServer/Setup -m silent -l yes -a /arcgis/ArcGISforServerAdvancedEnterprise_Server.prvc -d /

ENTRYPOINT /arcgis/server/startserver.sh && /bin/bash
