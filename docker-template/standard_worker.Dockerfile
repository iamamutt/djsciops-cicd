ARG PY_VER
ARG DIST
ARG WORKER_BASE_HASH
FROM datajoint/djbase:py${PY_VER}-${DIST}-${WORKER_BASE_HASH}

ARG DEPLOY_KEY
COPY --chown=anaconda $DEPLOY_KEY $HOME/.ssh/id_ed25519
RUN chmod 400 $HOME/.ssh/id_ed25519 && \
    printf "ssh\ngit" >> /tmp/apt_requirements.txt && \
    /entrypoint.sh echo "installed"

ARG REPO_OWNER
ARG REPO_NAME
WORKDIR $HOME
RUN ssh-keyscan github.com >> $HOME/.ssh/known_hosts && \
    git clone git@github.com:${REPO_OWNER}/${REPO_NAME}.git && \
    pip install ./${REPO_NAME}