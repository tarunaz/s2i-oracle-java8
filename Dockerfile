# arms-streaming
FROM registry.access.redhat.com/rhscl/s2i-base-rhel7

# TODO: Put the maintainer name in the image metadata
# MAINTAINER Priyanka Suchak <suchak@netapp.com>

# TODO: Rename the builder environment variable to inform users about application you provide them
# ENV BUILDER_VERSION 1.0

ENV JAVA_VERSION 1.8.0

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Platform for building Oracle Java 8 App" \
      io.k8s.display-name="builder Oracle-Java8" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,pengg-oracle-java"

# TODO: Install required packages here:
# RUN yum install -y ... && yum clean all -y


RUN wget http://durahc1mn01-stg.corp.netapp.com/extra-packages/java/jdk-8u102-linux-x64.tar.gz && \
    ls -ltr && tar -zxvf jdk-8u102-linux-x64.tar.gz && \
    ls -ltr && rm jdk-8u102-linux-x64.tar.gz
ENV JAVA_HOME=$HOME/jdk1.8.0_102
ENV PATH=$PATH:$JAVA_HOME/bin
#COPY ./contrib $HOME/.

#RUN tar -xvf $HOME/*.tar 

ENV MAVEN_VERSION 3.3.9
RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven

ENV GRADLE_VERSION 2.14
RUN curl -sL -0 https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -o /tmp/gradle-${GRADLE_VERSION}-bin.zip && \
    unzip /tmp/gradle-${GRADLE_VERSION}-bin.zip -d /usr/local/ && \
    rm /tmp/gradle-${GRADLE_VERSION}-bin.zip && \
    mv /usr/local/gradle-${GRADLE_VERSION} /usr/local/gradle && \
    ln -sf /usr/local/gradle/bin/gradle /usr/local/bin/gradle

# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
# RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

# TODO: Set the default port for applications built using this image
# EXPOSE 8080

# TODO: Set the default CMD for the image
# CMD ["/usr/libexec/s2i/usage"]
