
# Projeto Vivo

Este projeto cria dois bancos de dados simulando os bancos legados da Vivo, um para o produto **Fibra** e outro para o produto **Pós-pago**. O ambiente é provisionado localmente via Docker, com as tabelas sendo criadas automaticamente e populadas com dados dos **clientes X** e **Y**.

## Estrutura do Projeto

- Dois bancos de dados PostgreSQL:
  - **Banco Vivo Fibra**: Armazena informações sobre assinaturas de internet fibra.
  - **Banco Vivo Pós-pago**: Armazena informações sobre linhas móveis pós-pagas.
  
- Docker para subir e configurar os dois bancos localmente, incluindo criação de tabelas e inserção de dados de exemplo.

## Requisitos

- Docker
- Docker Compose

## Configuração do Ambiente

### 1. Estrutura dos Arquivos

O projeto está organizado da seguinte forma:

```
/projeto
    /db
        /vivofibra
            init.sql
        /vivopos
            init.sql
    docker-compose.yml
    README.md
```

### 2. Conteúdo dos Arquivos

#### **docker-compose.yml**

Este arquivo configura dois serviços PostgreSQL para **Fibra** e **Pós-pago**:

```yaml
version: '3.8'
services:
  postgres_vivopos:
    image: postgres:latest
    container_name: postgres_vivopos
    environment:
      POSTGRES_USER: vivo
      POSTGRES_PASSWORD: vivo123
      POSTGRES_DB: vivo_pos
    volumes:
      - pos_data:/var/lib/postgresql/data
      - ./db/vivopos:/docker-entrypoint-initdb.d
    ports:
      - "5433:5432"
    networks:
      - vivo_network

  postgres_vivofibra:
    image: postgres:latest
    container_name: postgres_vivofibra
    environment:
      POSTGRES_USER: vivo
      POSTGRES_PASSWORD: vivo123
      POSTGRES_DB: vivo_fibra
    volumes:
      - fibra_data:/var/lib/postgresql/data
      - ./db/vivofibra:/docker-entrypoint-initdb.d
    ports:
      - "5434:5432"
    networks:
      - vivo_network

volumes:
  pos_data:
  fibra_data:

networks:
  vivo_network:
```

### 3. Scripts de Inicialização (SQL)

#### **Banco Vivo Fibra (`/db/vivofibra/init.sql`)**

O script `init.sql` do banco **Vivo Fibra** cria as tabelas para assinaturas de internet fibra, serviços adicionais, faturas, pagamentos e suporte técnico, além de inserir dados de exemplo para os clientes X e Y.

Exemplo de criação de uma tabela de clientes:

```sql
CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    cpf VARCHAR(11),
    email VARCHAR(100),
    telefone VARCHAR(15),
    data_criacao TIMESTAMP
);

INSERT INTO clientes (nome, cpf, email, telefone, data_criacao)
VALUES ('Cliente X', '12345678900', 'clientex@exemplo.com', '+5511987654321', CURRENT_TIMESTAMP);
```

#### **Banco Vivo Pós-pago (`/db/vivopos/init.sql`)**

O script `init.sql` do banco **Vivo Pós-pago** cria tabelas para as linhas móveis, pacotes de dados, serviços adicionais, faturas, pagamentos, entre outras, e insere os dados dos clientes X e Y.

Exemplo de criação de uma tabela de linhas móveis:

```sql
CREATE TABLE linhas_moveis (
    id_linha SERIAL PRIMARY KEY,
    id_cliente INT REFERENCES clientes(id_cliente),
    numero_linha VARCHAR(20),
    plano VARCHAR(50),
    status VARCHAR(20) CHECK (status IN ('active', 'activating', 'suspended', 'cancelled')),
    data_inicio TIMESTAMP,
    data_fim TIMESTAMP,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO linhas_moveis (id_cliente, numero_linha, plano, status, data_inicio, data_fim, data_criacao)
VALUES (1, '+5511987654321', 'Vivo Pós 20GB', 'active', '2023-01-01', NULL, CURRENT_TIMESTAMP);
```

### 4. Subindo os Bancos Localmente

Para iniciar os bancos de dados localmente, siga os passos abaixo:

1. Certifique-se de que o Docker está instalado e rodando.
2. No diretório raiz do projeto, execute o seguinte comando:

```bash
docker-compose up -d
```

Isso iniciará os dois bancos de dados PostgreSQL, criando as tabelas e inserindo automaticamente os dados de exemplo dos **clientes X e Y**.

### 5. Acessando os Bancos de Dados

Os bancos de dados podem ser acessados via **DBeaver**, **psql** ou outra ferramenta de sua preferência. Aqui estão as configurações de conexão para cada banco:

#### **Vivo Fibra**:
- **Host**: `localhost`
- **Porta**: `5434`
- **Usuário**: `vivo`
- **Senha**: `vivo123`
- **Base de Dados**: `vivo_fibra`

#### **Vivo Pós-pago**:
- **Host**: `localhost`
- **Porta**: `5433`
- **Usuário**: `vivo`
- **Senha**: `vivo123`
- **Base de Dados**: `vivo_pos`

## 6. Configuração Manual do PostgreSQL para Debezium

Você precisará ajustar o arquivo de configuração do PostgreSQL manualmente para que o Debezium consiga capturar as mudanças no banco.

### Passos para acessar o container e editar o arquivo `postgresql.conf`:

1. **Acesse o container** onde o PostgreSQL está rodando:
   ```bash
   docker exec -it postgres_vivopos bash
   ```

2. **Instale o editor `nano` (ou outro editor)** dentro do container, caso ele não esteja disponível:
   ```bash
   apt-get update
   apt-get install nano -y
   ```

3. **Edite o arquivo `postgresql.conf`**:
   O arquivo geralmente está localizado em `/var/lib/postgresql/data/postgresql.conf`. Para editá-lo com o `nano`, rode:
   ```bash
   nano /var/lib/postgresql/data/postgresql.conf
   ```

4. **Adicione as seguintes configurações** para o Debezium:
   ```conf
   wal_level = logical
   max_replication_slots = 4
   max_wal_senders = 4
   wal_keep_size = 16MB
   ```

5. **Salve e saia** do editor `nano`:
   - Pressione `CTRL + O` para salvar.
   - Pressione `CTRL + X` para sair.
   - Exit

5. **Salve e saia** do editor `nano`:
   - docker compose down
   - docker compose up -d.

6. **Rodar** estando fora do container:
   - ./scripts/register_connectors.sh

---


## Podem ajudar
  - kafka-topics --list --bootstrap-server kafka:9092

  - kafka-console-consumer --bootstrap-server localhost:9092 --topic VIVOFIBRA.public.assinaturas --from-beginning

  - docker logs postgres_vivofibra