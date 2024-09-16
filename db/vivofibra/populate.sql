-- Cliente 1
INSERT INTO clientes (nome, cpf, email, telefone, data_criacao)
VALUES ('Cliente X', '12345678900', 'clientex@exemplo.com', '+5511987654321', CURRENT_TIMESTAMP);

INSERT INTO assinaturas (id_cliente, plano, velocidade, status, data_inicio, data_fim, data_criacao)
VALUES (4, 'Vivo Fibra 300 Mega', '300 Mega', 'active', '2023-01-01', NULL, CURRENT_TIMESTAMP);

INSERT INTO equipamentos (id_assinatura, tipo, modelo, data_instalacao, status)
VALUES (7, 'Roteador', 'Vivo Fibra Router X', '2023-01-02', 'active');

INSERT INTO servicos_adicionais (id_assinatura, descricao, valor_mensal, status, data_inicio, data_fim)
VALUES (7, 'Netflix', 29.90, 'active', '2023-01-01', NULL);

INSERT INTO faturas (id_assinatura, mes_referencia, valor_fatura, status, data_criacao)
VALUES (7, '2023-07', 199.90, 'paid', CURRENT_TIMESTAMP),
       (7, '2023-08', 199.90, 'unpaid', CURRENT_TIMESTAMP);

INSERT INTO pagamentos (id_fatura, data_pagamento, valor_pago, status)
VALUES (1, '2023-07-15', 199.90, 'successful');

INSERT INTO suporte_tecnico (id_cliente, descricao, data_atendimento, status)
VALUES (4, 'Troca de roteador devido a problemas de conectividade', '2023-02-01', 'completed');

-- Cliente 2
INSERT INTO clientes (nome, cpf, email, telefone, data_criacao)
VALUES ('Cliente Y', '98765432100', 'clientey@exemplo.com', '+5511998765432', CURRENT_TIMESTAMP);

INSERT INTO assinaturas (id_cliente, plano, velocidade, status, data_inicio, data_fim, data_criacao)
VALUES (2, 'Vivo Fibra 500 Mega', '500 Mega', 'active', '2023-06-01', NULL, CURRENT_TIMESTAMP);

INSERT INTO equipamentos (id_assinatura, tipo, modelo, data_instalacao, status_equipamento)
VALUES (2, 'Roteador', 'Vivo Fibra Router Y', '2023-06-02', 'active');

INSERT INTO servicos_adicionais (id_assinatura, descricao, valor_mensal, status, data_inicio, data_fim)
VALUES (2, 'Amazon Prime', 19.90, 'active', '2023-06-01', NULL);

INSERT INTO faturas (id_assinatura, mes_referencia, valor_fatura, status_fatura, data_criacao)
VALUES (2, '2023-07', 299.90, 'paid', CURRENT_TIMESTAMP),
       (2, '2023-08', 299.90, 'unpaid', CURRENT_TIMESTAMP);

INSERT INTO pagamentos (id_fatura, data_pagamento, valor_pago, status_pagamento)
VALUES (3, '2023-07-20', 299.90, 'successful');

INSERT INTO suporte_tecnico (id_cliente, descricao, data_atendimento, status)
VALUES (2, 'Instalação do novo roteador na residência', '2023-06-05', 'completed');
