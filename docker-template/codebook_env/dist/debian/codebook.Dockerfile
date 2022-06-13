## docker build --build-arg JHUB_VER=1.4.2 --build-arg PY_VER=3.8 --build-arg DIST=debian --build-arg CODEBOOK_BASE_HASH=a7ee3ce --build-arg DEPLOY_KEY=wt-ephys-no-curation-deploy.pem --build-arg REPO_OWNER=dj-sciops --build-arg REPO_NAME=wt-ephys-no-curation -f codebook.Dockerfile -t registry.vathes.com/sciops/codebook-wt-ephys-no-curation:v0.0.0 .

## Single Stage
ARG JHUB_VER
ARG PY_VER
ARG DIST
ARG CODEBOOK_BASE_HASH
FROM datajoint/djlabhub:${JHUB_VER}-py${PY_VER}-${DIST}-${CODEBOOK_BASE_HASH}

ARG DEPLOY_KEY
COPY --chown=anaconda $DEPLOY_KEY $HOME/.ssh/id_ed25519
RUN chmod u=r,g-rwx,o-rwx $HOME/.ssh/id_ed25519 && \
    printf "ssh\ngit" >> /tmp/apt_requirements.txt && \
    /entrypoint.sh echo "installed"

ARG REPO_OWNER
ARG REPO_NAME
WORKDIR /tmp
RUN ssh-keyscan -t ed25519 github.com >> $HOME/.ssh/known_hosts && \
    git clone git@github.com:${REPO_OWNER}/${REPO_NAME}.git && \
    pip install ./${REPO_NAME} && \
    cp -r ./${REPO_NAME}/notebooks/ /home/ && \
    cp -r ./${REPO_NAME}/images/ /home/notebooks/ || true && \
    cp ./${REPO_NAME}/README.md /home/notebooks/ && \
    rm -rf /tmp/${REPO_NAME} && \
    rm -rf $HOME/.ssh/

WORKDIR /home/notebooks
