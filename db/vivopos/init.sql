DO
$do$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'replication_debezium') THEN
      CREATE ROLE replication_debezium WITH REPLICATION LOGIN PASSWORD 'vivo123';
   END IF;
END
$do$;

GRANT CONNECT ON DATABASE vivo_fibra TO replication_debezium;

-- Armazena as informações dos clientes que assinam o serviço pós-pago.
CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    cpf VARCHAR(11),
    email VARCHAR(100),
    telefone VARCHAR(15),
    data_criacao TIMESTAMP
);

-- Detalhes sobre as linhas móveis dos clientes.
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

-- Detalhes sobre pacotes de dados contratados, incluindo roaming ou dados extras.
CREATE TABLE pacotes_dados (
    id_pacote SERIAL PRIMARY KEY,
    id_linha INT REFERENCES linhas_moveis(id_linha),
    descricao VARCHAR(255),
    franquia_gb DECIMAL(5,2),
    status VARCHAR(20) CHECK (status IN ('active', 'cancelled')),
    data_inicio TIMESTAMP,
    data_fim TIMESTAMP
);

-- Detalhes sobre as faturas geradas para as linhas móveis.
CREATE TABLE faturas (
    id_fatura SERIAL PRIMARY KEY,
    id_linha INT REFERENCES linhas_moveis(id_linha),
    mes_referencia VARCHAR(10),
    valor_fatura DECIMAL(10,2),
    status VARCHAR(20) CHECK (status IN ('paid', 'unpaid', 'overdue')),
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Histórico de pagamentos efetuados pelos clientes.
CREATE TABLE pagamentos (
    id_pagamento SERIAL PRIMARY KEY,
    id_fatura INT REFERENCES faturas(id_fatura),
    data_pagamento TIMESTAMP,
    valor_pago DECIMAL(10,2),
    status VARCHAR(20) CHECK (status IN ('successful', 'failed'))
);

-- Serviços adicionais como roaming, seguros, ou pacotes de dados extras.
CREATE TABLE servicos_adicionais (
    id_servico SERIAL PRIMARY KEY,
    id_linha INT REFERENCES linhas_moveis(id_linha),
    descricao VARCHAR(255),
    valor_mensal DECIMAL(10,2),
    status VARCHAR(20) CHECK (status IN ('active', 'cancelled')),
    data_inicio TIMESTAMP,
    data_fim TIMESTAMP
);


SELECT * FROM pg_create_logical_replication_slot('debezium_slot_vivopos', 'pgoutput');

CREATE PUBLICATION debezium_publication_vivopos
FOR TABLE public.clientes, public.linhas_moveis, public.pacotes_dados, public.pagamentos, public.faturas, public.servicos_adicionais;