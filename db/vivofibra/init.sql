DO
$do$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '${POSTGRES_VIVOFIBRA_USER}') THEN
      CREATE ROLE ${POSTGRES_VIVOFIBRA_USER} WITH REPLICATION LOGIN PASSWORD '${POSTGRES_VIVOFIBRA_PASSWORD}';
   END IF;
END
$do$;

GRANT CONNECT ON DATABASE ${POSTGRES_VIVOFIBRA_DBNAME} TO ${POSTGRES_VIVOFIBRA_USER};

-- Armazena as informações dos clientes que assinam o serviço de fibra.
CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    cpf VARCHAR(11),
    email VARCHAR(100),
    telefone VARCHAR(15),
    data_criacao TIMESTAMP
);

-- Detalhes sobre a assinatura de internet fibra.
CREATE TABLE assinaturas (
    id_assinatura SERIAL PRIMARY KEY,
    id_cliente INT REFERENCES clientes(id_cliente),
    plano VARCHAR(50),
    velocidade VARCHAR(20),
    status VARCHAR(20) CHECK (status IN ('active', 'activating', 'suspended', 'cancelled')),
    data_inicio TIMESTAMP,
    data_fim TIMESTAMP,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Informações sobre os equipamentos fornecidos ao cliente (modem, roteadores, etc.).
CREATE TABLE equipamentos (
    id_equipamento SERIAL PRIMARY KEY,
    id_assinatura INT REFERENCES assinaturas(id_assinatura),
    tipo VARCHAR(50),
    modelo VARCHAR(50),
    data_instalacao TIMESTAMP,
    status VARCHAR(20) CHECK (status IN ('active', 'inactive', 'damaged'))
);

-- Registros de atendimento técnico oferecido ao cliente.
CREATE TABLE suporte_tecnico (
    id_suporte SERIAL PRIMARY KEY,
    id_cliente INT REFERENCES clientes(id_cliente),
    descricao TEXT,
    data_atendimento TIMESTAMP,
    status VARCHAR(20) CHECK (status IN ('pending', 'completed', 'cancelled'))
);

-- Detalhes sobre as faturas geradas para o cliente.
CREATE TABLE faturas (
    id_fatura SERIAL PRIMARY KEY,
    id_assinatura INT REFERENCES assinaturas(id_assinatura),
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

-- Serviços adicionais como pacotes de streaming (Netflix, Amazon Prime) oferecidos junto à internet fibra.
CREATE TABLE servicos_adicionais (
    id_servico SERIAL PRIMARY KEY,
    id_assinatura INT REFERENCES assinaturas(id_assinatura),
    descricao VARCHAR(255),
    valor_mensal DECIMAL(10,2),
    status VARCHAR(20) CHECK (status IN ('active', 'cancelled')),
    data_inicio TIMESTAMP,
    data_fim TIMESTAMP
);

SELECT * FROM pg_create_logical_replication_slot('${POSTGRES_VIVOFIBRA_SLOT_NAME}', '${POSTGRES_VIVOFIBRA_PLUGIN_NAME}');

CREATE PUBLICATION ${POSTGRES_VIVOFIBRA_PUBLICATION_NAME}
FOR TABLE public.clientes, public.assinaturas, public.equipamentos, public.pagamentos, public.faturas, public.servicos_adicionais;
