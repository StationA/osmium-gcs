FROM stationa/osmium-tool:latest

# Taken from https://www.ubuntuupdates.org/ppa/canonical_partner?dist=cosmic
RUN sh -c 'echo "deb http://archive.canonical.com/ubuntu/ cosmic partner" >> \
    /etc/apt/sources.list.d/canonical_partner.list' && \
    apt-get update -y && \
    apt-get install google-cloud-sdk -y

ADD exporter.sh /usr/bin/exporter
RUN chmod +x /usr/bin/exporter

ENTRYPOINT ["/usr/bin/exporter"]
