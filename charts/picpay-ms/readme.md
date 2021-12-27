# Picpay Microservice Helm Chart

## Usage

Gerando os arquivos de manifesto:

```sh
# helm template <service> <chart> -f values.yaml -f values.qa.yaml --set global.image.tag=build-16 --debug
helm template test . -f values.yaml -f values.qa.yaml --set global.image.tag=build-16 --debug
```

## Config

As configurações devem ser passadas para o Chart através dos arquivos `Values.yaml`. O padrão é o seguinte:

- `values.yaml`: Contém as configurações comuns entre os ambientes
- `values.qa.yaml`: Faz o override ou adiciona valores para o ambiente de QA
- `values.prod.yaml`: Faz o override ou adiciona valores para o ambiente de PROD

### Example Values.yaml

```yml
# values.yaml
global:
  app_name: example
  image:
    tag: ${artifact.buildNo} # Usado pelo Harness para passar a tag da imagem

# values.qa.yaml
global:
  app_stage: qa

picpay-ms:
  apis: []
  workers: []
  cronjobs: []
```

> `picpay-ms` é o nome do subchart, portanto a configuração sempre deve estar dentro deste objeto.

### Global

Configuração que afeta todos os stages, mas pode ser feito o override

```yml
global:
  app_name: example
  image:
    tag: ${artifact.buildNo}
```

### APIs

```yml
# Example values.qa.yaml
global:
  app_stage: qa

picpay-ms:
  apis:
    - name: api
  image:
    repositoryURI: 289208114389.dkr.ecr.us-east-1.amazonaws.com/picpay-dev/example
    containerPort: 80
  workload: general
  args: "-javaagent:/newrelic/newrelic.jar"
  service:
    enabled: true
    port: 80
  ingress:
    enabled: true
    hosts:
      - hostname: example.ms.qa
      - hostname: qa.example.service.picpay.local
  hpa:
    enabled: true
    min: 1
    max: 5
  limits_memory: 412Mi
  requests_cpu: 100m
  requests_memory: 312Mi
  health:
    path: /health
  readiness: {}
  #   initialDelaySeconds: 30
  liveness: {}
  #   initialDelaySeconds: 30
```

### Workers

```yml
workers:
  - name: example-task
    image: 289208114389.dkr.ecr.us-east-1.amazonaws.com/picpay-dev/example
    entrypoint: /docker-env.sh
    command: php /app/artisan example:example-task
    workload: general
    memory: 128Mi
    cpu: 100m
    pods: 1
    enabled: true
```

### Cronjobs

```yml
cronjobs:
  - name: example-cron
    image: 289208114389.dkr.ecr.us-east-1.amazonaws.com/picpay-dev/example-cron
    entrypoint: /docker-env-cron
    command: /var/www/picpay-backend/core/app/Console/cake.php -working /var/www/picpay-backend/core/app Movements generateAll
    workload: "memory"
    spot_suport: false
    memory: "128Mi"
    cpu: "1000m"
    schedule: "0 1 * * *"
    ttl: 86400 #24hs
    enabled: true
```

### Helm Chart Values

**Global Values:**

| Parameter          | Description                  | Default               |
| ------------------ | ---------------------------- | --------------------- |
| `global.image.tag` | Tag da imagem dos containers | `${artifact.buildNo}` |
| `global.app_name`  | Nome do microserviço         |                       |
| `global.app_stage` | Stage do microserviço        |                       |
