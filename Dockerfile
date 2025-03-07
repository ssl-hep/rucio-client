FROM opensciencegrid/software-base:24-el9-release

RUN yum install -y epel-release.noarch && \
    yum clean all && \
    rm -rf /var/cache/yum
RUN yum upgrade -y && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN yum install -y python3-pip

RUN yum install -y https://repo.opensciencegrid.org/osg/24-main/osg-24-main-el9-release-latest.rpm
RUN yum install -y https://repo.opensciencegrid.org/osg/24-main/el9/release/x86_64/Packages/v/vo-client-138-1.osg24.el9.noarch.rpm
RUN yum install osg-ca-certs voms voms-clients fetch-crl -y

RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm; \
    curl -s -o /etc/pki/rpm-gpg/RPM-GPG-KEY-wlcg http://linuxsoft.cern.ch/wlcg/RPM-GPG-KEY-wlcg; \
    curl -s -o /etc/yum.repos.d/wlcg-el9.repo http://linuxsoft.cern.ch/wlcg/wlcg-el9.repo;

RUN yum install -y wlcg-voms-atlas wlcg-voms-cms

# Upgrade pip & setuptools and install Rucio
RUN python3 -m pip install --no-cache-dir --upgrade setuptools && \
    python3 -m pip install --no-cache-dir --pre rucio-clients && \
    python3 -m pip install --no-cache-dir jinja2 j2cli pyyaml argcomplete

# enable bash completion for the rucio clients
ADD init_rucio.sh /etc/profile.d/rucio_init.sh
ADD rucio.cfg /opt/rucio/etc/rucio.cfg
ADD gai.conf /etc/gai.conf
ENV PATH=$PATH:/opt/rucio/bin

CMD ["/bin/bash"]
