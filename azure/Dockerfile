FROM python:3.10.5-slim-bullseye as builder
RUN pip install --user ansible
ENV PATH="/root/.local/bin:${PATH}"
RUN pip install --user -r ~/.local/lib/python3.10/site-packages/ansible_collections/azure/azcollection/requirements-azure.txt
COPY requirements.yml .
RUN ansible-galaxy install -r requirements.yml

FROM python:3.10.5-slim-bullseye
COPY --from=builder /root/.local /root/.local
COPY --from=builder /root/.ansible /root/.ansible
ENV PATH="/root/.local/bin:${PATH}"
COPY 00_azure_class_setup.yml .