# Helm Charts

PicPay helm charts

## Como validar o Helm Chart

Baixe e instale o [Helm](https://helm.sh/)

Vá até o diretório de seu serviço, exemplo `services/ms-rundeck`.
Você pode executar os comandos abaixo para gerar os manifestos do Kubernetes e validar se todas as informações estão validas.

```sh
helm template --values values.qa.yaml . --debug
helm template --values values.prod.yaml . --debug
```

Caso queria validar os arquivos do gerados, você pode usar o [kubeval](https://github.com/instrumenta/kubeval).

```sh
helm template --values values.qa.yaml . --debug | kubeval
```

## Getting started

We use the `helm` namespace for keeping the chart history, but the services are deployed in its own namespaces

> Always change to `helm` namespace before deploying resources to kubernetes using helm

**NOTE: To change between clusters and namespaces use [kubectx](https://github.com/ahmetb/kubectx)**

### Update a chart dependency

```sh
helm dependency update
```

### Test template

```sh
cd services/ms-{service}
helm template --values values.prod.yaml . --debug
```

### Validating a Kubernetes files

```sh
cd services/ms-{service}
helm template --values values.prod.yaml . --debug | kubeval
```

### Upload chart to chartmuseum

```sh
./chart.sh upload searches
```

You will need to install [kubeval](https://github.com/instrumenta/kubeval)

### Creating empty chart

```sh
helm create CHART_NAME
```

### Installing chart in the cluster

```sh
# Change to helm namespace
kns helm
helm install CHART_NAME . --values values.yaml --set image.tag=IMAGE_TAG --set app.state=STAGE
```

### Deploying a new revision

```sh
kns helm
helm upgrade CHART_NAME . --values values.yaml --set image.tag=IMAGE_TAG --set app.state=STAGE
```

### Check created resources

```sh
kns CHART_NAME
kubectl get all
```

---

### Rolling back

#### Check revisions history

```sh
helm history CHART_NAME
```

| REVISION | UPDATED                  | STATUS     | CHART            | APP VERSION | DESCRIPTION      |
|----------|--------------------------|------------|------------------|-------------|------------------|
| 9        | Fri Jan 31 20:36:11 2020 | superseded | CHART_NAME-0.1.0 | 1.16.0      | Upgrade complete |
| 10       | Fri Jan 31 20:42:15 2020 | superseded | CHART_NAME-0.1.0 | 1.16.0      | Upgrade complete |
| 11       | Fri Jan 31 20:47:42 2020 | superseded | CHART_NAME-0.1.0 | 1.16.0      | Upgrade complete |
| 12       | Fri Jan 31 20:53:29 2020 | superseded | CHART_NAME-0.1.0 | 1.16.0      | Upgrade complete |

#### Rollback to revision

```sh
helm rollback CHART_NAME 11
```

---

### Helper commands

#### List charts

```sh
helm ls
```

#### Chart status

```sh
helm status CHART_NAME
```

#### Get manifest files

```sh
helm get manifest CHART_NAME
```

---

## Dicas

- Documentação para usar HPA customizado [aqui](https://picpay.atlassian.net/wiki/spaces/E/pages/1244790832/Custom+metrics+para+HPA)
