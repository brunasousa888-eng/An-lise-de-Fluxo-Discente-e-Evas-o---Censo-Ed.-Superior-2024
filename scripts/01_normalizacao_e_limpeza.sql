/* ETAPA 1: CRIAÇÃO DA TABELA DE STAGING (BRUTA)
   Uso de TEXT para garantir que nenhum dado seja perdido na importação.
*/
DROP TABLE IF EXISTS fluxo_discente_bruto;

CREATE TABLE fluxo_discente_bruto (
    no_regiao TEXT,
    sg_uf TEXT,
    co_ies TEXT,
    no_ies TEXT,
    co_curso TEXT,
    no_curso TEXT,
    in_gratuito TEXT,
    qt_vg_total TEXT,
    qt_mat TEXT,
    qt_conc TEXT,
    qt_sit_desvinculado TEXT,
    nu_ano_censo TEXT
);

/* ETAPA 2: NORMALIZAÇÃO - TABELA DE INSTITUIÇÕES (IES)
   Limpeza de duplicatas usando GROUP BY e conversão de tipos.
*/
DROP TABLE IF EXISTS cursos; -- Remover dependência primeiro
DROP TABLE IF EXISTS instituicoes;

CREATE TABLE instituicoes AS
SELECT 
    co_ies::INTEGER, 
    MAX(sg_uf) as sg_uf, 
    MAX(NULLIF(in_gratuito, '')::INTEGER) AS in_gratuito
FROM fluxo_discente_bruto
GROUP BY co_ies;

ALTER TABLE instituicoes ADD PRIMARY KEY (co_ies);

/* ETAPA 3: NORMALIZAÇÃO - TABELA DE CURSOS
   Criação de tabela com métricas numéricas para cálculos estatísticos.
*/
CREATE TABLE cursos AS
SELECT 
    co_curso::INTEGER,
    no_curso,
    co_ies::INTEGER,
    NULLIF(qt_vg_total, '')::INTEGER AS qt_vg_total,
    NULLIF(qt_mat, '')::INTEGER AS qt_mat,
    NULLIF(qt_conc, '')::INTEGER AS qt_conc,
    NULLIF(qt_sit_desvinculado, '')::INTEGER AS qt_sit_desvinculado
FROM fluxo_discente_bruto;

-- Definindo o Relacionamento (Chave Estrangeira)
ALTER TABLE cursos 
ADD CONSTRAINT fk_ies_curso 
FOREIGN KEY (co_ies) REFERENCES instituicoes (co_ies);

/* ETAPA 4: VALIDAÇÃO DOS DADOS
   Teste rápido para garantir que o relacionamento (JOIN) está funcionando.
*/
SELECT 
    i.sg_uf, 
    c.no_curso, 
    c.qt_mat,
    c.qt_sit_desvinculado
FROM cursos c
JOIN instituicoes i ON c.co_ies = i.co_ies
LIMIT 10;
