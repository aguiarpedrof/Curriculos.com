-- Criação da tabela de Usuários
CREATE TABLE Usuario (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(120) UNIQUE NOT NULL,
    senha_hash VARCHAR(64) NOT NULL,
    tipo_conta ENUM('gratuita', 'premium') DEFAULT 'gratuita',
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE
);

-- Criação da tabela de Currículos
CREATE TABLE Curriculo (
    id_curriculo INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    titulo VARCHAR(100),
    objetivo TEXT,
    resumo_profissional TEXT,
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

-- Criação da tabela de Formação Acadêmica
CREATE TABLE FormacaoAcademica (
    id_formacao INT PRIMARY KEY AUTO_INCREMENT,
    id_curriculo INT NOT NULL,
    curso VARCHAR(120),
    instituicao VARCHAR(120),
    inicio DATE,
    fim DATE,
    data_atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_curriculo) REFERENCES Curriculo(id_curriculo)
);

-- Criação da tabela de Experiência Profissional
CREATE TABLE ExperienciaProfissional (
    id_experiencia INT PRIMARY KEY AUTO_INCREMENT,
    id_curriculo INT NOT NULL,
    cargo VARCHAR(120),
    empresa VARCHAR(120),
    descricao TEXT,
    inicio DATE,
    fim DATE,
    data_atualizacao DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_curriculo) REFERENCES Curriculo(id_curriculo)
);

-- Criação da tabela de Habilidades
CREATE TABLE Habilidade (
    id_habilidade INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(80) NOT NULL
);

-- Tabela de relação Currículo ↔ Habilidade (N:N)
CREATE TABLE Curriculo_Habilidade (
    id_curriculo INT,
    id_habilidade INT,
    PRIMARY KEY (id_curriculo, id_habilidade),
    FOREIGN KEY (id_curriculo) REFERENCES Curriculo(id_curriculo),
    FOREIGN KEY (id_habilidade) REFERENCES Habilidade(id_habilidade)
);

-- Criação da tabela de Sugestões geradas por IA
CREATE TABLE SugestaoIA (
    id_sugestao INT PRIMARY KEY AUTO_INCREMENT,
    id_curriculo INT,
    tipo_sugestao VARCHAR(100),
    descricao TEXT,
    data_geracao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_curriculo) REFERENCES Curriculo(id_curriculo)
);

-- Criação da tabela de Planos de Assinatura
CREATE TABLE PlanoAssinatura (
    id_plano INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50),
    valor DECIMAL(8,2),
    beneficios TEXT
);

-- Criação da tabela de Pagamentos
CREATE TABLE Pagamento (
    id_pagamento INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT,
    id_plano INT,
    valor_pago DECIMAL(8,2),
    data_pagamento DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pendente', 'concluido', 'cancelado') DEFAULT 'pendente',
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_plano) REFERENCES PlanoAssinatura(id_plano)
);

-- Adicionando índices para melhor performance
CREATE INDEX idx_usuario_email ON Usuario(email);
CREATE INDEX idx_curriculo_usuario ON Curriculo(id_usuario);
CREATE INDEX idx_formacao_curriculo ON FormacaoAcademica(id_curriculo);
CREATE INDEX idx_experiencia_curriculo ON ExperienciaProfissional(id_curriculo);
CREATE INDEX idx_sugestao_curriculo ON SugestaoIA(id_curriculo);

-- Inserindo planos padrão
INSERT INTO PlanoAssinatura (nome, valor, beneficios)
VALUES 
    ('Gratuito', 0.00, 'Acesso básico ao sistema'),
    ('Premium', 29.90, 'Acesso completo + sugestões IA');
