ARG BASEIMAGE=ashenm/workspace:latest

FROM ${BASEIMAGE}

# avoid prompts
ARG ACCEPT_EULA=Y
ARG DEBIAN_FRONTEND=noninteractive

RUN sudo --set-home --preserve-env=ACCEPT_EULA,DEBIAN_FRONTEND apt-get install --yes --no-install-recommends \
    msodbcsql18 \
    mssql-tools18 \
    unixodbc-dev

# install python packages
RUN sudo --set-home python3 -m pip install --no-cache-dir --ignore-installed \
    alembic \
    pyodbc

ENV PATH /opt/mssql-tools18/bin:$PATH
